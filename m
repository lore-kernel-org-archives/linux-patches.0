Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497A11CAA86;
	Wed, 19 Feb 2025 09:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957184; cv=none; b=VD8BiBnhLQg1uO1sOvB5CiOdee+3ycB/MmwlvhVba+lZHp5AeIW7IPTlwgpaLfXZYHg5mukGwhbilV59oBwNDFhunkPXzS0pr5PKnuxZsKqFKsxTpjuEkNt2RlSyiVHKvVEpeYNRwimWEYfXk7aLJmxMXmiiwL5kQorae3XsAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957184; c=relaxed/simple;
	bh=ZYeUZp6wk2F4GBk82U2MKJ7mbwmyY+wlovXtpaEp7Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCn4FbExQ9cdxCPAsARCRND0Z/8/wUTx1IGCO3LsNuiNZtaaGbFJe6ht0SgBsGcgdoieCjrYu2ZElOR1HDPx02/4dA0J20YHvj2scOJVkSzNqKyTogTnrX69w4fNnQ6CsWIDNBpr3gRlcS/5o16oc9PagX2otszKt0BMMuI3aH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIqAvEpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIqAvEpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D237C4CED1;
	Wed, 19 Feb 2025 09:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957183;
	bh=ZYeUZp6wk2F4GBk82U2MKJ7mbwmyY+wlovXtpaEp7Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIqAvEpKYLDpmDo+h4H7qL2SDhIQkbhRh47wv27PpyA805wd6D2I5/cbV9A3vB4kr
	 F+cq+UBQidKPW7qivSg/eAUHR7wUBg2QxssVVyC06Yf+gwYKbmvmGqEfa+vxzxBsC4
	 esWVyexuK9lXDTWdXL+fjl72brfCq/88RXPXuQ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 437/578] net/ncsi: wait for the last response to Deselect Package before configuring channel
Date: Wed, 19 Feb 2025 09:27:21 +0100
Message-ID: <20250219082710.198219422@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit 6bb194d036c6e1b329dcdff459338cdd9a54802a upstream.

The NCSI state machine as it's currently implemented assumes that
transition to the next logical state is performed either explicitly by
calling `schedule_work(&ndp->work)` to re-queue itself or implicitly
after processing the predefined (ndp->pending_req_num) number of
replies. Thus to avoid the configuration FSM from advancing prematurely
and getting out of sync with the process it's essential to not skip
waiting for a reply.

This patch makes the code wait for reception of the Deselect Package
response for the last package probed before proceeding to channel
configuration.

Thanks go to Potin Lai and Cosmo Chou for the initial investigation and
testing.

Fixes: 8e13f70be05e ("net/ncsi: Probe single packages to avoid conflict")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Link: https://patch.msgid.link/20250116152900.8656-1-fercerpav@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ncsi/ncsi-manage.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1385,6 +1385,12 @@ static void ncsi_probe_channel(struct nc
 		nd->state = ncsi_dev_state_probe_package;
 		break;
 	case ncsi_dev_state_probe_package:
+		if (ndp->package_probe_id >= 8) {
+			/* Last package probed, finishing */
+			ndp->flags |= NCSI_DEV_PROBED;
+			break;
+		}
+
 		ndp->pending_req_num = 1;
 
 		nca.type = NCSI_PKT_CMD_SP;
@@ -1501,13 +1507,8 @@ static void ncsi_probe_channel(struct nc
 		if (ret)
 			goto error;
 
-		/* Probe next package */
+		/* Probe next package after receiving response */
 		ndp->package_probe_id++;
-		if (ndp->package_probe_id >= 8) {
-			/* Probe finished */
-			ndp->flags |= NCSI_DEV_PROBED;
-			break;
-		}
 		nd->state = ncsi_dev_state_probe_package;
 		ndp->active_package = NULL;
 		break;


