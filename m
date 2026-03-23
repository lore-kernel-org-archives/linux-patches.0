Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFAE3B3C18;
	Mon, 23 Mar 2026 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278790; cv=none; b=lAGuxxRyNUesqxoaIF7isXnWJPAUv3Qn87/3Yju1D7xCHuTNU/ma2Xey8qf6ddSqvjrPJD/6a+OzG/Fuppi8TQs3UGQEMnqPHv1gcbhnmOwhEX3+815S9SPHco/xnUIMgQglcL9T3YPeYDF9XiHxuFhk5/HGQYrsqziXffdEGuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278790; c=relaxed/simple;
	bh=EXRK55SKgHWb3VGOA7oIlelQpxNCGxUx5AEXSvpSfMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT4w/pyElOQMj/qXhOEmCmQOZCiMUatPbZK/Pue3QFjtrVwsrR72XZxnDtiYOVfZvpSyU4S+/45rwWJMror6L97nE+ERe5nITk/002oi1a8Suasz/VOnTpvfFStaD1Oh70YxFEf6CQ1JWxlpLM/jbPz2eRaaxFzViuktVaKRvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPJpiziW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPJpiziW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339AAC2BCB6;
	Mon, 23 Mar 2026 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278790;
	bh=EXRK55SKgHWb3VGOA7oIlelQpxNCGxUx5AEXSvpSfMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPJpiziWCnX5W4u+3KefaFu/cDjG/Uf1nRXGyXo1K6dVDXVoR34kcK0rN0IOVUVyp
	 8dNPPxfo4/VCBtt+j6yt/wou83M7qu9S60Pd5QM1dk16Qg9cmLhhbnAJlDMD4vo9hU
	 XxHAARw6NhGpcPnWJRK8J3g0chzDqbx9c/9eOEaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Rainer Fiebig <jrf@mailbox.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/567] kbuild: Leave objtool binary around with make clean
Date: Mon, 23 Mar 2026 14:44:58 +0100
Message-ID: <20260323134543.188844541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fdb12c8a24a453bdd6759979b6ef1e04ebd4beb4 ]

The difference between 'make clean' and 'make mrproper' is documented in
'make help' as:

  clean     - Remove most generated files but keep the config and
              enough build support to build external modules
  mrproper  - Remove all generated files + config + various backup files

After commit 68b4fe32d737 ("kbuild: Add objtool to top-level clean
target"), running 'make clean' then attempting to build an external
module with the resulting build directory fails with

  $ make ARCH=x86_64 O=build clean

  $ make -C build M=... MO=...
  ...
  /bin/sh: line 1: .../build/tools/objtool/objtool: No such file or directory

as 'make clean' removes the objtool binary.

Split the objtool clean target into mrproper and clean like Kbuild does
and remove all generated artifacts with 'make clean' except for the
objtool binary, which is removed with 'make mrproper'. To avoid a small
race when running the objtool clean target through both objtool_mrproper
and objtool_clean when running 'make mrproper', modify objtool's clean
up find command to avoid using find's '-delete' command by piping the
files into 'xargs rm -f' like the rest of Kbuild does.

Cc: stable@vger.kernel.org
Fixes: 68b4fe32d737 ("kbuild: Add objtool to top-level clean target")
Reported-by: Michal Suchanek <msuchanek@suse.de>
Closes: https://lore.kernel.org/20260225112633.6123-1-msuchanek@suse.de/
Reported-by: Rainer Fiebig <jrf@mailbox.org>
Closes: https://lore.kernel.org/62d12399-76e5-3d40-126a-7490b4795b17@mailbox.org/
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260227-avoid-objtool-binary-removal-clean-v1-1-122f3e55eae9@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile               |    8 ++++----
 tools/objtool/Makefile |    8 +++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1356,13 +1356,13 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
 	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
 endif
 
-PHONY += objtool_clean
+PHONY += objtool_clean objtool_mrproper
 
 objtool_O = $(abspath $(objtree))/tools/objtool
 
-objtool_clean:
+objtool_clean objtool_mrproper:
 ifneq ($(wildcard $(objtool_O)),)
-	$(Q)$(MAKE) -sC $(abs_srctree)/tools/objtool O=$(objtool_O) srctree=$(abs_srctree) clean
+	$(Q)$(MAKE) -sC $(abs_srctree)/tools/objtool O=$(objtool_O) srctree=$(abs_srctree) $(patsubst objtool_%,%,$@)
 endif
 
 tools/: FORCE
@@ -1529,7 +1529,7 @@ PHONY += $(mrproper-dirs) mrproper
 $(mrproper-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _mrproper_%,%,$@)
 
-mrproper: clean $(mrproper-dirs)
+mrproper: clean objtool_mrproper $(mrproper-dirs)
 	$(call cmd,rmfiles)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.rmeta' \) \
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -87,10 +87,12 @@ $(LIBSUBCMD)-clean:
 	$(Q)$(RM) -r -- $(LIBSUBCMD_OUTPUT)
 
 clean: $(LIBSUBCMD)-clean
-	$(call QUIET_CLEAN, objtool) $(RM) $(OBJTOOL)
-	$(Q)find $(OUTPUT) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
+	$(Q)find $(OUTPUT) \( -name '*.o' -o -name '\.*.cmd' -o -name '\.*.d' \) -type f -print | xargs $(RM)
 	$(Q)$(RM) $(OUTPUT)arch/x86/lib/inat-tables.c $(OUTPUT)fixdep
 
+mrproper: clean
+	$(call QUIET_CLEAN, objtool) $(RM) $(OBJTOOL)
+
 FORCE:
 
-.PHONY: clean FORCE
+.PHONY: clean mrproper FORCE


