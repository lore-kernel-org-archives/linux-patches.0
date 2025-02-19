Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3641D432D;
	Wed, 19 Feb 2025 09:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956617; cv=none; b=CRUwZIioI32MCUNw+uY88nFjxESnTIWPC8mgHRogCbL/x0dmusqrGbjaahahEargrOHV38tF/uC5HbBu7K/Mgqa2a8K78boEfBXxzkwwiN5xSZFiHxIxs77zcIrKYUD6llqvpMcQsPlPszAkwe8F6KC1PuUE1BFp2jurBYcZnp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956617; c=relaxed/simple;
	bh=CysB3CfT1eQRkt0q+1ul2mvDjnTgsGBsVAQRu2i7K24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE4TwDuglSl5D8AUuhyrewocBhcLBPB3D0sFvraL1ThaNuWIEF5mEp1TsBF9wVegnE4Wqxi+mN/DobWkI01MuOYtvthvsBKzHX101v3NBisIZRAsBQeLYZXzseL0kS6qpgFjOH70XQj3rKd8/Lx6nUyq2pc1S2kzvkgjPZUiXVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=be7okRj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="be7okRj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0689C4CED1;
	Wed, 19 Feb 2025 09:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956617;
	bh=CysB3CfT1eQRkt0q+1ul2mvDjnTgsGBsVAQRu2i7K24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=be7okRj6y7ajWVWm9cPAMD3v+Zf722BK2Tg8/FUmrnd4lXSuhJ5Wv/evVUGhs97Vp
	 V0/iFnRDd1lAijQ71FWQs2KUuJY0Q9APES8d55PF8CEUYC2WKG6bZttzKBlPL3Btj2
	 aRCPHrpRWHEOfXoqc+OK4I3dbFaCBYYQexHIht8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Petr Vorel <pvorel@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/578] kconfig: fix memory leak in sym_warn_unmet_dep()
Date: Wed, 19 Feb 2025 09:24:04 +0100
Message-ID: <20250219082702.478537816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit a409fc1463d664002ea9bf700ae4674df03de111 ]

The string allocated in sym_warn_unmet_dep() is never freed, leading
to a memory leak when an unmet dependency is detected.

Fixes: f8f69dc0b4e0 ("kconfig: make unmet dependency warnings readable")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 758c42621f7a1..1c0306c9d74e2 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -321,6 +321,7 @@ static void sym_warn_unmet_dep(struct symbol *sym)
 			       "  Selected by [m]:\n");
 
 	fputs(str_get(&gs), stderr);
+	str_free(&gs);
 	sym_warnings++;
 }
 
-- 
2.39.5



