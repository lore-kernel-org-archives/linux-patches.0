Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFC33016F9;
	Mon, 27 Oct 2025 19:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592811; cv=none; b=Lmt9b4L5bBubbqCp/RCTOWxotXzH3LsOONeAx4jvcAmEnyFELeWJbtmwEof8g/KUdTLT0eGf9fuOtA63+nB2DKzlhOXTUD19O7ysvJJl2GfQnl5v9m9gKZSwLkH9gwyJvXqcIlYNJLVjEE0vBEnycaw+o/1tLBerLBhtVppOI1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592811; c=relaxed/simple;
	bh=2GVRt56IMnNCA6ZaSgfweKoQrj4yOErVnLpOUzaev6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdF4TCD1VUAtJskj2yB5DYwPB0p+0Qba4dUUWaES95DsWkQ2+fjoG1DLlHFqISYmQe3wQxpncNG6/iOGGoQJ4eSrQEbi9WqZYCBORJiVyNnyWju+MiyYsK2cA56q+ZnL1yf3svSoUi2Lb1qo9HPreZNynEFFyijLfp4CfiIeJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGNSI2dC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGNSI2dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72170C4CEF1;
	Mon, 27 Oct 2025 19:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592810;
	bh=2GVRt56IMnNCA6ZaSgfweKoQrj4yOErVnLpOUzaev6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGNSI2dCqbSACyzPWjJeMC2+R7YaX4VvKe+sg/BcdNDfik/UQ5f8q++g59+QkUm9/
	 oZzPH7oOMQX2VYT/EDpe2+H9comD9UdslNpv3zf2lv+O1LNuIYG7PUe78ua0a6Ph2c
	 6T2+1I2zLkurY4UdciTAoavKjU/8cipMYZnpqdzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/117] Unbreak make tools/* for user-space targets
Date: Mon, 27 Oct 2025 19:35:46 +0100
Message-ID: <20251027183454.500247590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d4c679b2d4bcf..0aa9fd3ab9a1c 100644
--- a/Makefile
+++ b/Makefile
@@ -1372,11 +1372,11 @@ endif
 
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



