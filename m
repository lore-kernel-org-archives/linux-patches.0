Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF94E3ADBB4;
	Wed, 23 Sep 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173083; cv=none; b=d2YjyOn/qvNE1bhPG9RMAeywS4lzkWnvCd43fkXGRfJ/SxO3ZeIn6HxwWvbdDdjsE1ZVqYmLE1fd9LRDYDQn0/JeAKekTPtW1qzuVNpfZxsEuJsIhX6GjolMV0I7IEubmCGtpx8vpuHBgfWn28LCm/rTpDEtqHmjv50N08FOGX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173083; c=relaxed/simple;
	bh=2mP2Bd1Y3SXBF+ac06395SsWJ+IwW0Uygih3EV+xt30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ9tset8w1NuiWRxVv+outbkaF8k95yuCp2FYHQ4jxcr5HhjDduOwt5QygyR22P8oGAVm8dBfkuoZZ4IaHJbKZB33tpjyAB258DPj2/jqnb3C6hi0opUv58YxbAME3yEatTmM0pgF2i4g9PaVr9zn3Y7VcekvsGGKumHDP7MVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt7/Cf8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt7/Cf8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CC01F000FF;
	Wed, 23 Sep 2026 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173082;
	bh=CrTAJpXbP6KRKN/q/Gg69ccKMrq5dE869a/TMdA8+qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tt7/Cf8Fcz9Vi4aQ8bFRbg7sLuSBO7ElQFUu0CHGpqYtuW95i0WSSYzWyTyR60bab
	 f4NhSYeiX9Pk1b81f6M+cdBUdKfOOpBlvqpKjO3TT9UtTSQuuhd+Mwk1eqMpeumcek
	 ivQ9a6MyTxTd0Y1AR22iPON61aMNhLB/93skgwck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 114/438] keys: fix lost wakeup when reaping a dead key type
Date: Wed, 23 Sep 2026 16:02:15 +0200
Message-ID: <20260923140647.734648920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2725ab3f5ad1c5f375c7c9fee4af02a9b138f701 ]

clear_bit() is atomic with respect to the word it modifies, but it is
an unordered operation: it implies no memory barrier on either side
(Documentation/atomic_bitops.txt).

key_garbage_collector() clears KEY_GC_REAPING_KEYTYPE with clear_bit()
and calls wake_up_bit() after reaping a dead key type. wake_up_bit()
uses a lockless waitqueue check and requires a full barrier after the
clear.

The existing smp_mb() is before clear_bit(), so nothing orders the clear
against that check. The GC can see an empty waitqueue while
unregister_key_type() still sees the bit set. The final wakeup is then
lost, leaving module unload stuck in wait_on_bit().

Use clear_and_wake_up_bit(). Its clear_bit_unlock() has RELEASE
semantics, so the completed GC work stays ordered before the clear, and
its smp_mb__after_atomic() orders the clear before the waitqueue check.

Fixes: 0c061b5707ab ("KEYS: Correctly destroy key payloads when their keytype is removed")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260821025327.61488-1-kmehltretter@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/gc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 748e83818a760..eda445f815d47 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -318,9 +318,7 @@ static void key_garbage_collector(struct work_struct *work)
 
 	if (unlikely(gc_state & KEY_GC_REAPING_DEAD_3)) {
 		kdebug("dead wake");
-		smp_mb();
-		clear_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
-		wake_up_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE);
+		clear_and_wake_up_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
 	}
 
 	if (gc_state & KEY_GC_REAP_AGAIN)
-- 
2.53.0



