Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5E335BA;
	Thu, 13 Feb 2025 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460059; cv=none; b=XXSD5przi89XKWdQhHW07EDwao06j7IxgqjyfXbcHnfeZ7fiyiMu4IvZLTtY6WlHh0iYM1ovTt3qDhF0c97bhQHvok2wc7JcK6FI2hHgmHldDAIC43D2+wfZzyIHGHDMGO4rOUFTV4+O/h8bzTkYPKO7O9aPaCVzqbklUVqfsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460059; c=relaxed/simple;
	bh=FUlUg1eHLScMVnYCTao6Cf/Y5LuCDyf3HNA2Y3zS+FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMmAhO5c0adTYLHVyzfX2Iz+GPr7d7y0txbCvmOC+ZBNdlwJ383lXBMYbGINSOL1k5g6xo3YQfQ374NvJ5BsQr4NkSrfZFPc2QIMaTdJ6my9pU5MmpoK63+YHNYR7YBYCrfHljjL98Mc8oQMqC1s8+etW25ce4qCHK2Fu4Fc1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7NlEvZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7NlEvZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49498C4CEE7;
	Thu, 13 Feb 2025 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460059;
	bh=FUlUg1eHLScMVnYCTao6Cf/Y5LuCDyf3HNA2Y3zS+FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7NlEvZkPWfc+Z57h2kSiDYGAs6r5JPPXbYXmRF8bwlP9424FOmmk9pfPph6PPauy
	 jeSfRRXmvYIy51QRSvHbvmGTL+ovENtG/hkFTSt3GjACU68Oma7FMRi5ha3Jt251KT
	 w6XWglOFDqNc4v3X1j0EHmqMA+aDx+zvkkwT9To0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 415/443] net/ncsi: wait for the last response to Deselect Package before configuring channel
Date: Thu, 13 Feb 2025 15:29:40 +0100
Message-ID: <20250213142456.622745314@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


