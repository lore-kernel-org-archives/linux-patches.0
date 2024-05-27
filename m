Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7115FCE9;
	Mon, 27 May 2024 19:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837814; cv=none; b=ixXbh1CKQoFkp6OnbC28+OaQWOjlggG2H7pcqVfDmSklnMrvMV+h+MphZT1bnGfY5d4XKfbegPPTW2mCPohSSFg/PfH/T2UCBnV2o0yRDiYgWFdwbJTTIIHcxuUTG0cvPUvJt7y8gsQTl9Sn9ETq/iQO7OXDaRJ9rJEsr8Tceog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837814; c=relaxed/simple;
	bh=q3KWIXWiLsIk24cCXSJmCtnOb3ZaV4hLU/iTkDl/EbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssbdwyymc/hTCum6otAqginK93TMUrBDZIO5lWIgPwXaa76cu76xlifSHId35IqNZFsbIghuZPV8S1Tew4Or842Ux5lQ7apV6PUDQzq99ew57xOPieofqRXxGNEoYzcF6c2hARUkoWixpDUe9byDxQhGA4r+2IDRy9diEhemUDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrjjarsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrjjarsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627B9C2BBFC;
	Mon, 27 May 2024 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837814;
	bh=q3KWIXWiLsIk24cCXSJmCtnOb3ZaV4hLU/iTkDl/EbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrjjarsUo39bMvOKcCM9SF7LnB9MshCTRrrjazeJ3LbZ13B4EbpRt0wN0698wPkso
	 4gLcs0mXmt1F9/O6PkehqzDO3K0z97pAnYbIYqLKyudAm5409KoFY5tfH3IlSEKtGE
	 RzmjaQtoBMU2atccvuln0VVCOTNZjBUz5R8dg340=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 155/493] lkdtm: Disable CFI checking for perms functions
Date: Mon, 27 May 2024 20:52:37 +0200
Message-ID: <20240527185635.488691080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit fb28a8862dc4b5bf8e44578338f35d9c6c68339d ]

The EXEC_RODATA test plays a lot of tricks to live in the .rodata section,
and once again ran into objtool's (completely reasonable) assumptions
that executable code should live in an executable section. However, this
manifested only under CONFIG_CFI_CLANG=y, as one of the .cfi_sites was
pointing into the .rodata section.

Since we're testing non-CFI execution properties in perms.c (and
rodata.c), we can disable CFI for the involved functions, and remove the
CFI arguments from rodata.c entirely.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202308301532.d7acf63e-oliver.sang@intel.com
Fixes: 6342a20efbd8 ("objtool: Add elf_create_section_pair()")
Link: https://lore.kernel.org/r/20240430234953.work.760-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/Makefile | 2 +-
 drivers/misc/lkdtm/perms.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index 95ef971b5e1cb..b28701138b4bc 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -19,7 +19,7 @@ KASAN_SANITIZE_rodata.o			:= n
 KCSAN_SANITIZE_rodata.o			:= n
 KCOV_INSTRUMENT_rodata.o		:= n
 OBJECT_FILES_NON_STANDARD_rodata.o	:= y
-CFLAGS_REMOVE_rodata.o			+= $(CC_FLAGS_LTO) $(RETHUNK_CFLAGS)
+CFLAGS_REMOVE_rodata.o			+= $(CC_FLAGS_LTO) $(RETHUNK_CFLAGS) $(CC_FLAGS_CFI)
 
 OBJCOPYFLAGS :=
 OBJCOPYFLAGS_rodata_objcopy.o	:= \
diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
index b93404d656509..5b861dbff27e9 100644
--- a/drivers/misc/lkdtm/perms.c
+++ b/drivers/misc/lkdtm/perms.c
@@ -61,7 +61,7 @@ static void *setup_function_descriptor(func_desc_t *fdesc, void *dst)
 	return fdesc;
 }
 
-static noinline void execute_location(void *dst, bool write)
+static noinline __nocfi void execute_location(void *dst, bool write)
 {
 	void (*func)(void);
 	func_desc_t fdesc;
-- 
2.43.0



