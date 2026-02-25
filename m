Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D047251795;
	Wed, 25 Feb 2026 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982843; cv=none; b=O3o5TT4gKPOrc38yN7Irl2kmshgpFfO8g4WyQklHeUzyg8cImhaA5GglKK/iSRLgvRwF8Ku6N8yceRyukBRKQYlZw0lF80OK9ALYph59MRyxW8G+7tSu4N6U3dD9VXNIP2Pv6DBV6bl3E12g7K822HpenliqRQsCO+3OaUzU1E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982843; c=relaxed/simple;
	bh=ueD9FG3eH68AWgnKF7Rvj1rolQ8Zbh4YCqPopkHn1nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kaMPUnV/OI1TphzAVYHMOTTxG3zq0amxkmGYqufXbxn8qZGn2+Wut/likeDhOW0uyD73fWHGANO5IdBfYlEqqNNmCgi/2E2rfZjGE1uCZns5g9/FHjI1nTbBzfRk+tPKzhDw2cgA9bhhGbv5a6XjxkieTh2B0BG/WB2zH7ALLEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ww1z89DO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ww1z89DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378B8C19423;
	Wed, 25 Feb 2026 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982843;
	bh=ueD9FG3eH68AWgnKF7Rvj1rolQ8Zbh4YCqPopkHn1nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ww1z89DO4X0Q4lYFST33w9vlqDSQhqvhqurBRCw8eL7v4ViE71tAt7sVaFZ9h5PqX
	 cbfBvZpQOkY2YL7u6jBpOMjlPHyC0umxZQ4fMmrVBV5g+8DmyUANcmMizeQn0YX82E
	 KTVaFggaxjfoNFGnSpWxHOoZ9XFaFmeExzPgV4Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	Heiko Carstens <hca@linux.ibm.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/781] tools/nolibc: always use 64-bit mode for s390 header checks
Date: Tue, 24 Feb 2026 17:12:24 -0800
Message-ID: <20260225012400.564663361@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit cc6809f6728456c03db6750fcc94ed8b581a2cf8 ]

32-bit s390 support was recently removed from nolibc.
If the compiler defaults to 32-bit during the header checks, they fail.

Make sure to always use 64-bit mode for s390 heafer checks.

Fixes: 169ebcbb9082 ("tools: Remove s390 compat support")
Acked-by: Willy Tarreau <w@1wt.eu>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://patch.msgid.link/20251203-nolibc-headers-check-s390-v1-1-5d35e52a83ba@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/Makefile b/tools/include/nolibc/Makefile
index 8118e22844f19..afb6a20ac1336 100644
--- a/tools/include/nolibc/Makefile
+++ b/tools/include/nolibc/Makefile
@@ -103,9 +103,12 @@ headers_standalone: headers
 	$(Q)$(MAKE) -C $(srctree) headers
 	$(Q)$(MAKE) -C $(srctree) headers_install INSTALL_HDR_PATH=$(OUTPUT)sysroot
 
+CFLAGS_s390 := -m64
+CFLAGS := $(CFLAGS_$(ARCH))
+
 headers_check: headers_standalone
 	$(Q)for header in $(filter-out crt.h std.h,$(all_files)); do \
-		$(CC) $(CLANG_CROSS_FLAGS) -Wall -Werror -nostdinc -fsyntax-only -x c /dev/null \
+		$(CC) $(CFLAGS) $(CLANG_CROSS_FLAGS) -Wall -Werror -nostdinc -fsyntax-only -x c /dev/null \
 			-I$(or $(objtree),$(srctree))/usr/include -include $$header -include $$header || exit 1; \
 	done
 
-- 
2.51.0



