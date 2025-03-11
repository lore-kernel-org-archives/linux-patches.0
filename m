Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B4B25B676;
	Tue, 11 Mar 2025 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706938; cv=none; b=dnGib2KLs5VH0sNTWobg+VVx1GoWA01/GRJSntOjiqKjpqdiQmdO0FGw8RRXMR/hFv8XRNrvG6AZrY+b7v3CdLjcuxR2mubmAEJY2cjekrUv+ILbgoS8+9D4qCbS+87RsGV3VEJ6Yun2AKBlRrOqxTUw2NM1nC9spolRPFBXgvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706938; c=relaxed/simple;
	bh=AobJAF72IgYl/H9qNP7YH+QoWOwZiqPbVRSleD/KXaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kogd7OiosLSafOOa0Y1XlpgWl3N+Rswfyye9bHp8CUy1hlZC5TY6yQxYlyPit8xyUuSbuLncWsq4yeF+JlQd/P/1CyDc0slt+JVL/96ggIQsokuB2v09L+o5A1GOKC9vZOTwrYBn41zkyJREuCftYnEgk1g99cEKtymSM7Qq5R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f84+l4o1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f84+l4o1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406D6C4CEE9;
	Tue, 11 Mar 2025 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706938;
	bh=AobJAF72IgYl/H9qNP7YH+QoWOwZiqPbVRSleD/KXaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f84+l4o1ToRHRVe40JEdOq+fanKJY58by9Gk5e5Qe05ODpuqib5L0AUOiuSGq6mIz
	 ojf6Buh78RdEFoD2/F7y7r4/rQM5r/wAQhXlun1mTlDWUBZkBr/y0kSZfvVJuM8ull
	 zi8rBrwom6Hp8fYLSbXpQdEHj4b8sxGkWYtri9Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Fertser <fercerpav@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 220/462] net/ncsi: wait for the last response to Deselect Package before configuring channel
Date: Tue, 11 Mar 2025 15:58:06 +0100
Message-ID: <20250311145807.054879834@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1345,6 +1345,12 @@ static void ncsi_probe_channel(struct nc
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
@@ -1461,13 +1467,8 @@ static void ncsi_probe_channel(struct nc
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


