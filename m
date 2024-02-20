Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04842151CC9;
	Tue, 20 Feb 2024 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462956; cv=none; b=kM2hbg0A1hNm86cNdQCGAr/4Gctt1dzT0XJtLsJk2m8zRKR1+bXpAeptiR1cG/l9vZZZ0xhzkeiHUFcuYB3mNb847J0yg63eQqUM95WlexanE7aCp/GlpCty+EyCQq6XNOFTPpD2MxUbY9JDRO2cCpTcF0hF0hAtWxaEZ3MuyEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462956; c=relaxed/simple;
	bh=7xe/asvL/yBkMyxa9rMBzTAngF/pIdf63hH6hKczSJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExOsmT6Mvs2X7gB0Zs4sAuMU5PK+RhLxYH9LuJyarJoORI+RcQmpt/Ku77tg/iHLsuR2wxgGOYNKYkhhJqz8ZCe4WwCWGy/O6dW5pSEO04ndFMZdKaiMyej3dU/efariWviU8ZC4R/KXEKwKwrFq5boocYLTTxs+UJMa5MYSZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDfv6DRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDfv6DRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E68C433F1;
	Tue, 20 Feb 2024 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462955;
	bh=7xe/asvL/yBkMyxa9rMBzTAngF/pIdf63hH6hKczSJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDfv6DRUW6HUvWAE86f2n3J97RG6kt2vRYgXmsmH75mtfIihYkYREabTzmLNERzzW
	 DvxjuKtTHpRJHzNy2hsu9WxHaFdKcwdSfTcksgMRDg3rJJjK/rOhBO2j99xZ914ClK
	 Lim8HSP4R+35PaHjzYTmk+cJY9QzdlpYDROwjccU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 6.1 089/197] modpost: Include .text.* in TEXT_SECTIONS
Date: Tue, 20 Feb 2024 21:50:48 +0100
Message-ID: <20240220204843.750310800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 19331e84c3873256537d446afec1f6c507f8c4ef upstream.

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
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 846cfbeed09b ("um: Fix adding '-no-pie' for clang")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -824,10 +824,10 @@ static void check_section(const char *mo
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS
 
 #define DATA_SECTIONS ".data", ".data.rel"
-#define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
+#define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
 		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
-		".fixup", ".entry.text", ".exception.text", ".text.*", \
+		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"
 
 #define INIT_SECTIONS      ".init.*"


