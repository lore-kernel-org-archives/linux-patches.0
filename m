Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433D1A841F;
	Wed, 19 Feb 2025 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955499; cv=none; b=EjPCyTTY03aYlT+MIITQ1cWQ+EPRsEqk07mLWPo/yX/IIFZlYsFr6mF5wJa1AoEinbCHJ9ayx41rBhKGkNGEIsbzgnHifaUqrsjSp0ovb8j/E5BQQnvOsedHpcEKCfDyZUUdbI8C0inSL1V6mpQLwgMyZC2U4n/zdUlMPu+u2mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955499; c=relaxed/simple;
	bh=KE9Vjn9kR9/8331Rm8HcHClKvXHCIiHs5JTcwpZz+O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDoNpHZCsvvL4Xlmi4Qc3Hdqn1HzyOKMLZz2W9LMszSPv+Mh6i3ORiGprbl7RobtE/pqZM2NWK8k1NCy4aUeM7FFMj1+E7lCNR0w7+BlnNVvn9J3Qu9/XpqnYHQGVaghKVaMM8RdYCSvdrge0A8A8MO0BpZ50ZSXPU7iT4WjDXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuT8D5hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuT8D5hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9571C4CED1;
	Wed, 19 Feb 2025 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955499;
	bh=KE9Vjn9kR9/8331Rm8HcHClKvXHCIiHs5JTcwpZz+O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuT8D5hA2VG+FVMY1xQJHKLj9f8s4E0nldvPfc1/HaNTLgRtWeIxkK8DR6ygYb7lv
	 ouIgeP6yWGQYV5lWtvRHyBdSMHF73TfPo69wOOpO/1Xv6j6zwHdzzpvVCFXClp6+FO
	 U+MQeltPeMUAIlk4m64B78R/b8Og+bjM71Hoqyko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/152] tools: fix annoying "mkdir -p ..." logs when building tools in parallel
Date: Wed, 19 Feb 2025 09:27:18 +0100
Message-ID: <20250219082551.032571237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d1d0963121769d8d16150b913fe886e48efefa51 ]

When CONFIG_OBJTOOL=y or CONFIG_DEBUG_INFO_BTF=y, parallel builds
show awkward "mkdir -p ..." logs.

  $ make -j16
    [ snip ]
  mkdir -p /home/masahiro/ref/linux/tools/objtool && make O=/home/masahiro/ref/linux subdir=tools/objtool --no-print-directory -C objtool
  mkdir -p /home/masahiro/ref/linux/tools/bpf/resolve_btfids && make O=/home/masahiro/ref/linux subdir=tools/bpf/resolve_btfids --no-print-directory -C bpf/resolve_btfids

Defining MAKEFLAGS=<value> on the command line wipes out command line
switches from the resultant MAKEFLAGS definition, even though the command
line switches are active. [1]

MAKEFLAGS puts all single-letter options into the first word, and that
word will be empty if no single-letter options were given. [2]
However, this breaks if MAKEFLAGS=<value> is given on the command line.

The tools/ and tools/% targets set MAKEFLAGS=<value> on the command
line, which breaks the following code in tools/scripts/Makefile.include:

    short-opts := $(firstword -$(MAKEFLAGS))

If MAKEFLAGS really needs modification, it should be done through the
environment variable, as follows:

    MAKEFLAGS=<value> $(MAKE) ...

That said, I question whether modifying MAKEFLAGS is necessary here.
The only flag we might want to exclude is --no-print-directory, as the
tools build system changes the working directory. However, people might
find the "Entering/Leaving directory" logs annoying.

I simply removed the offending MAKEFLAGS=<value>.

[1]: https://savannah.gnu.org/bugs/?62469
[2]: https://www.gnu.org/software/make/manual/make.html#Testing-Flags

Fixes: ea01fa9f63ae ("tools: Connect to the kernel build system")
Fixes: a50e43332756 ("perf tools: Honor parallel jobs")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 1d777c3eb7fb9..cbd091c511d82 100644
--- a/Makefile
+++ b/Makefile
@@ -1348,18 +1348,13 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
 	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
 endif
 
-# Clear a bunch of variables before executing the submake
-ifeq ($(quiet),silent_)
-tools_silent=s
-endif
-
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(tools_silent) $(filter --j% -j,$(MAKEFLAGS))" O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
+	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(tools_silent) $(filter --j% -j,$(MAKEFLAGS))" O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
 
 # ---------------------------------------------------------------------------
 # Kernel selftest
-- 
2.39.5



