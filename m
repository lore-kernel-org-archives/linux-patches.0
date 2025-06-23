Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327D2222CC;
	Mon, 23 Jun 2025 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715895; cv=none; b=J4PmiElxbYqLxefQRyrsK5Owmh95M0XePZZlCi/v2K2B0v8OUsCmv3TLRq8CFTi45ajo2alO+gqAF0ns/0JQHPeeqxfEMeq7+dQi87DwM4QWAohNMdVl0rD4Mhe3Cl0o6Q0IlUxMQXxjBND0ZkyNiGjCZPtlVbX0jr1WrFEfz3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715895; c=relaxed/simple;
	bh=siUatG7BR65LAKpqgyxW2zKtWI/xnq9OU4eFQ+le0q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYQHBJxG7VKq7/alNRqUZQzJkHb2s8s69GBVtN8UJ6sk4em1hO29ir8psIWb/iggr58g9MijDz3ZjP3rKO15PrrY43cgNiQWK8My+jScJDVBCOW+28LCbOPDDllBV++5eJBEDgqRl3xe8NxZ4vKMgZvIuENdrj41zIXS2WzXyeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0tPomyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0tPomyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD711C4CEED;
	Mon, 23 Jun 2025 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715895;
	bh=siUatG7BR65LAKpqgyxW2zKtWI/xnq9OU4eFQ+le0q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0tPomyYkeBmihzUb3+tbIVp9Bljla3gsOCyeO9aVGk7mDjOxfzYq4JrFLXDFXajN
	 yEXN00OtVCNMO9Zei9FNvRKazKz2CW4b0dT10Whj/axnRsCt8Ro9abVssx3wXQVCmd
	 DMLQHcI++f7EjSLZLsdT4YIXeaUoI4etO8zYmUtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.1 288/508] kbuild: hdrcheck: fix cross build with clang
Date: Mon, 23 Jun 2025 15:05:33 +0200
Message-ID: <20250623130652.360201979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
-UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # USERCFLAGS might contain sysroot location for CC.
 UAPI_CFLAGS += $(USERCFLAGS)


