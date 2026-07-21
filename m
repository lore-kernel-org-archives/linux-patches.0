Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19C47125F;
	Tue, 21 Jul 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657407; cv=none; b=EyWfXTO0ixh2Ne1/QbPFmuOu7kwZsOe1YYYzQeZaZh07QrSwZFPqhnDQ3+raK2XsOOGjwHjf7bgjDCpONTezwTWUDQUTAqKm4pzH9GZfX4xa3cWWsPJrgHK4hg1V/tpi8ZnkKcENHxU0BImW0thFgc2O1lB4IeLtHY2R7FoV5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657407; c=relaxed/simple;
	bh=tXh4ISXPUf+ezrjEPfLFQPG7wLeiSTB7iSdPD5qhTio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLZR2BLcp5cnnvD1EASbX8Nb/k2FGXT1ZBD0vWLf8vW23z+cy548Ki+9v3yLLS28cap8zOIaPG6hKdzoig3qly6874IbgsTRKi3q4l+pCht26H+VbaVL3LBi4SxJbCuBFSwWXuQU2F+a/PKrbDGLqTKzLijZMpx7s52oAwkztDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7bAXIW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7bAXIW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD301F00A3A;
	Tue, 21 Jul 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657404;
	bh=wvEqtwSXRWeS3s1fbKsY+OS8P3YI8s3e5bERKSl6vIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7bAXIW/bBGhgyw0CNUAIw7GkEEaKvIHD8py//bD7EE85AT7ge/onIuCVu6Rn05k+
	 C8Zc7u9P+CN3CBk0AZqEpIOFL45omuZqbPvTAWV0VehFaLdHwKdLqA4YK8tllikCEV
	 WfwdFj+3enLTpqPlSPga+hR36l/l9EvQXlNwuQ8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0753/1611] i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring
Date: Tue, 21 Jul 2026 17:14:29 +0200
Message-ID: <20260721152532.310827737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 093eb8e73c90aa0c8cfb0421aa85bd70c23488be ]

The MIPI I3C HCI specification does not require the DMA ring RUN bit
(RUN_STOP) to be cleared when issuing an ABORT.  That allows the DMA ring
to continue to receive IBIs, although an IBI is anyway not lost because it
can be received once the ring restarts if the I3C device has not given up.
Note, currently ABORT is only used on a timeout error path so the change
has very little effect in practice.  In the more common case of a transfer
error, the ring (bundle) operation is halted by the controller anyway.

Adjust the RING_CONTROL handling to set ABORT without clearing RUN_STOP,
bringing the driver into alignment with the specification.

Fixes: b795e68bf3073 ("i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260603090754.16252-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 2364d9507d75f5..34c21a56a25d93 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -493,7 +493,7 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
 		reinit_completion(&rh->op_done);
-		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
+		rh_reg_write(RING_CONTROL, rh_reg_read(RING_CONTROL) | RING_CTRL_ABORT);
 		wait_for_completion_timeout(&rh->op_done, HZ);
 		ring_status = rh_reg_read(RING_STATUS);
 		if (ring_status & RING_STATUS_RUNNING) {
-- 
2.53.0



