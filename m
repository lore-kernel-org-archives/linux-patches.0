Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C4A3CE4B1;
	Sat, 17 Oct 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260228; cv=none; b=fOPjCht2WSv18nMVcPMyznKC4MNqs6w40UmD6epFu0+uTBLaAvnW3/LbGbE/lWPZ+viEZUMrlLqTQWGDut8SBuogZPPTq1eBBbIXeNRvNXJbYk0fj2xCgc/h0MQO+jqPTG6GQ76E4fOO6066JHoDutPrFdotxpvNgqTewpm3ZPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260228; c=relaxed/simple;
	bh=r6F8vzYkSQuIbY7krAmqvwuD4U6V9P5lMGsuErUitIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK6vR6DqEAsatbEl5YHroJulME2MZ7K79ukmOW4QhS2ObuavSi1Eh+8WUBEnoTjqof6gbiGUa9TJ+LydgoTMiMkUXh0bsFQAKo26v4bewmmF9oX4CcY4WQOcJwK9/0f4tnzuvHxYN0M2CPCr1MxzSFF8KUrOYSU+mCId+40QCR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CscmfIcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CscmfIcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A7A1F000C4;
	Sat, 17 Oct 2026 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260226;
	bh=BTGLu58+CoEUsi6RbUwseKordAJkYy/A/8ExWtD483w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CscmfIcH0l9FIfc5zigtDx5FtACdZ5f87fD7UETwWd6b2u5KYz4ktEOGZmvC7/3My
	 amgVSKmR9nLf8wrz2nmBrKFEWmzWwhIDNdzfWWOx4MR9IejuV95C7Rphiby202YthJ
	 Joll1ghRY+4rgZsX4wEnzFNS3754TJ1zVtqgcsgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1475/1674] bpf: Zero queue and stack outputs on lock failure
Date: Sat, 17 Oct 2026 18:02:27 +0200
Message-ID: <20261017160509.021184694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d869f51ea93a0..36384342d7d89 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -99,8 +99,10 @@ static long __queue_map_get(struct bpf_map *map, void *value, bool delete)
 	void *ptr;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
@@ -134,8 +136,10 @@ static long __stack_map_get(struct bpf_map *map, void *value, bool delete)
 	u32 index;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
-- 
2.53.0



