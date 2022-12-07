Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036B8BF1;
	Wed,  7 Dec 2022 19:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D22C433D6;
	Wed,  7 Dec 2022 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670440657;
	bh=O+mCEvtYCx0AflkiAmltBJS93iQNSFHj5Pd7wMO3/i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja82WIxkHCB/Rsu+xHdTA0oOP/igTfx8sxCe1ulCIjMXug8rHWT9T18gmwLylyjtv
	 K0t64QbxFcod/6YwdypxTuEsvAYwLPceHEdZwDkA9pCFT+VKjvMugvxztrwjluxKbf
	 SQ24nJlxess2ICufBbAJ5niSq6WL3LrVadzUajgjX6vZ/eCnAdOiumf3dye37iQOTr
	 1Lk5vasguocZUSg+OAsxVrc750gFCilH0IkCrzj0BNhTdgpYhRIqCj79wKcPBOw3+P
	 TSdTKe/L8RcFHUx/oA8wnZN4qjCVYqR0TMTBhOizIZvILkI6QJGFt1Ami6EKiQ4HnQ
	 ibv1C8PR/H4wg==
From: Nathan Chancellor <nathan@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sami Tolvanen <samitolvanen@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH v2 2/2] modpost: Include '.text.*' in TEXT_SECTIONS
Date: Wed,  7 Dec 2022 12:16:57 -0700
Message-Id: <20221207191657.2852229-3-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207191657.2852229-1-nathan@kernel.org>
References: <20221207191657.2852229-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 6c730bfc894f ("modpost: handle -ffunction-sections") added
".text.*" to the OTHER_TEXT_SECTIONS macro to fix certain section
mismatch warnings. Unfortunately, this makes it impossible for modpost
to warn about section mismatchs with LTO, which implies
'-ffunction-sections', as all functions are put in their own
'.text.<func_name>' sections, which may still reference functions in
sections they are not supposed to, such as __init.

Fix this by moving ".text.*" into TEXT_SECTIONS, so that configurations
with '-ffunction-sections' will see warnings about mismatched sections.

Link: https://lore.kernel.org/Y39kI3MOtVI5BAnV@google.com/
Reported-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-and-tested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 scripts/mod/modpost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2c80da0220c3..c861beabc128 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -823,10 +823,10 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
 
 #define DATA_SECTIONS ".data", ".data.rel"
-#define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
+#define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
 		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
-		".fixup", ".entry.text", ".exception.text", ".text.*", \
+		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"
 
 #define INIT_SECTIONS      ".init.*"
-- 
2.38.1

