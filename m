Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C902223C42;
	Thu, 12 Dec 2024 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023424; cv=none; b=FKv5A7clTTO2/5esn8StZb/xSy1t2roDFKjznLGGc20fR8x0XZMUJAoslrk6LawccNWQIIQNYuxS1XOmf91XMDcZX0V+5R5HmTduBNd+optnaBEpgjsOYBMJU7PisVNjTOGXZuMDnoWaOV0FaYum6WiDye7dD0XB5iz836YUHHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023424; c=relaxed/simple;
	bh=oFqVGPkvW2uof8A793hQWGJOb4P6tqbMIy+UqvYezds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQtRccEKYjR/Ko8BWfIrsZMVEjmittdW8RXSMuV+Z/68ka8j+WNY3OjQlIgcYPHSIwEV3pzfpiTKiVJKp/GTIOV4vc5l6H4wvOjXA/iq6jZGYu6Pm8oyp+5Z6ysZPdOMVLAt2ZAExrEcB568Cv7tcq3VKN4A39LXvwZJaF5x1F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yL6gxYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yL6gxYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B9DC4CED0;
	Thu, 12 Dec 2024 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023424;
	bh=oFqVGPkvW2uof8A793hQWGJOb4P6tqbMIy+UqvYezds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yL6gxYdGheOLYyUX5Ayfr+9LFbZiv19kZJnmrv7v3d1t5y1fiRvalrO3xTnxQB4e
	 +cWuHQFKUaK7PLuHBH9lY0KtOxztG4RM7FkidxMadoz6jsPgmz9TKA7nEB+OlmM80b
	 H+mte8+sqXK+VU0TEtxh/HrU5+Bv4Hb3xKFAln7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 5.15 530/565] modpost: Include .text.* in TEXT_SECTIONS
Date: Thu, 12 Dec 2024 16:02:05 +0100
Message-ID: <20241212144332.763326429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 19331e84c3873256537d446afec1f6c507f8c4ef ]

Commit 6c730bfc894f ("modpost: handle -ffunction-sections") added
".text.*" to the OTHER_TEXT_SECTIONS macro to fix certain section
mismatch warnings. Unfortunately, this makes it impossible for modpost
to warn about section mismatches with LTO, which implies
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
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 7912405643a1 ("modpost: Add .irqentry.text to OTHER_SECTIONS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c6e655e0ed988..43bacdee5cc5d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -936,10 +936,10 @@ static void check_section(const char *modname, struct elf_info *elf,
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
2.43.0



