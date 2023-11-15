Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C2364BE;
	Wed, 15 Nov 2023 19:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c11t7zb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB3C433C7;
	Wed, 15 Nov 2023 19:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076866;
	bh=xLwyxyl5mHdtKP57fbEVQ0eG81RmipvUgl1qlzuNBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c11t7zb99XvExUp+jMmlgUSjSpGgDu7HZrvw2S8qfgzkI9/7gfO7Uuoje+uamVJQ7
	 TMXJFC95WVqqXV4K2MJDjE3WaVK+QIk0Mt1Tau1QoALO2YSqayf2bfE2wDvqktVN/F
	 bE7xYdxh1Zgb2z1/KWouEUWo/VOdKWMGvIJTnMfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andy@kernel.org>,
	linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/603] string: Adjust strtomem() logic to allow for smaller sources
Date: Wed, 15 Nov 2023 14:09:38 -0500
Message-ID: <20231115191615.488749180@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 0e108725f6cc5b3be9e607f89c9fbcbb236367b7 ]

Arnd noticed we have a case where a shorter source string is being copied
into a destination byte array, but this results in a strnlen() call that
exceeds the size of the source. This is seen with -Wstringop-overread:

In file included from ../include/linux/uuid.h:11,
                 from ../include/linux/mod_devicetable.h:14,
                 from ../include/linux/cpufeature.h:12,
                 from ../arch/x86/coco/tdx/tdx.c:7:
../arch/x86/coco/tdx/tdx.c: In function 'tdx_panic.constprop':
../include/linux/string.h:284:9: error: 'strnlen' specified bound 64 exceeds source size 60 [-Werror=stringop-overread]
  284 |         memcpy_and_pad(dest, _dest_len, src, strnlen(src, _dest_len), pad); \
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../arch/x86/coco/tdx/tdx.c:124:9: note: in expansion of macro 'strtomem_pad'
  124 |         strtomem_pad(message.str, msg, '\0');
      |         ^~~~~~~~~~~~

Use the smaller of the two buffer sizes when calling strnlen(). When
src length is unknown (SIZE_MAX), it is adjusted to use dest length,
which is what the original code did.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Fixes: dfbafa70bde2 ("string: Introduce strtomem() and strtomem_pad()")
Tested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index dbfc66400050f..9e3cb6923b0ef 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -277,10 +277,12 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define strtomem_pad(dest, src, pad)	do {				\
 	const size_t _dest_len = __builtin_object_size(dest, 1);	\
+	const size_t _src_len = __builtin_object_size(src, 1);		\
 									\
 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
 		     _dest_len == (size_t)-1);				\
-	memcpy_and_pad(dest, _dest_len, src, strnlen(src, _dest_len), pad); \
+	memcpy_and_pad(dest, _dest_len, src,				\
+		       strnlen(src, min(_src_len, _dest_len)), pad);	\
 } while (0)
 
 /**
@@ -298,10 +300,11 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
  */
 #define strtomem(dest, src)	do {					\
 	const size_t _dest_len = __builtin_object_size(dest, 1);	\
+	const size_t _src_len = __builtin_object_size(src, 1);		\
 									\
 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
 		     _dest_len == (size_t)-1);				\
-	memcpy(dest, src, min(_dest_len, strnlen(src, _dest_len)));	\
+	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
 } while (0)
 
 /**
-- 
2.42.0



