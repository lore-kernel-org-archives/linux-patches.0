Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D836BCD9;
	Tue,  6 Jan 2026 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722173; cv=none; b=psRzJD+zn6GReKx464Unfy1lV9ooVqryXolIApfKZ2HLjlcucR6pnmftO6Lxkyt0oF6ny6uH1ohDe4KV5qrB1Gh3EYfDpDdFVJVVnusdGEuvrbZA1FQad15xg+lfQGeHd/XXDqmq3TTm33f7739ji60x8U63DyXOX9ZkGxhIZs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722173; c=relaxed/simple;
	bh=dZjXHmjG4cNrxR2b6qHIjdjNzbnsaBL4r+cjmgcLwFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+OhWy6vX1gZUKkYppndgZKLIT3XP5plBn8t/tV7Ty8hKWxZlPt7a3iee3yECOfI02IfHfZ8ELje2eQSXhmZUTW5UuVqIBcyd9G1rEpzcz+KoM07SRwAjvlJ2oBYXFMlo/QR79c512u5m7+fUq/z/SrJJLVi26SW+NLmHRWtgEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoVrsPg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoVrsPg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ABBC116C6;
	Tue,  6 Jan 2026 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722173;
	bh=dZjXHmjG4cNrxR2b6qHIjdjNzbnsaBL4r+cjmgcLwFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoVrsPg5SRtuyoHF8DgZx5lzqgtompYLgJNlqpb7csD9h63GkvY6nyHFufRaqyY3L
	 hTbcfQb6445FHH5kGqOr1k5j/NL1SxvIlYztmg0PbnN78zhcjt48aD5/lfBRTH/dbY
	 H1eV/OSplxO/Ubj+P+PvKWqKOdorWXLeiNcY0wJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 186/312] media: amphion: Cancel message work before releasing the VPU core
Date: Tue,  6 Jan 2026 18:04:20 +0100
Message-ID: <20260106170554.557400646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ming Qian <ming.qian@oss.nxp.com>

commit ae246b0032146e352c4c06a7bf03cd3d5bcb2ecd upstream.

To avoid accessing the VPU register after release of the VPU core,
cancel the message work and destroy the workqueue that handles the
VPU message before release of the VPU core.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -703,15 +703,15 @@ static int vpu_v4l2_release(struct vpu_i
 {
 	vpu_trace(inst->vpu->dev, "%p\n", inst);
 
-	vpu_release_core(inst->core);
-	put_device(inst->dev);
-
 	if (inst->workqueue) {
 		cancel_work_sync(&inst->msg_work);
 		destroy_workqueue(inst->workqueue);
 		inst->workqueue = NULL;
 	}
 
+	vpu_release_core(inst->core);
+	put_device(inst->dev);
+
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
 


