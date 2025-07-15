Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6843A26CE27;
	Tue, 15 Jul 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586327; cv=none; b=E8loqyHe/VnrvFt7qpvTsVa86TauXnhPWWxOYjmvCE96Fc8isbKqwNCnJ2HPA2V6X6SzIkxV9+jEBTtfNNvV09sHF0k9fRm2khCiBJB3B+v/RycB9vmL6iPJ+QLmpCp3i3hvfUaLm6z3UIXdUhoj9ScSt6k/b1yBlrQL+zKO3KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586327; c=relaxed/simple;
	bh=IK5ZbOewQwQb0kAygMTys0tx3ZR09s4Fe7KgcjYhUSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k03m9u3bp7eiCL+Rrzvijc9kQTdcZH6L3O2SEIW7txIe7cXzqBGZfgLPXIJLWgXlMKg+z8geR8aFQ7fJApbxRvpCpJ+wa1CpTaJ2E3u46rLg8SRjGT0Og2Wv1kPNzND3DSeCfp6cCfWGOX2lk35q7Aep2cxylfX00pJj+YWk9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR1qv3sM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR1qv3sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17E1C4CEE3;
	Tue, 15 Jul 2025 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586327;
	bh=IK5ZbOewQwQb0kAygMTys0tx3ZR09s4Fe7KgcjYhUSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR1qv3sMaT3n/Uo51P2gF1bRu9Q5k97U7Uu3LCA0eMmMvA5AWMS4LKy/kPs3A3U5A
	 iEofbekj8bY2opNC6Yow+lb9M/QZCg4IqbN7qCrcq0U8H/NiRRHAylACp8qvi1bDVV
	 WzC3oneshRqj/8JLHOqJY8oBhFRVCfvMZi9HaKMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/148] kbuild: hdrcheck: fix cross build with clang
Date: Tue, 15 Jul 2025 15:12:25 +0200
Message-ID: <20250715130801.244123767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index de6f9bffb01ed..293cccc01387e 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -10,7 +10,7 @@ UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
 
 # In theory, we do not care -m32 or -m64 for header compile tests.
 # It is here just because CONFIG_CC_CAN_LINK is tested with -m32 or -m64.
-UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 override c_flags = $(UAPI_CFLAGS) -Wp,-MMD,$(depfile) -I$(objtree)/usr/include
 
-- 
2.39.5



