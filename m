Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A309B3E0094;
	Fri, 15 May 2026 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862002; cv=none; b=PlLLlJbNGAhwoIkxSjaICoHzXeR8CvWa/X7d5GXXR6D/x1DtPh/OAiMt6Xk1Ggjr+5cdr8C4JTkqeYArHI/GktESvw4bI4chfaeue9XBpnpUdzUBMBlAUV5vSaR1wK82NDY577l4yjR449vCptqoSQe834ozzexKDD/Bp0G+dP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862002; c=relaxed/simple;
	bh=S6QoCc9UpZTTJYOurtPSMQbG6jysaGtKLaLEH5wTdGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOsY2OreISuzN5QGJ4ome0SYmWXVsGGa+S5341hbRxYpcafSo4RktM1GyHIx+yUu2pTTRQX7h76Z+CFIzDDg82PTGuS14vdU7fsd6u1lnDMMpwUoeJZ8WAcxjmJG+J7NtgeQxVkjCF+gH/WkvWlTL5N0TwIFfLW43hmJYvL06vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ni5jmm/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ni5jmm/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEC5C2BCB0;
	Fri, 15 May 2026 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862002;
	bh=S6QoCc9UpZTTJYOurtPSMQbG6jysaGtKLaLEH5wTdGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ni5jmm/yxqvxQghxYlfVnk99dMs3OlfG9TuETKG4ssPL9jKuKZ8ZkqZoHCqPSfEhq
	 A9nrqLJFCOgrig6uuP/XMSQQbrEs0fuv1S1vAp7q2spNAzejx8xemZ1JAW/JxHBaGG
	 gt8avFRsLmFEdyUa43kFslZafVfZoYTzySbatgFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 017/188] media: chips-media: wave5: add missing spinlock protection for handle_dynamic_resolution_change()
Date: Fri, 15 May 2026 17:47:14 +0200
Message-ID: <20260515154657.680953216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

commit cb8bdd3ffca280d014311ab395651d33f58a8708 upstream.

Add spin_lock_irqsave()/spin_unlock_irqrestore() around the
handle_dynamic_resolution_change() call in initialize_sequence() to fix
the missing lock protection.

initialize_sequence() calls handle_dynamic_resolution_change() without
holding inst->state_spinlock. However, handle_dynamic_resolution_change()
has lockdep_assert_held(&inst->state_spinlock) indicating that callers
must hold this lock.

Other callers of handle_dynamic_resolution_change() properly acquire the
spinlock:
- wave5_vpu_dec_finish_decode()
- wave5_vpu_dec_device_run()

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: 9707a6254a8a6b ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1544,6 +1544,7 @@ static int initialize_sequence(struct vp
 {
 	struct dec_initial_info initial_info;
 	int ret = 0;
+	unsigned long flags;
 
 	memset(&initial_info, 0, sizeof(struct dec_initial_info));
 
@@ -1565,7 +1566,9 @@ static int initialize_sequence(struct vp
 		return ret;
 	}
 
+	spin_lock_irqsave(&inst->state_spinlock, flags);
 	handle_dynamic_resolution_change(inst);
+	spin_unlock_irqrestore(&inst->state_spinlock, flags);
 
 	return 0;
 }


