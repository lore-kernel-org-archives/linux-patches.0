Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81FF37E5C4;
	Sat, 12 Sep 2026 10:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207864; cv=none; b=pmnQO+z5XK0mmLZ319AeZ9oRQv1+q9WCbneeaWnlcYJZ5vBjX/TfzmNydjP23fHxgZsniGt4HTB791SuVnmidtuPDYN4K6aPiOEn4xDVmg4yAKFAxEQQj8O3l+oNFGzXlOpA09DnL63FftZIbWlZws7f8BVEF/6xTHQu2pjZaSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207864; c=relaxed/simple;
	bh=fsZ6U6Jl9fB8/fwwCUQ3/lqWW+MtNAUvSj4CHpQBCFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQjXpoEgeQfoJ1qJ0rnbdoAxRWWOnUCy9duCOujXWJsmLL2R9pGS/sM/8V/pOKOj4QkHRyXLT2KorxBnYVwXvQuA8ZWVA+pLVNY8Qvki4+ip/AyEAPTrX5AfYzGRY92rPGOWRNAR/zN2HWSLgzxtYDuXz9j639tCcbxVoNX1iyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFqbQ1tG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFqbQ1tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5511F000FF;
	Sat, 12 Sep 2026 10:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207863;
	bh=7NasJvm4p8XwZonRAgZvelVuJTuLcgzmbR9iHibQ8C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFqbQ1tGqGAAnpKnPXUt033VN1ZzWF4lom3EUjMtiQkEL+d3l0DQSXdld3l+2NtdH
	 NheQyYQ/spCDcs6MC/z8JlNuBnrIwHV5I3KHCTYmEkPN/lDlosIR1s1TXexPfZQNep
	 BAnilFsk4L1o4njKmctTwEN154ZK5n1NyXpRRBYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0498/1518] bpf: Zero queue and stack outputs on lock failure
Date: Sat, 12 Sep 2026 08:44:27 +0200
Message-ID: <20260912065634.711041757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



