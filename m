Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EA71D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1Y4b0U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558D9C433C7;
	Wed,  4 Oct 2023 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443834;
	bh=7DDFO70f2tHKJtwbjHe8zezFmT/hWY8HpwpeUQlr5do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1Y4b0U+zvUr0yCwrzWcsAc3pODLyftx8iNzGjzE2GW4pXGjEX+jWxJum4vy3Pl1e
	 BhjZmRrOI6Mwkz3+sMpBX+6S7r+keIc0vJOH8TYUIncyaa70aBQZuWw9H/zbRAYhz6
	 wV2hVMjixyWciCPwObl5u6PAnFhkXEPeR1YKCxig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 037/321] bpf: Fix a erroneous check after snprintf()
Date: Wed,  4 Oct 2023 19:53:02 +0200
Message-ID: <20231004175230.880663614@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a8f12572860ad8ba659d96eee9cf09e181f6ebcc ]

snprintf() does not return negative error code on error, it returns the
number of characters which *would* be generated for the given input.

Fix the error handling check.

Fixes: 57539b1c0ac2 ("bpf: Enable annotating trusted nested pointers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/393bdebc87b22563c08ace094defa7160eb7a6c0.1694190795.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4b38c97990872..197d8252ffc65 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8498,7 +8498,7 @@ bool btf_nested_type_is_trusted(struct bpf_verifier_log *log,
 	tname = btf_name_by_offset(btf, walk_type->name_off);
 
 	ret = snprintf(safe_tname, sizeof(safe_tname), "%s%s", tname, suffix);
-	if (ret < 0)
+	if (ret >= sizeof(safe_tname))
 		return false;
 
 	safe_id = btf_find_by_name_kind(btf, safe_tname, BTF_INFO_KIND(walk_type->info));
-- 
2.40.1



