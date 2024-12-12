Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CED21576E;
	Thu, 12 Dec 2024 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023427; cv=none; b=uHWYRx4MD5Y3F6H6IWB0yUR/r1td3lbCNNU63S1pKgq3rkMoVS4PKMR4o+FPqoF9x63dNVxxSbTSmJe32gEcqQAb/hrUwOw2/T7yEcNR9FWIwcBBubk8CMOdIKzryj1bq/CDt4u7E/s04dCEsDAMJMM02E2kJ2Jt97zDD7n01o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023427; c=relaxed/simple;
	bh=OV2Mcd7k1YNR6hIArj4MTagjFLej+QKcztuGsWWX/MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEsKwcUHNgXWVBYh6DlD9pny5rH5/4cinEbK7YnSgcphS9tNBgDojG+AYpVqFY1yh6JgY7eIC+QsMacVM4/crMgkN5+SPi3Dm0/T3rKnGl3GyOGvdlBl4CMGsSS6u2sQ5oheHro5xp4aFuv+23/RUV+4ysAIvCojPo4GZP/tt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gc9TDf19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gc9TDf19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E5DC4CECE;
	Thu, 12 Dec 2024 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023427;
	bh=OV2Mcd7k1YNR6hIArj4MTagjFLej+QKcztuGsWWX/MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc9TDf19uTUQb9aV/O8wA6UkUslwUtwZZvZM19QlDl85jRZbsJ/VEdDrimG4NMONd
	 eh7AMU3gtw4sZX0+lZwM4AK5NCp8HUXM1rvNdN2xRu2Z71qxowZyfOr2AXNVEaVa41
	 XV95gDjy50ErOamT17dIyLugiDxB0jBjLhKq/mDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 531/565] modpost: Add .irqentry.text to OTHER_SECTIONS
Date: Thu, 12 Dec 2024 16:02:06 +0100
Message-ID: <20241212144332.808800390@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7912405643a14b527cd4a4f33c1d4392da900888 ]

The compiler can fully inline the actual handler function of an interrupt
entry into the .irqentry.text entry point. If such a function contains an
access which has an exception table entry, modpost complains about a
section mismatch:

  WARNING: vmlinux.o(__ex_table+0x447c): Section mismatch in reference ...

  The relocation at __ex_table+0x447c references section ".irqentry.text"
  which is not in the list of authorized sections.

Add .irqentry.text to OTHER_SECTIONS to cure the issue.

Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org # needed for linux-5.4-y
Link: https://lore.kernel.org/all/20241128111844.GE10431@google.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 43bacdee5cc5d..a663a0ea4066b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -940,7 +940,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", \
-		".coldtext", ".softirqentry.text"
+		".coldtext", ".softirqentry.text", ".irqentry.text"
 
 #define INIT_SECTIONS      ".init.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
-- 
2.43.0



