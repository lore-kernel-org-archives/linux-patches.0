Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2636A1CAA75;
	Wed, 19 Mar 2025 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395196; cv=none; b=NV1E81swSfQX0zdhYyY+i7mPRgc/saqlTS5uWiVa9hoQzkHny3OApveuPMKUDbH1y+H3e176Qtr2gGR/2PzGsMFGJv6ZU6s1oQs5z2HGBut1iH3K9rcVokKfMQXBpdxIaVPEMICnhtcYD83JBXLWKFZCC9XvjOjrvH1muVbg2p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395196; c=relaxed/simple;
	bh=bvAhmtpm99MQMso8S5l2W19W9Zu2T2VWkL9syI4vH2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISXZwGKpufSEVi/JPnt05ywPNkJS1zdLfKLvxvVpFaHSCGAkfvzVwMyA6KQTKTEYCyQ0z3IH8/f0iuWX7sWN1K/2rjdclAeaDYfqHsFHEbJnimWjA5CTKobpYOkYRvwqCYigvmsm1Be6U+u3N7jUa3sRuTyc5qC+XaWudKvDOdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cg+V7t+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cg+V7t+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE82CC4CEE4;
	Wed, 19 Mar 2025 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395196;
	bh=bvAhmtpm99MQMso8S5l2W19W9Zu2T2VWkL9syI4vH2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cg+V7t+RVaEmx84eJbtmSQoZixPHpx7jVGGm4yqQuKQWuPi6Ep93B11YaMFpLxxGJ
	 Tc3DeMJhhgNH1oJWvrD6yv31D4mjoiynXvba4XkleEn0/aIXVGDpmkGk7Cmf1a57VB
	 SFzieG65pncFckOeD7lL1cJU0niJgEU71/LRkJHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kusche <klaus.kusche@computerix.info>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/166] objtool: Ignore dangling jump table entries
Date: Wed, 19 Mar 2025 07:30:28 -0700
Message-ID: <20250319143021.542548740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 3724062ca2b1364f02cf44dbea1a552227844ad1 ]

Clang sometimes leaves dangling unused jump table entries which point to
the end of the function.  Ignore them.

Closes: https://lore.kernel.org/20250113235835.vqgvb7cdspksy5dn@jpoimboe
Reported-by: Klaus Kusche <klaus.kusche@computerix.info>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/ee25c0b7e80113e950bd1d4c208b671d35774ff4.1736891751.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 1b242c3c2d451..6e59e7f578ffe 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2028,6 +2028,14 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		    reloc_addend(reloc) == pfunc->offset)
 			break;
 
+		/*
+		 * Clang sometimes leaves dangling unused jump table entries
+		 * which point to the end of the function.  Ignore them.
+		 */
+		if (reloc->sym->sec == pfunc->sec &&
+		    reloc_addend(reloc) == pfunc->offset + pfunc->len)
+			goto next;
+
 		dest_insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
 		if (!dest_insn)
 			break;
@@ -2045,6 +2053,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		alt->insn = dest_insn;
 		alt->next = insn->alts;
 		insn->alts = alt;
+next:
 		prev_offset = reloc_offset(reloc);
 	}
 
-- 
2.39.5



