Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FFA390608;
	Fri,  7 Aug 2026 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117113; cv=none; b=Qn/PCgWxUt8MQkv1/wnNVIMdfWPRVHBxnk4TRzdLB2ds/B0aT/nRibNczYRhoPsgmtkMzxTXdzRUchz/3QVqCXf8XPxOWsPtJanZ1Khp6Dq2RvMZU0yG/qi1Hw5nqHkBMvN9THKdyf0UwO8LfY8chPnLnGVDd7UXS0iyMCG8ijg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117113; c=relaxed/simple;
	bh=bMiKUXlX+yJJuQg6IduhOxbhom3IH0DkSEZUA/Gwo/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmNkolVFdx4Duu8NdH830lPuNxO/qioub61GZxxWe0DYzvLuv+xjQHSTF7kEIW/HJ+ndCMpFPLCiBOvMvQ6ylNOWGeGzTa1om+tTY5nHQsD35rNsAABjaXIgyKxYJJWnJFxHv3NNz5xzkY+lF0r6WLnxWigb9Xo+eSs0gtP2loo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mudeblue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mudeblue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213D81F000E9;
	Fri,  7 Aug 2026 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117111;
	bh=tEpYzDbEI6KPgmH77bXvPEEObClZPFM6gGBm7qnMTzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mudeblueqgXt4zY7/CQSgbkMd++xERNKBKFKA4JJiGosII4DFfO0eT/BUfxerZOTE
	 HgvUdwqYUgVBffMo/iwL2coduQFf44ZAJah3MJDw6hNQ2gdBKVJkVvY56T0Vtu+mPY
	 RIXG7m2+EQjhUADsJN7Yx3yM+LOrW7/75FTJgm4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anish Rashinkar <rashinkar.anish@gmail.com>,
	Philipp Hahn <p.hahn@avm.de>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 7.1 202/438] kbuild: Stop modifying $(objtree)/Makefile when building oot-kmods oos
Date: Fri,  7 Aug 2026 16:36:38 +0200
Message-ID: <20260807143432.326970128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Nicolas Schier <n.schier@fritz.com>

commit 39d6e68f50f4a444a6ba23b9ea2eaee806601c6d upstream.

Update output Makefile in the corresponding tree only: for out-of-source
in-tree builds update $(objtree)/Makefile, for out-of-source out-of-tree
module builds update $(KBUILD_EXTMOD_OUTPUT)/Makefile instead.

In-source builds are not affected.

Since commit c9bb03ac2c66 ("kbuild: reduce output spam when building out
of tree"), building out-of-tree kernel modules out-of-source (make M=...
MO=...) causes a rewrite of $(objtree)/Makefile with KBUILD_EXTMOD and
KBUILD_EXTMOD_OUTPUT being set.  That is problematic:

 * $(objtree)/ must not be changed in any way when building out-of-tree
   modules as it breaks other uses of $(objtree).

 * Setting KBUILD_EXTMOD and KBUILD_EXTMOD_OUTPUT in $(objtree)/Makefile
   kills the tree for incremental builds that start right there
   ('make -C $(objtree)'); builds starting in $(srctree) reset
   $(objtree)/Makefile to its original content.

Further, $(KBUILD_EXTMOD_OUTPUT)/Makefile was not generated any more at
all.

This commit restores the previous kbuild behaviour prior to commit
c9bb03ac2c66 ("kbuild: reduce output spam when building out of tree")
but leaves in-place the use of filechk for output spam reduction.

Fixes: c9bb03ac2c66 ("kbuild: reduce output spam when building out of tree")
Reported-by: Anish Rashinkar <rashinkar.anish@gmail.com>
Closes: https://lore.kernel.org/r/CAOESE2Q2-0KUDaM0mUo+c_F-tMaUsBZ-gpnhdoe0rmYdgnnuJQ@mail.gmail.com
Cc: stable@vger.kernel.org
Tested-by: Philipp Hahn <p.hahn@avm.de>
Reviewed-by: Philipp Hahn <p.hahn@avm.de>
Signed-off-by: Nicolas Schier <n.schier@fritz.com>
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260723105845.1704689-2-nsc@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 11539c3fd405..17d34968b7f0 100644
--- a/Makefile
+++ b/Makefile
@@ -695,13 +695,11 @@ filechk_makefile = { \
 	echo "include $(abs_srctree)/Makefile"; \
 	}
 
-$(objtree)/Makefile: FORCE
+PHONY += $(CURDIR)/Makefile
+$(CURDIR)/Makefile: FORCE
 	$(call filechk,makefile)
 
-# Prevent $(srcroot)/Makefile from inhibiting the rule to run.
-PHONY += $(objtree)/Makefile
-
-outputmakefile: $(objtree)/Makefile
+outputmakefile: $(CURDIR)/Makefile
 ifeq ($(KBUILD_EXTMOD),)
 	@if [ -f $(srctree)/.config -o \
 		 -d $(srctree)/include/config -o \
-- 
2.55.0



