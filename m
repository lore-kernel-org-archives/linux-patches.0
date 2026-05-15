Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0B3B9D91;
	Fri, 15 May 2026 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862375; cv=none; b=ZNyGkaeyKt7LjUa7IEohXmYeqHPA0DrdCVnHUqdbdQuid/QAQN89yKROGYhwfq2xSB2PuqPn1BeaSDg/7Ymp3Qc7i4R5RkTgQH4fBKScMzRZQTkwkW9NW0Ab4IBwBNTcEU4PqnCVwluCywAXqVa9/tUboKNMmM+kj35LFvidzRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862375; c=relaxed/simple;
	bh=GYodvWxzyDzZ9WoR3pJYxFLuaKUpnRLioaqQGZO+q7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFEqnco4/2WnU1+oVYFAuOKd4q4rjEWHvcOAebgsfijSa6o9VMlDCNbgK6hI3hC1REcTcFjhZ1m0wAIYh7Ay3aBezCSxdlz9WveYk2vP1SPZnhOdYsiJisq/zduNerGQ9qjnbTd/JCtYPv0H8YjVztpgV3HxYxBykaCMORRsnMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Py992S5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Py992S5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BD6C2BCB0;
	Fri, 15 May 2026 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862375;
	bh=GYodvWxzyDzZ9WoR3pJYxFLuaKUpnRLioaqQGZO+q7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py992S5+7Q2UiAUTTo+YHZV0injfeulzEOGWqvXJ4rTL81as6dhIoIlHgBgYi3j3L
	 1f/5EF/dE6lAcjSAapmnXefrTu8a24iqQdF8+KrVyimZw6fDobbYLyHIzZB8zxw0fj
	 ETLwP3fu1o5jkkBiDBY69aHo95T5x6TAxuUofiIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 024/201] media: chips-media: wave5: add missing spinlock protection for handle_dynamic_resolution_change()
Date: Fri, 15 May 2026 17:47:22 +0200
Message-ID: <20260515154659.057441353@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1593,6 +1593,7 @@ static int initialize_sequence(struct vp
 {
 	struct dec_initial_info initial_info;
 	int ret = 0;
+	unsigned long flags;
 
 	memset(&initial_info, 0, sizeof(struct dec_initial_info));
 
@@ -1614,7 +1615,9 @@ static int initialize_sequence(struct vp
 		return ret;
 	}
 
+	spin_lock_irqsave(&inst->state_spinlock, flags);
 	handle_dynamic_resolution_change(inst);
+	spin_unlock_irqrestore(&inst->state_spinlock, flags);
 
 	return 0;
 }


