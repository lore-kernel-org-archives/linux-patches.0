Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029728;
	b=le5cvAH33XU5B+Sd3gTY9YDRJXbi8V6GAxOjvHdaGObuSDzceRJQE+qWgZpqUKkrvofE
	 hkFIiQOFlVzgpv0RSq82Yeh14UQA2hxNXNh31PDT23X7u2U4TSCB2J8E5RS9QXzigO/zy
	 NTOQOc1ynuvW9NOUuIHgYz2c+GTk5xrPgAjomdXmTnZO0U+ncQ4p9mTqswpxl40EVpFpp
	 XjjlDvqTjDZGci4JavvvDXCeofe0lwAVCynRp+4b5Vc5Qf9ZBCJ7+AZf4Auo2ldcKv5zW
	 rqUXWAi7hU+jC9yIKYLSIdIgp80Z2txTAcKRYiscN5ndKQfxH3lsql7sOp+sppfur5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4D3iEtajSydeFnV9iaWmuKEJ3UGeByQNe6OWaceyB4=;
	b=ttLc7BCi57ZbNdNIG2ZAZPy7gp+a6VCB3GRg/ThnATsF6kSpa2PqJAjdmuHZOntZ5oVt
	 vtWluhoaAlY5JEDFderwyy+PZ+XCatSzf/rcQVBoY6O2CUDIBd86nFtgK/GO+V5JwYsTG
	 5xlI5mMvrshzTkj0D0KMsi8sUIs/xztVOodqafgTHKf4jC8KBUrO52tBOxb4lrHtiol0F
	 ERWU8QBAjCm56QiEAI5u8QddVS5bwFiACEqswk32eeq62k532LBUv53v85/sYMbQnD/nr
	 GZ3xFaIh4ozhqmBbmidIfx65pz4uzpqct5TLwl43IClQviWJVRJbpNmBV0Ty8ppET4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IX2dlZog;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDACE606A31C;
	Wed, 18 Nov 2026 19:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IX2dlZog
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E51A1F000C4;
	Wed, 18 Nov 2026 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029728;
	bh=r4D3iEtajSydeFnV9iaWmuKEJ3UGeByQNe6OWaceyB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IX2dlZogtfigjuFlFnaxENi7mfv8dqNbDZ68U61Z3IJVLNZjhFEHB+Cx5XoVmsk5f
	 XRSzPYErbbU9ysEmpzPwwTjmU+PMXQHobfVl7I+j65Y8oEkOJb2HKjhl8j2Kx+Rmpa
	 UIXfDR5fK4H3QtnJpKb4cgXkIofwggE3W1gcxXuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0452/1756] rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
Date: Wed, 18 Nov 2026 15:42:59 +0100
Message-ID: <20261118150026.792810152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 4c714f015d9ecc37d7a330b31822ccbcaff5ddc9 ]

The lazy RCU shrinker decremented sc->nr_to_scan (unsigned long)
and then tested the result with <= 0.  When a single CPU's lazy
callback count exceeds the remaining budget, the subtraction wraps
to a large positive value and the <= 0 comparison, which is
equivalent to == 0 for an unsigned type, never fires again.  The
scan loop then iterates through every nocb CPU instead of honouring
the reclaim budget.

Accumulate into count and stop once count >= nr_to_scan.

Fixes: c945b4da7a448 ("rcu: Shrinker for lazy rcu")
Assisted-by: Zcode:GLM-5.2
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 6e80285872f1e..1dc9e096f8242 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1256,9 +1256,8 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		rcu_nocb_try_flush_bypass(rdp, jiffies);
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		wake_nocb_gp(rdp);
-		sc->nr_to_scan -= _count;
 		count += _count;
-		if (sc->nr_to_scan <= 0)
+		if (count >= sc->nr_to_scan)
 			break;
 	}
 
-- 
2.53.0



