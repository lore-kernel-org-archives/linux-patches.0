Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B123237B;
	Mon, 10 Mar 2025 17:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627809; cv=none; b=vBRM6g7rNjWH7BNmQbXbkLA1GuS6v3MfooxJ7CnI6ve9IzwFWFZorurRAnWRjAZy+P144tlnkeLH5oNkXKqxiWqeNNYL978QG/ID5XrJu+bkDYQq0S9XQjiWlkcfpOWLKEZLn/RQcraXN2KpRHkGVbCywpqN47ZFSJVMZdcIed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627809; c=relaxed/simple;
	bh=Lvk2fZdBptajIl8ZQ/212GVphBd8KB/4kzNxlrYIkRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODwr54vKkK4XnHEGLO9gSV0yJo49c9/gryVQfGCRR0CHsAK9DosVCf9hm9BeVCqkt5gXhUYqVoFp/4QzLWD9CCrVVmCTZQwjbJmPd3oauIZcvigB2AV6Glji6Yf1aBoqVy8xBQukJ1WhXgR/TRasPMuK3LHvSPgPj+ptKDB2Abk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyLsd/N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyLsd/N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437AEC4CEE5;
	Mon, 10 Mar 2025 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627809;
	bh=Lvk2fZdBptajIl8ZQ/212GVphBd8KB/4kzNxlrYIkRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyLsd/N303BoeB8M+Jjnu3ViEygD0L9j7GQlBL6R7loQsmwcrMMfjvM/OCO03VHfW
	 Y15Du0GBYm7Ole3arONqT+j8WoLJ7MI0AFuQHZGs/t2jR2GYZnOeDUR1BjiBfBmlvG
	 8Ha+9hts6w1Y6e40xV3QlsTInvpVljAbVTZ31ek4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/269] kbuild: hdrcheck: fix cross build with clang
Date: Mon, 10 Mar 2025 18:06:51 +0100
Message-ID: <20250310170508.075008581@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
index 771e32872b2ab..58173cfe5ff17 100644
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



