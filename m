Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0781EF082;
	Wed, 19 Feb 2025 08:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954858; cv=none; b=OkkPpvZpT17MCGry2ZW5ATvcilfx8c9ZCYE+OgiqflXzIJrcJBcDSP54nURg73aOR6ARmCMtn/7OiNbAvv39gA/LxrN2Ykgt1nRz0qsIo0ZqqNIAbaAGOgMiXXSuWbtd4Y/ggVu7xUo03LbBDQiHyFpNvS2W/+PqByv6TFvjlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954858; c=relaxed/simple;
	bh=P0xdb9MTAvZgcj3gcL00UMwrmv9IjV5DwaOT9wbPtzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sho5XdkuXybgeTCpuRDj/fUciD+WsIZTKeR7RCYtXGsK9oKejxPx6CKFDDLtphFxleNUs9HwoTJ5kAGi6VLoxE4isRlEk30TZJlPOHkJI0wqwclLzVXTq6vlyV7BhzlYzbKdhBzTNHFrrSWX0w+S5JCU/lcm56YIEBtlQaPTZa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFh6oNdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFh6oNdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EABC4CED1;
	Wed, 19 Feb 2025 08:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954858;
	bh=P0xdb9MTAvZgcj3gcL00UMwrmv9IjV5DwaOT9wbPtzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFh6oNdgEjOmz0x6gK6/Z0rOo++3rsMohydxKcZAXdi4o13BKFxX0kplfoWLXkYex
	 HQkmo9bbZXjuX4kNi/WTU7590R5PSc/wyHrMPO84Dg53MbPHSuKbGQ4Gz7rOJi3ioF
	 0UM8QmyGmuFcsWDSeH167MH3+CZQ38faFug4a2Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/230] tools: fix annoying "mkdir -p ..." logs when building tools in parallel
Date: Wed, 19 Feb 2025 09:26:14 +0100
Message-ID: <20250219082603.946669484@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 26a471dbed62a..40c97774c4e4b 100644
--- a/Makefile
+++ b/Makefile
@@ -1357,18 +1357,13 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
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



