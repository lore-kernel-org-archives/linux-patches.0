Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882641C4A24;
	Tue, 15 Jul 2025 23:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752621349; cv=none; b=G2747kdCp/zrk2wB1RN2+VTbaMpxVtIqBQA/51GIQfX90Hv58PGWuVj+Wzhfcq2h3kLU5XI3sC64xvaO3HUxZqQ1Gs+xyzBxhvc1ZEhpBwn3Ms8DQmtw0hbFcQ60IeBIseY9GvR0Ws7MBcESVXez0tRSHn6g0Tle2md7hEk1K7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752621349; c=relaxed/simple;
	bh=/dCGa5H4AelaG2ZkyOmjOIG3ouvsTLqq2o32O6e/pE4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SNUnrgNgNdjFz93hGKBVTAHgJPZvi028I/hIk8ea2/cfAX07oPCo0pZ63VX2dRwq7bncIXLAwMcqjbm03/yPKtnJYmpYjgWEuK8KWF/Mqrzuql5aJd58NqIhOL6PCRyiFeL4xYl/TrNR1Xc1LGQX2Qr7pgIfdAHhnOeCODkdoVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggLvj/Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggLvj/Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA1FC4CEE3;
	Tue, 15 Jul 2025 23:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752621349;
	bh=/dCGa5H4AelaG2ZkyOmjOIG3ouvsTLqq2o32O6e/pE4=;
	h=From:Date:Subject:To:Cc:From;
	b=ggLvj/ZhFnutu1dLxVmY5OZDKI9B8R17r2osh4kwYQBdvcN/M+KqKuqSaKk87Qizn
	 gY4M3O4EeUPWfu04dX2uCTYB8Hac3nu54liiFeq02gkTkDx7Pqsag9MG4Ux/13DTvT
	 fKsgQgVEoEda3AyXkfLaNZzj6Fxc0yOfYfJ3dxQ7ctOYxIcxxWYrgp2DeSOqxpytNT
	 YiBFDUcoYIV2N7XbmfNygVAmMWSNS/1R55PC9siF7onx3UTXfZyzEkRo6Ztp5MSdQd
	 SEF/QNcnGm1VvQ4nd0UHhvIoSoNBj205O6mXI2Rjb/fR++qUGocm1k0xGJYvF+3mdM
	 HCCaVdtwFo+4A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Jul 2025 16:15:40 -0700
Subject: [PATCH net] phonet/pep: Move call to pn_skb_get_dst_sockaddr()
 earlier in pep_sock_accept()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250715-net-phonet-fix-uninit-const-pointer-v1-1-8efd1bd188b3@kernel.org>
X-B4-Tracking: v=1; b=H4sIABvhdmgC/x2NTQqDMBCFryKzdiATtJZepbhQOzGzmUiSiiDe3
 WlXj+/xfk4onIULvJoTMu9SJKkBtQ0scdKVUT7G4J3v3UA9KlfcYvpJkAO/KioVl6TF/CRaOeO
 jC46efiZiAlvaMlv2//IGa8J4XTdLsBqFegAAAA==
X-Change-ID: 20250715-net-phonet-fix-uninit-const-pointer-64f0182b11e1
To: Remi Denis-Courmont <courmisch@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
 netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1958; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/dCGa5H4AelaG2ZkyOmjOIG3ouvsTLqq2o32O6e/pE4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBllD5VmbO6UYWt6FVlU9/ulb2lZe4azElfB3SOmJa8ML
 actja3rKGVhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABPp/Mrwv+isZKrqs8gdqmlf
 VG62Sh9+Lmrf6rlHurqmjKtGkytiP8M/W82Hj79+v/zt8x9fBUvZ9R/X2aXMr+V1bXFvKe8QY5v
 KBgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A new warning in clang [1] points out a place in pep_sock_accept() where
dst is uninitialized then passed as a const pointer to pep_find_pipe():

  net/phonet/pep.c:829:37: error: variable 'dst' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
    829 |         newsk = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
        |                                            ^~~:

Move the call to pn_skb_get_dst_sockaddr(), which initializes dst, to
before the call to pep_find_pipe(), so that dst is consistently used
initialized throughout the function.

Cc: stable@vger.kernel.org
Fixes: f7ae8d59f661 ("Phonet: allocate sock from accept syscall rather than soft IRQ")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Closes: https://github.com/ClangBuiltLinux/linux/issues/2101
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/phonet/pep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 53a858478e22..62527e1ebb88 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -826,6 +826,7 @@ static struct sock *pep_sock_accept(struct sock *sk,
 	}
 
 	/* Check for duplicate pipe handle */
+	pn_skb_get_dst_sockaddr(skb, &dst);
 	newsk = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
 	if (unlikely(newsk)) {
 		__sock_put(newsk);
@@ -850,7 +851,6 @@ static struct sock *pep_sock_accept(struct sock *sk,
 	newsk->sk_destruct = pipe_destruct;
 
 	newpn = pep_sk(newsk);
-	pn_skb_get_dst_sockaddr(skb, &dst);
 	pn_skb_get_src_sockaddr(skb, &src);
 	newpn->pn_sk.sobject = pn_sockaddr_get_object(&dst);
 	newpn->pn_sk.dobject = pn_sockaddr_get_object(&src);

---
base-commit: 0e9418961f897be59b1fab6e31ae1b09a0bae902
change-id: 20250715-net-phonet-fix-uninit-const-pointer-64f0182b11e1

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

