Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBFC31D399;
	Mon, 27 Oct 2025 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592575; cv=none; b=rFtEuA8eFvPUjQe8FL5wzvYXIF3i3ewLZbXO0semdpThVYcZNWxtkp3Vorb9a1yrISbSJW1ONXqJXSF1ADwuDqY7TkBpuTyB4iGWrc6JUjhMKzEkMMnz1jytmgtGwj3fmZo3jTP0HD79O0gscP5IDalhkK2eeFYn59+JGx2b5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592575; c=relaxed/simple;
	bh=yZgcKAJIcrJFvc6zYgj4WEh+LrirqMMUIP/2ftLRfnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSXPFoygLTbnktSF3cZvfwfdr8HBZ50HCayVG8jjBpFevpXHA6uDoYAOtpqeETWy9OSrA8ZwePhk9Fmc3Tjp3Tf31uu4FKe4OJQtirk2oZClsKcrs05DFC29eCLnbeKVdjxqHT+IEcS6Uax0RIELVuHDccPd4bOP7RyFsRZXdUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FctM8cU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FctM8cU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2C3C4CEF1;
	Mon, 27 Oct 2025 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592575;
	bh=yZgcKAJIcrJFvc6zYgj4WEh+LrirqMMUIP/2ftLRfnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FctM8cU0HYcWcCr7qyzqFPeOdsirFww0FhAPJRhmTwsz1MVdeto49ivLubSjp5XkP
	 wsMb/hwZ/PTek+Xz4nha1p8r67W4nG7pLJwM7nx8qZsh13EUwWELvC8Pvwnec1tRPk
	 7qi6OzoR8CH6GbHx40ch1G1Hfl3+MVDxSo1Ay/L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/84] Unbreak make tools/* for user-space targets
Date: Mon, 27 Oct 2025 19:36:05 +0100
Message-ID: <20251027183439.248736733@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit ee916dccd4df6e2fd19c3606c4735282b72f1473 ]

This pattern isn't very documented, and apparently not used much outside
of 'make tools/help', but it has existed for over a decade (since commit
ea01fa9f63ae: "tools: Connect to the kernel build system").

However, it doesn't work very well for most cases, particularly the
useful "tools/all" target, because it overrides the LDFLAGS value with
an empty one.

And once overridden, 'make' will then not honor the tooling makefiles
trying to change it - which then makes any LDFLAGS use in the tooling
directory break, typically causing odd link errors.

Remove that LDFLAGS override, since it seems to be entirely historical.
The core kernel makefiles no longer modify LDFLAGS as part of the build,
and use kernel-specific link flags instead (eg 'KBUILD_LDFLAGS' and
friends).

This allows more of the 'make tools/*' cases to work.  I say 'more',
because some of the tooling build rules make various other assumptions
or have other issues, so it's still a bit hit-or-miss.  But those issues
tend to show up with the 'make -C tools xyz' pattern too, so now it's no
longer an issue of this particular 'tools/*' build rule being special.

Acked-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index ad3952fb542d3..de7b2f9a50338 100644
--- a/Makefile
+++ b/Makefile
@@ -1358,11 +1358,11 @@ endif
 
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
+	$(Q)$(MAKE) O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
+	$(Q)$(MAKE) O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/ $*
 
 # ---------------------------------------------------------------------------
 # Kernel selftest
-- 
2.51.0



