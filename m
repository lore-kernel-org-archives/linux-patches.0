Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C352C9D;
	Mon, 23 Jun 2025 21:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713641; cv=none; b=kDZ6E+rY57rL3z8d+gwaffG90Q6XFdzPPuHO9Ej9x5sfMfRItamg1x6IQhUpau3otrtjVN9uyZFw92u65FGViSlT0uKxAlAjbe3ESy/XNhJ+uAA7CEXlXcN4cMU2xo05dzvf0lTperImZNWNbxoSxV795YmVfRtk5j1NHj0WI28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713641; c=relaxed/simple;
	bh=i8kexhNRU58Fyl4mB0IE7CARZMSNVGt2ah90XgS4+tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiP+tYMHznnzO/VSEr2B/qIQPm+GRkW29raJhidaIMrHCL4Wz8ETuHKW4Y/rIRGzcmWSS4hdMi2I/CJ9Zr2xoIheb63IRdlDmd3G6+A3QBF6Eiq2ferjwp1f9PDncTosDd+jMpe57m/n/JfIgMKGDCpEy20kJczAg3yTIO+snSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXmF1COQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXmF1COQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976C7C4CEEA;
	Mon, 23 Jun 2025 21:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713640;
	bh=i8kexhNRU58Fyl4mB0IE7CARZMSNVGt2ah90XgS4+tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXmF1COQPd/O/bdksVw9h0bSpyIJOtfyY141RFH1IhNIzO2lzke5pyUIYFuP+vgOE
	 NPdknCT9KNYKTI6lbl5GhxfWYYSkusHWvpNnbq1Lp1EVYj3EEc4pilYuMDl2thU4Vr
	 tqxRSWwu5eP1JvMKPR6eH5NSEH6011OQmPH7S+cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 157/355] kbuild: hdrcheck: fix cross build with clang
Date: Mon, 23 Jun 2025 15:05:58 +0200
Message-ID: <20250623130631.424212811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


