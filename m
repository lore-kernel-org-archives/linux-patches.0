Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022361;
	b=XAxZ3F3ZgNikXi5p4zPMYj+lbmeCJBw+bdAd0w+ZPMVonADbSNm/oDVCRi5mmsxr0r5F
	 tupjhAt7hsTTQoXhnCF/yhHMwYW5gv7dxNF6dbrtX9ZtvkCEjfZ9gp7rosORa5FJgeMm/
	 kx2NLHvpdc94pvWRSGM3oHpIvmAqo1xmFZfAxLZT2CUDksZ2cHMNP9YI/qSEz/qJsSbB/
	 uzyOtFFM4XBIMhk4YcT/dMBahNtyTfQ2KQkppe+pmt8d5aUG2dCxPliFkuqrc33wa1Zvo
	 p5/7uqBNw3NNu8Gd7zOizVwGZ/83lJOETH51PJN6TqZpdEvfkIjvA58ghSKfuKYCgeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7mxTtC5bcXQwsd55seQrSDvEtFt/pFTICmhPY46WLqA=;
	b=u/yiaxlKtPUIeGjVK6sp+DacrxBuOmzGT/ZPczChcrYSFPu4j8tAfuE7M4yrcBNZSpsa
	 4Prouzcqi5U/sEJGy8A3Zkxl1rTz7PPhDORJxASf3kTzJ3MAsZXnrtTBjVepFXep6MpC5
	 JB47WqeFBg3hhfyBNAUe7JEVacpSD+24xjlU2biV1Db2p4p5bOTakz10eCpFESy/kTHHq
	 Dk9qPGxmpOuIw1paSV5HjYZqi4/HN4vvCkrpzlNyEIpzNLP1wJcAxEFROPz5leZxXhIAA
	 agftlDnHAkmN2ABxLjK+ry53iJXv3Qeb6475acdmY/woY8GoaVUfsvggyi8A0fuPrrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I82gHzpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6146B606A31C;
	Wed, 18 Nov 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I82gHzpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937331F000C4;
	Wed, 18 Nov 2026 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022361;
	bh=7mxTtC5bcXQwsd55seQrSDvEtFt/pFTICmhPY46WLqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I82gHzpMqsuO4zYRzNkgoZIlWQKN3aQcc+7nxTx8dh02N0qxgPeJPXmtQj3SdAv5D
	 2Gg28k7CepDXLhGGQuBDSDMEnnzA8iXMzTqOX8S5zgx9vXl1V6cLyTbN6zSw0f1vbJ
	 piYtTAlquG4+2aghWT0Kfu0oybwPZxu806J42joA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2635/2651] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150419.008112497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index c3de5b94d25f7..94b70502dc9de 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -285,9 +285,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



