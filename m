Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD9AD5C;
	Tue, 29 Nov 2022 19:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609FC433C1;
	Tue, 29 Nov 2022 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669748529;
	bh=icUPTneL5f1Z7UulRvoGlaLeHjICq2eYhqZB8eYbGic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4YSH7NeClOesE8D8rV5nxohfSynZkIckFPjvpv8pDdRPKTKYTfFjgBYJ0M+Vukig
	 Dnjvge287Rm06ZlLUNLgnk/q07kS98rSLcMLAjmLTh4ihAbojhnICMF44VA4NEU4dU
	 TgAa3KDMY5ZhU7Z3YiRoZadR7HW/nPvRvjsBeImLCIn+1ssTErq7r3oCRuyja6iwd3
	 +sJJJ2S8IsDD7GSzgh6L4GfOmlDiX22NgE6XJ9gpM76BkXfq7dQyDf/eRj9NaUOSSC
	 ZtJsRwwnNw8eLlBqsVg18VBoRzb7UPNJtH2f3n4+YF9JzMgxSCpiGNmdc1/GKvcsEZ
	 iWW7UOOi+TkHw==
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
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 2/2] modpost: Include '.text.*' in TEXT_SECTIONS
Date: Tue, 29 Nov 2022 12:01:23 -0700
Message-Id: <20221129190123.872394-3-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129190123.872394-1-nathan@kernel.org>
References: <20221129190123.872394-1-nathan@kernel.org>
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

