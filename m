Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36312C1A5;
	Mon, 12 Aug 2024 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480342; cv=none; b=hLjZMw/+EXNlDzUiI+iWmTh4XgBcA3Ccnb8rscDc1zGLmR0j9vbgQq3cM3P1ZYDFM3tZYxTV4VZCeABR2ggPpIQz5f0tloRHPOVGsPknF+tintgwV9AynoC+4/f4HaK1i36eqkcWgtbNN34MZY47JiSZ2AhuSBMaRaWN8REQNrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480342; c=relaxed/simple;
	bh=HuOpkZzDmdS+a++ce2HyH4Tb3dIvqepbohgCf18b2yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACmRYMV2D9WOydevnRkzkoz8lAvDgVDaF+WYX2lqR5QhXgza9DEOXbyLrfgTgLMLFkCnJ2TjJuD+O17ovIMVj3l1MG7EwhPbouZGD7oNfIus+dDJj0ca6Tjjo6gPCbuvR9PNdG1WlNktZJwkH7uQnNpVKU0/aqtkzV/eWNK2cwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWe5BIR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWe5BIR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF04BC32782;
	Mon, 12 Aug 2024 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480342;
	bh=HuOpkZzDmdS+a++ce2HyH4Tb3dIvqepbohgCf18b2yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWe5BIR/iNJ6k3aghQsw+t6jqGNGeyPCmSjgXL6ZM/7xTLEff4NV5ZlY3y/+TgI/9
	 yDN9Fwf8t5HBvJV+ASUySC8GNCL09rGYPBGQqq9upm57adRhDAzDwYA2NzXJnrQKgN
	 NfdIfwhELG9Can49DgaiaGMKnZqPNFUAnF0zkDGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/263] kprobes: Fix to check symbol prefixes correctly
Date: Mon, 12 Aug 2024 18:02:32 +0200
Message-ID: <20240812160152.327207487@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 8c8acb8f26cbde665b233dd1b9bbcbb9b86822dc ]

Since str_has_prefix() takes the prefix as the 2nd argument and the string
as the first, is_cfi_preamble_symbol() always fails to check the prefix.
Fix the function parameter order so that it correctly check the prefix.

Link: https://lore.kernel.org/all/172260679559.362040.7360872132937227206.stgit@devnote2/

Fixes: de02f2ac5d8c ("kprobes: Prohibit probing on CFI preamble symbol")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 6a76a81000735..85251c254d8a6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1557,8 +1557,8 @@ static bool is_cfi_preamble_symbol(unsigned long addr)
 	if (lookup_symbol_name(addr, symbuf))
 		return false;
 
-	return str_has_prefix("__cfi_", symbuf) ||
-		str_has_prefix("__pfx_", symbuf);
+	return str_has_prefix(symbuf, "__cfi_") ||
+		str_has_prefix(symbuf, "__pfx_");
 }
 
 static int check_kprobe_address_safe(struct kprobe *p,
-- 
2.43.0



