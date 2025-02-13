Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF3D18DF6D;
	Thu, 13 Feb 2025 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461012; cv=none; b=HDhnfhzjiqt1GEPb6WjQfLOjLeULGr2YX0q8IIzQU789tCZrnr7m/oz9GJoqT7sr7AB++1npkgpkIJ0HA55Uzh/UhS/WNdZk8MYeeUpMr0UaHaJEQOZ6iRF3LarjxSc5a15CsiBB1wRN6YzR91dIS4bZRV99uH5OAaUYoyjl+aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461012; c=relaxed/simple;
	bh=RVDKxQZoj9CUmoD9jm/msJpnubY53AZgJLnqbveLbhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLwwmMDpVCI8Y8wB4reckDLe1Qcn9jdmG6AdK6OCaYwwZEJ0RhXu0oaSCYBdl/rt41tcIm8oMfGAEPCe4vsu8uhwTzmR5lbxC7CZzd0KIK6cwjddil3zv1IiG6eqlwwR/sZcFyv3ahS++WZp9DiIsCR1pgIQJAkFZciKxGCXpyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ey2t5dWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ey2t5dWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46CDC4CED1;
	Thu, 13 Feb 2025 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461012;
	bh=RVDKxQZoj9CUmoD9jm/msJpnubY53AZgJLnqbveLbhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ey2t5dWyOAef054WZ3fxW8YqJqVE2ZOSSyL0ce3pxPWEklXxsIzl3pmKAwezpNr9H
	 PtxziblgoFkCbCALO51mwEXaxMWJX1aKhdW9ttVvNGOdZj4lrob0IAa2fdIYDY9jHL
	 hue7mg6mQ/t8D+WdTBTEMigpXR26ONTO3k/NILcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 245/273] net/ncsi: wait for the last response to Deselect Package before configuring channel
Date: Thu, 13 Feb 2025 15:30:17 +0100
Message-ID: <20250213142417.116378192@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


