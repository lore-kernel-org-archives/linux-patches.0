Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8604840B11B;
	Tue, 21 Jul 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648247; cv=none; b=S8dT5UQ5ILeIEyPJXHkF+Q8jy4K7VklEwtbJsfKRiGgH7VtZ4x7Ah+ex0y6zGfCWqfnoV+rh3ztwvXZDxZTO3i+fubnmtcdHYR9YKl1fv5T3BWSjNi8TYz+Og5JZ45Jqf0S6rh7fTyczXj9q0vR+aIV0Q0OZryBF7BeU936zEOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648247; c=relaxed/simple;
	bh=ElkgWfcRdaQMPM4c6TqmKTzPSxQUfw6mfh7KJAEyvqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbWiNAuyMVvAkZjW6X+p9V++YPCHsEvUl4i5PIqfbM6tR2zDUJ3Y5SJiKTU6Rfs6NAuTbXBUz6/v3ZKTiqqqUCikgy/jvkEy4JGjMNgt9bhJUHyCHbVON3WVitKYOlnkxHg9CHc5O/wHHYlZ2C1lW1is9GXRxWLBA/5nAE9+rlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDgzuhSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDgzuhSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A531F000E9;
	Tue, 21 Jul 2026 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648246;
	bh=I6uTPltVTJgT5mN2AQKAA4Mh2tuTTh3gJwNtrOcpHGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDgzuhSczz01zyZKTPeYcENBdfa3cjEE2e9lA2VdtMtkxx556m2mJrg3yE6/KOEQL
	 5S6iJgw6utAExTDUcDjlk17xjvyXFzs46s2mCepkG38gzEh3kaEmFLRZIJWSwQGyjf
	 4C7LWKfbwIJP8VQXguvRMGCpujqUS+xy3kY5hJ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0125/2077] objtool/klp: Fix cloning of zero-length section symbols
Date: Tue, 21 Jul 2026 16:56:38 +0200
Message-ID: <20260721152555.645895222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 98377f3ba7c02d6eb34e203c9f9823bc62b0d231 ]

Fix NULL dereference when cloning a symbol from an empty section.
sec->data is only populated for sections with non-zero size.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 8aec5f5702c73b..67fdc43a743373 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -669,7 +669,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 			size_t size;
 
 			/* bss doesn't have data */
-			if (patched_sym->sec->data->d_buf)
+			if (patched_sym->sec->data && patched_sym->sec->data->d_buf)
 				data = patched_sym->sec->data->d_buf + patched_sym->offset;
 
 			if (is_sec_sym(patched_sym))
-- 
2.53.0



