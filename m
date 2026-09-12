Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E5B3612F6;
	Sat, 12 Sep 2026 07:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199330; cv=none; b=Vsqd/GK/jTQ1ZdjRAS8RLoTkLxfUN51QGGyp4ILgeQboOA370Atqxs+VWjrEEAkHdaPT43UW9QSGEcIgKghgNSOWwDMKp3L8B/QKJ134NZ1Fm385MlmW3vCmBqfBpKLgOi0PlsxWGcPfp5OXsqWUzd8h0Lfm353n7wV0hIf+Ums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199330; c=relaxed/simple;
	bh=YtOtFul3a6ZKjdc8O5+DcRss/Vh7YG8v6Ryo/ZDUBHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/yPmtAaXv+z9J1zruRUCtFJ+UsxcJ+GBBNpQ4wRCOy+UJ0eqozYmWehb0kXhN7392qpgN4ylT1i6FCSzfjo/Ic7ZLQzZRI3cMC9jyq/h/9j2Yqtp+ozgVS6z7yAxYXChFs0av/l9EJ9K37Qd/2U1sV21UJhPA+SLZSFX87K1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cL5/Yah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cL5/Yah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030A81F000FF;
	Sat, 12 Sep 2026 07:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199328;
	bh=BrCX0Bgo24NK5rK30yUCZ/KtmE1nmBiNDZvoElM6Ud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cL5/YahK+fde+njIunY2vpiI69BxxtpTLm5JYmP1tEIosr1b5gwqaBuENJ3sLd8w
	 zMrp/EKnfOIU/U3vbwJnzPxcyImNI3A2ceSruwTA1hL4eitVybi25C5F/wA9vjhwHb
	 5tdzQ05zGP61221S6m6XtcVQ7nkeE58Rzp3f2Qfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0563/1815] bpf: Zero queue and stack outputs on lock failure
Date: Sat, 12 Sep 2026 08:38:33 +0200
Message-ID: <20260912065702.100553220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7ac6e1ae41a09f1dd4baeeff1d028ae49ee01232 ]

Queue and stack pop/peek helpers accept an uninitialized output buffer
because the verifier expects the helper to initialize it. The empty-map
error path clears the buffer, but a failed lock acquisition returns
-EBUSY without writing it.

Clear the output before returning -EBUSY so BPF programs cannot observe
uninitialized stack contents after a failed helper call.

Fixes: a34a9f1a19af ("bpf: Avoid deadlock when using queue and stack maps from NMI")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260719125419.1782196-1-memxor@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 9a5f94371e506..c1c9dee4dcdd0 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -99,8 +99,10 @@ static long __queue_map_get(struct bpf_map *map, void *value, bool delete)
 	int err = 0;
 	void *ptr;
 
-	if (raw_res_spin_lock_irqsave(&qs->lock, flags))
+	if (raw_res_spin_lock_irqsave(&qs->lock, flags)) {
+		memset(value, 0, qs->map.value_size);
 		return -EBUSY;
+	}
 
 	if (queue_stack_map_is_empty(qs)) {
 		memset(value, 0, qs->map.value_size);
@@ -130,8 +132,10 @@ static long __stack_map_get(struct bpf_map *map, void *value, bool delete)
 	void *ptr;
 	u32 index;
 
-	if (raw_res_spin_lock_irqsave(&qs->lock, flags))
+	if (raw_res_spin_lock_irqsave(&qs->lock, flags)) {
+		memset(value, 0, qs->map.value_size);
 		return -EBUSY;
+	}
 
 	if (queue_stack_map_is_empty(qs)) {
 		memset(value, 0, qs->map.value_size);
-- 
2.53.0



