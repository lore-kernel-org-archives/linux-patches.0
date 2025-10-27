Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9BD238145;
	Mon, 27 Oct 2025 19:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593221; cv=none; b=PyHgQAqCiFEBHAAPPNJEhlzhAWsX92ErNh4iXcjd2Ylr1gAsLiSNz8QgvVLxfNoJdaqPVq84m4+CVkshgeNhrmwWhxFzpi57PIAZMB2LWMSfOlXU9HwBrmre/jrpxuIKuJfRq/+y67YrJ5/p3R6VkFiKZ6n2D/y/2E1Krhenpic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593221; c=relaxed/simple;
	bh=q7Tnss5R9Z1Zb1hGXJpSz6lITkSp87L6dYPHI0LrBgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9zd4TMmH5hTw4OxFpdY8LZptfdQQL+HRrXlsmw9oWTrtE7W4Wb1t7HXj/e76qe4pfY/l8zUp9KNikKzd0yHgt/aBxMy1nSlmxLgL1Cl7tpGDKIbm4imwClnolZpwjrb1UmgBqMYTloSKnY69opt+HLGDiDnU0VawEyK/iXgYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvM9kdg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvM9kdg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC30C4CEF1;
	Mon, 27 Oct 2025 19:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593221;
	bh=q7Tnss5R9Z1Zb1hGXJpSz6lITkSp87L6dYPHI0LrBgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvM9kdg+VNLGRgWcw8M3/fRQLdpzmHE5VSSXkCS+nJ2H0xmzIwblqBE/cO5Sjwd4W
	 rcjOWGt1uXhBOJnwH0F07OWcwtY8YZcqz7hApd12SmNefF/RmKUFFKCXJVDcMDa4+4
	 pAZJJyX1Jfmwiq2BzhWNRY9jCQaiTwmDjLo7iA7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 032/184] Unbreak make tools/* for user-space targets
Date: Mon, 27 Oct 2025 19:35:14 +0100
Message-ID: <20251027183515.787974797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 072a3be625510..356bf65e5e7a2 100644
--- a/Makefile
+++ b/Makefile
@@ -1444,11 +1444,11 @@ endif
 
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



