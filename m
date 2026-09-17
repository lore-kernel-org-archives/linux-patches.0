Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719463DD86A;
	Thu, 17 Sep 2026 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670901; cv=none; b=IbKufziZpx7G4KX0SQd+4KgHZ1jumcbWBM3Jr3cnySuEWXedfobsjMjwJoicziNZHOVVFcE9D6G7ThXLliNQNlv2lqHWKZFjYgBaxhnkLd6FGcyyZqc/B9N68oBfRDhgSWYuyLNfdlbXvni6+SjXZFXb1iKkgNUofPeffDj3NSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670901; c=relaxed/simple;
	bh=KHcgmX82FZwyBsj1eUNj1RWE4h7mzo+hXPbDvIF3TUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soePhKxUi10fwbT0IGSiYSWT6z8wqzNDq+LRSq5LIjt4nQf/rYNM9hKc98Q5hAHnu9DZw9MqjZVxDbPFO86c6ns9UXw36bHdYDOgJXM6F8GSRSHx8O70jr8iNaXMaAXp4u60GlX3v4+Kr1W+ggW1GFOmeVnbe5yGA4Q4Ls0DkeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAsAOjXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAsAOjXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE001F000FF;
	Thu, 17 Sep 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670900;
	bh=UYqyQqoksxD0jIRraT2H7lhesby2t0C3YWTkfBeF6pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAsAOjXXMrXGe11BBtNe4bNiHbqRYd+/yYQd5jz/E8sg521oGiA52f/rH/+5UVjws
	 Fi2FLXp9yolaNgXoCdT8tQcMVg75jDoXr9Vgk5cZUKyDd+tPkaPty/dmlKcK9qLmYe
	 zh70uIUmJXgtGUU1cuE1cBWFjRWKfrtz9k9yYg4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0799/1102] scripts/mksysmap: fix escape of $ in the __pi_ pattern
Date: Thu, 17 Sep 2026 16:12:22 +0100
Message-ID: <20260917151600.534325426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 59351365ac271b5e0eb180f211c531476a36221f ]

Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
converted scripts/mksysmap from a shell script to a sed script.

However an error was made - escaping of '$' required \\ escaping in shell
but only \ in a sed script.

This was mostly corrected in commit 7a6c355b55c0 ("scripts/mksysmap: Fix
escape chars '$'"), but this fix missed arm64 PIE namespace local symbols
like __pi_$x and __pi_$d which appear in System.map and /proc/kallsyms:

$ grep __pi_\\$ /proc/kallsyms | sort -u
0000000000000000 d __pi_$d
0000000000000000 t __pi_$x

Fix the escaping properly.

Fixes: b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 3accbdb269ac7..36910254bbab9 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -35,7 +35,7 @@
 / __efistub_/d
 
 # arm64 local symbols in PIE namespace
-/ __pi_\\$/d
+/ __pi_\$/d
 / __pi_\.L/d
 
 # arm64 local symbols in non-VHE KVM namespace
-- 
2.53.0



