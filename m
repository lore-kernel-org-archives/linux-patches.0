Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F221C4609;
	Tue, 26 Aug 2025 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215385; cv=none; b=Ki4RPzgLcylRjbY6zggido5Nw0D/7xXPyOwV1F7yozx999+fuNUGMfxtF8DIJU334y42cPwfX/POtJuRti3dA02GS2ef8SQK1gtZ4lRCZu2iMEZtBXRJlUdwZLtV470wd/HL6Qb5ln0Ko6EDttQ+TzvGq8E1wUxryRRyDY+sLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215385; c=relaxed/simple;
	bh=h7uLXYEFzuBlwNfIBAiCTLvkWJ6KgO97RV41jaM0nI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XziOcC3Wcbw8i5BT/x86AIsTMdJCFztpT5mOXc6pqG8Oqm+lzi8GQABTvsC4g4A9Ug1MdsLeNf0skpbOArQTshMdrA+CEo2eDnlv+WMNZ8jsh65VWcbi7ZZPgZrPCue5YKv2EqS3+BLqHehZQyYrmM1rf92adV2KoKwruLIEXCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWDFjOdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWDFjOdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F31C4CEF1;
	Tue, 26 Aug 2025 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215385;
	bh=h7uLXYEFzuBlwNfIBAiCTLvkWJ6KgO97RV41jaM0nI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWDFjOdojlPsEn8GGM6COK9x7oDwRHxkGa/UT4kx5qlw5T0AQ9ZWGIIlEKgS3bomB
	 GnFeZDZRbh9zzV/5bELDHasyCfwA7tDKDQ9vs66+kzzSr4pcKkMUXws1SoUauWLYjc
	 BbaRfgHkGiBE5/JKqHg1GDZwqrUjT9WUE2rCNZdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 014/644] phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()
Date: Tue, 26 Aug 2025 13:01:45 +0200
Message-ID: <20250826110946.867703799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -825,6 +825,7 @@ static struct sock *pep_sock_accept(stru
 	}
 
 	/* Check for duplicate pipe handle */
+	pn_skb_get_dst_sockaddr(skb, &dst);
 	newsk = pep_find_pipe(&pn->hlist, &dst, pipe_handle);
 	if (unlikely(newsk)) {
 		__sock_put(newsk);
@@ -849,7 +850,6 @@ static struct sock *pep_sock_accept(stru
 	newsk->sk_destruct = pipe_destruct;
 
 	newpn = pep_sk(newsk);
-	pn_skb_get_dst_sockaddr(skb, &dst);
 	pn_skb_get_src_sockaddr(skb, &src);
 	newpn->pn_sk.sobject = pn_sockaddr_get_object(&dst);
 	newpn->pn_sk.dobject = pn_sockaddr_get_object(&src);


