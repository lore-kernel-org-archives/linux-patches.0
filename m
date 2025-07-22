Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7637BAEC;
	Tue, 22 Jul 2025 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192110; cv=none; b=N/NfYA82D7wT6qFUgG0ppH17K/20zLbloeUfZdMM01Up3s95z0kcahiquC6yPQxdUjEGjHSLbwl5c0eRSYFRD5PWq6rH0BP/FodhBKC10wk28VwWc7q+dPmvXdHTJpZ8/eZAbIpsawS7G2gYm6hpJF4GhTa58KsJm7sgg89lIOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192110; c=relaxed/simple;
	bh=89xZKGsj3tuc0qpKAJhHUzheqTDpPAwkq/O8AT0Pbrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wko59NWlON2csKrv0PfCOwvhS4tt7BGPA1I3gIDeHuTANn7kda7SGjLS9FFIFNbV/YVgc/rAcJxouZ8EG9DJU5dKVBAmfJe+sQPmpDuhxdM0kv8uEy9YQptRvWKy9HT1kXPDkY05GX4fwZa7zOn1KDHDtZHxiseGNrUuYLF/Trc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzVctIqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzVctIqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3D7C4CEEB;
	Tue, 22 Jul 2025 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192110;
	bh=89xZKGsj3tuc0qpKAJhHUzheqTDpPAwkq/O8AT0Pbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzVctIqB/iLkdy8SZh/gDhpjzjWreS/QxXFZIHXwljLC1Ipb/LfSiYXZ+SPNess7v
	 f9ljDp93nywfIblGbY61X0gE38YfDE7OCcAJwhC1rLhjo6SS1NDRn6mHB4CzAbIGnG
	 x3CIiflWHURT0BH9Rw8vfp4Hm1yQlZrlNSBFQ0Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 15/79] phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()
Date: Tue, 22 Jul 2025 15:44:11 +0200
Message-ID: <20250722134328.944294046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 17ba793f381eb813596d6de1cc6820bcbda5ed8b upstream.

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
Link: https://patch.msgid.link/20250715-net-phonet-fix-uninit-const-pointer-v1-1-8efd1bd188b3@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -826,6 +826,7 @@ static struct sock *pep_sock_accept(stru
 	}
 
 	/* Check for duplicate pipe handle */
+	pn_skb_get_dst_sockaddr(skb, &dst);
 	newsk = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
 	if (unlikely(newsk)) {
 		__sock_put(newsk);
@@ -850,7 +851,6 @@ static struct sock *pep_sock_accept(stru
 	newsk->sk_destruct = pipe_destruct;
 
 	newpn = pep_sk(newsk);
-	pn_skb_get_dst_sockaddr(skb, &dst);
 	pn_skb_get_src_sockaddr(skb, &src);
 	newpn->pn_sk.sobject = pn_sockaddr_get_object(&dst);
 	newpn->pn_sk.dobject = pn_sockaddr_get_object(&src);


