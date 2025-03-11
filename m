Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75F125F78D;
	Tue, 11 Mar 2025 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707598; cv=none; b=sonIlcxCF9XKXT8rahpIuB19JpXxQ+SuSDfRKa6Y+AQWWfDzV5OiwPuSYTcEcAYbGMPyG3nTEJe1agrDp2dLAnf4GFOpxjWARpgOBckUpdrXW5iGEyyZXUcbuH8GOcKYHDdSIbMEx+FcDTlB7xK1TX0Xs8maJFciN1oH6uNkb0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707598; c=relaxed/simple;
	bh=EPIGJMeJSIBvAd/r6Tx1qUKuFWB38P3HLQjtaB1LfTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0SO6ZP4E0af0EwoLth5yLMuSMX35bqNgGi5F020vUBS3/Nc6SqTndIVZ+20159jweOOY2CpqrHBft2/lJkYoo+ziRdl0Xs7OLglNeAJbf9fjFBZ5nn0u/QZ1A9CYQTfVUn+283trBVj6aspRkmMD+TSYZlMCxSFkyvUe8tLXVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmYDNpV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmYDNpV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B5C4CEEC;
	Tue, 11 Mar 2025 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707598;
	bh=EPIGJMeJSIBvAd/r6Tx1qUKuFWB38P3HLQjtaB1LfTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmYDNpV9ceL3ihKU1BvgxXqgnvJwBjDc2k0h2GvWZc9dJYiDxwux1tHkC4UitReAg
	 FANq6cFfwo2K67rVoXGLDDlkokx32A9VaIhuZmSi20i3mqvJOAiYD9F0y9clPnXBRp
	 fKkpZUvYURYWNwW4siH8RneQxGd9cS+nzh2zceSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Visweswara Tanuku <quic_vtanuku@quicinc.com>
Subject: [PATCH 5.10 442/462] slimbus: messaging: Free transaction ID in delayed interrupt scenario
Date: Tue, 11 Mar 2025 16:01:48 +0100
Message-ID: <20250311145815.790321137@linuxfoundation.org>
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

From: Visweswara Tanuku <quic_vtanuku@quicinc.com>

commit dcb0d43ba8eb9517e70b1a0e4b0ae0ab657a0e5a upstream.

In case of interrupt delay for any reason, slim_do_transfer()
returns timeout error but the transaction ID (TID) is not freed.
This results into invalid memory access inside
qcom_slim_ngd_rx_msgq_cb() due to invalid TID.

Fix the issue by freeing the TID in slim_do_transfer() before
returning timeout error to avoid invalid memory access.

Call trace:
__memcpy_fromio+0x20/0x190
qcom_slim_ngd_rx_msgq_cb+0x130/0x290 [slim_qcom_ngd_ctrl]
vchan_complete+0x2a0/0x4a0
tasklet_action_common+0x274/0x700
tasklet_action+0x28/0x3c
_stext+0x188/0x620
run_ksoftirqd+0x34/0x74
smpboot_thread_fn+0x1d8/0x464
kthread+0x178/0x238
ret_from_fork+0x10/0x20
Code: aa0003e8 91000429 f100044a 3940002b (3800150b)
---[ end trace 0fe00bec2b975c99 ]---
Kernel panic - not syncing: Oops: Fatal exception in interrupt.

Fixes: afbdcc7c384b ("slimbus: Add messaging APIs to slimbus framework")
Cc: stable <stable@kernel.org>
Signed-off-by: Visweswara Tanuku <quic_vtanuku@quicinc.com>
Link: https://lore.kernel.org/r/20250124125740.16897-1-quic_vtanuku@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/messaging.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -147,8 +147,9 @@ int slim_do_transfer(struct slim_control
 	}
 
 	ret = ctrl->xfer_msg(ctrl, txn);
-
-	if (!ret && need_tid && !txn->msg->comp) {
+	if (ret == -ETIMEDOUT) {
+		slim_free_txn_tid(ctrl, txn);
+	} else if (!ret && need_tid && !txn->msg->comp) {
 		unsigned long ms = txn->rl + HZ;
 
 		timeout = wait_for_completion_timeout(txn->comp,


