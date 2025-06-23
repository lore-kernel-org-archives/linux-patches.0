Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666681E5B71;
	Mon, 23 Jun 2025 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714145; cv=none; b=F2Rk2df9Ctv8m+XpXmi2sre8onwjDRehC9LjVnbiafdb5gKS7J6z5uytA/VL6nUT1xdqcHfP6ovggxod5KfOW01HJWbPlwlDaVnb0lZukw63DXrK4MySypDlmh61JpJ3iEK13fXUbP/fAsMGv0E9DIo8BV4tpvGdGd5SDqDB4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714145; c=relaxed/simple;
	bh=YbjmE5hd7o/sh/AS273lWDlDrxPItl2sOeC6gAHDw8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5G9vXCjLCU6c8nad++6ZRTumuEem0Al7zHDY8LY7Lv6x6rZ4lNcjrTSNnb+xO3Wn0nPwCDbOsPtSl0pqaoQ8vpBC7j58nlRajzj964lGjeiiH7DlaQIMxm0/TWTzpR4Jp0m6aoipFcWwd/r5WbTWvthYPF8zpeO4WFK39IHqOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3wVDHdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3wVDHdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F42C4CEEA;
	Mon, 23 Jun 2025 21:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714145;
	bh=YbjmE5hd7o/sh/AS273lWDlDrxPItl2sOeC6gAHDw8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3wVDHddgldxUUf0qs5p5YUgYdKq5tdnt3r9FxctZAJ4aFb70mhQekMUlG76fPDeH
	 xV1VttCyBG7pC8/wqRwPhGiIvXhEXNN36bcod1ceI+9tm1eq/ox+2Dru3A08UlXHGk
	 NQ3sIj7imdr2L/XMCPB0nEkPHKxXe34ME9bWDnKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 190/411] kbuild: hdrcheck: fix cross build with clang
Date: Mon, 23 Jun 2025 15:05:34 +0200
Message-ID: <20250623130638.462567851@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 02e9a22ceef0227175e391902d8760425fa072c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 usr/include/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -10,7 +10,7 @@ UAPI_CFLAGS := -std=c90 -Wall -Werror=im
 
 # In theory, we do not care -m32 or -m64 for header compile tests.
 # It is here just because CONFIG_CC_CAN_LINK is tested with -m32 or -m64.
-UAPI_CFLAGS += $(filter -m32 -m64, $(KBUILD_CFLAGS))
+UAPI_CFLAGS += $(filter -m32 -m64, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 override c_flags = $(UAPI_CFLAGS) -Wp,-MMD,$(depfile) -I$(objtree)/usr/include
 


