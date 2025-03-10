Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB0318DB24;
	Mon, 10 Mar 2025 17:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628225; cv=none; b=oOfcRvwUeuOnvn386C2ER2gpguryLp2GkSKCIRG2X1lANTQQyT7w3ZWoKup/4qtI+ylxAga25Bahk/FM8BYYgt4xLk+qdHhAsx9asrPvmLjC0VHs0ZA5ov+wkPSIqaNX0bKKHj9Pqo+tPGH2awVI11uHtT83DzEmwKTHqyEfYUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628225; c=relaxed/simple;
	bh=yCIVfpzcTjRI9NwI+MOGxx0mUb+UVAOpx2yyuS9R44k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIB00c1QkXTcAUkyl2zKi3B4EAweV3WuaHiqLKRzpxFZEc44Emt+viQ/eyVqRru3xIakbOWtXvc8tUilOi7Ypoib3ufG6gGFLrEEFs817glvEylG9QNBpaOnSN4jrHiT0YyYTe8jdoHQjg8/2WzdKGwyALxna3ThKEUxNezEa/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT4iiJS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT4iiJS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6CAC4CEE5;
	Mon, 10 Mar 2025 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628224;
	bh=yCIVfpzcTjRI9NwI+MOGxx0mUb+UVAOpx2yyuS9R44k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT4iiJS6LOUNDkTLKIkWp2bjX+dqU/VWfw34H3osM6NdwCuK46hpvYzXoMgTph57j
	 dKssGdIuDRdbP26kOP/IMV7ILlMNeaE/xysQ8yCH3JAPzGrwNWFV8t3enRYbyTVmT6
	 2uZP3eQEU/DuMWa7kKSfRhmK36Xw3pRYpIEU/sUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/145] kbuild: hdrcheck: fix cross build with clang
Date: Mon, 10 Mar 2025 18:07:03 +0100
Message-ID: <20250310170439.974180623@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 02e9a22ceef0227175e391902d8760425fa072c6 ]

The headercheck tries to call clang with a mix of compiler arguments
that don't include the target architecture. When building e.g. x86
headers on arm64, this produces a warning like

   clang: warning: unknown platform, assuming -mfloat-abi=soft

Add in the KBUILD_CPPFLAGS, which contain the target, in order to make it
build properly.

See also 1b71c2fb04e7 ("kbuild: userprogs: fix bitsize and target
detection on clang").

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/include/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/include/Makefile b/usr/include/Makefile
index 07796df0a295b..c16fbabb36258 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -10,7 +10,7 @@ UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
 
 # In theory, we do not care -m32 or -m64 for header compile tests.
 # It is here just because CONFIG_CC_CAN_LINK is tested with -m32 or -m64.
-UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # USERCFLAGS might contain sysroot location for CC.
 UAPI_CFLAGS += $(USERCFLAGS)
-- 
2.39.5



