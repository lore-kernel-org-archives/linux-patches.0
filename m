Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400283F54CD;
	Tue, 17 Mar 2026 16:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766140; cv=none; b=kgk2aliMuYuQmetHU79acha0BuCpv3TyQyR2pDA1nTh4Z/QjcQW6OSnm8CZCuFsi7ssPDWHXyt2CyZQTb5yuzs1UH3OAzVO5EdYWA3o/F4NQbG+8SSlIOdBTmplSaYdUvvEIGem5C++3BZEAdWGhbTq7M7TRTUxDv1OUoqugN1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766140; c=relaxed/simple;
	bh=G8IKMDBMgDnqjyig8Ve7jviHqpLZexKGzb4isUbs4RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElEdHmRLfl5CPo/hMIx5RHDo9SEy9SAKbZo/+xLt+BlyIB5zrOQpF4kYJHgnwc783RGyfbG8pWvOKZ4xjvaDl1UGYxdMyE4eZO1bjE92YQQNoXGmshOepzC8GSuS66yKAWvJjLyH+qdmGELUzTGA/WymoTujsMkwWFP8v3KmwrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAIpX1xI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAIpX1xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51692C4CEF7;
	Tue, 17 Mar 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766139;
	bh=G8IKMDBMgDnqjyig8Ve7jviHqpLZexKGzb4isUbs4RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAIpX1xIatjIT9+xV7gyj32Uj9lhx+pSaaZGXqhJqQOXbm5iqjtZfPMjHvRN2TUiy
	 NUOQxsd+KYaeLUQC42jxK49usIXpb1O7vmHDmdlniIfbS/lOeqvSfvD21nSVgvY2I/
	 2dOAzm7TxFF6lfctCktgcL6x2TdbZ2+wjAh+u9R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 179/378] objtool: Fix data alignment in elf_add_data()
Date: Tue, 17 Mar 2026 17:32:16 +0100
Message-ID: <20260317163013.593421709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 356e4b2f5b80f757965f3f4d0219c81fca91b6f2 ]

Any data added to a section needs to be aligned in accordance with the
section's sh_addralign value.  Particularly strings added to a .str1.8
section.  Otherwise you may get some funky strings.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Link: https://patch.msgid.link/d962fc0ca24fa0825cca8dad71932dccdd9312a9.1772681234.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2c02c7b492658..3da90686350d7 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1375,7 +1375,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
 		memcpy(sec->data->d_buf, data, size);
 
 	sec->data->d_size = size;
-	sec->data->d_align = 1;
+	sec->data->d_align = sec->sh.sh_addralign;
 
 	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
 	sec->sh.sh_size = offset + size;
-- 
2.51.0



