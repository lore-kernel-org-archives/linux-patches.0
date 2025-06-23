Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD511F582A;
	Mon, 23 Jun 2025 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712922; cv=none; b=eol+rQeZ3pFOHBHndGYjiYoeoXKOhgANQMArvplruCN18V/A+pIgWp6v3l3sKR5UieLKkoDY4vOk23Z7iWz7WZ9MS+5RyG/TZPGO4YfC21GLqjXAsoRbwINU4wXmvXSKrQosDtp3mLBPqsgkWI5Y9S8JBXkL3AxMIPmuHBRVzTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712922; c=relaxed/simple;
	bh=DFywUB0T52X3R+zkztBRPC7APlM4xRwJbZX/Zz2L738=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvA44So27NYMbgV8+cZW/u1Cm00SIOvRzlQxQw9RMIdaBr6gsj5sL29fON+AiBJb5WyD4VlO1uT55DkKecNvfxxPynK6h2m2gnSxgr42zjOklSjnWqZWBlQEmVjF6QVqWwg5GG21u8BPFenGz5f4NaPdEhUpHb9qkgcw1IjbfXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNdP9l+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNdP9l+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF7DC4CEEA;
	Mon, 23 Jun 2025 21:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712921;
	bh=DFywUB0T52X3R+zkztBRPC7APlM4xRwJbZX/Zz2L738=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNdP9l+Y6GGdd2Zfcjn+jQmGT91x9wrLpl940kGnvsIG3GZzlgSBhzLpmF5g+Twva
	 uSVGAxoOYl+ieoZO7PiceQHElg0wguHTYmrEizjdCJiUR3GDHk5taCO4GOSCWHcy2C
	 FC3MnwZehQ3iVSlhbJnMLVDbvmt/6yGf15sjU1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/508] libbpf: Use proper errno value in linker
Date: Mon, 23 Jun 2025 15:01:52 +0200
Message-ID: <20250623130646.889924014@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 358b1c0f56ebb6996fcec7dcdcf6bae5dcbc8b6c ]

Return values of the linker_append_sec_data() and the
linker_append_elf_relos() functions are propagated all the
way up to users of libbpf API. In some error cases these
functions return -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250430120820.2262053-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 752ef88c9fd97..0bee018a6a6c0 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1175,7 +1175,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		} else {
 			if (!secs_match(dst_sec, src_sec)) {
 				pr_warn("ELF sections %s are incompatible\n", src_sec->sec_name);
-				return -1;
+				return -EINVAL;
 			}
 
 			/* "license" and "version" sections are deduped */
@@ -2023,7 +2023,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
 			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
-			return -1;
+			return -EINVAL;
 		}
 
 		/* add_dst_sec() above could have invalidated linker->secs */
-- 
2.39.5



