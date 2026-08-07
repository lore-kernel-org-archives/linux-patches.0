Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F172F5337;
	Fri,  7 Aug 2026 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116040; cv=none; b=kYsS7L2F5eKC5NYu6TlqOcuZNi5wgk/YVqI4jS81kEvqgDWcBAkvhO6ssEiJUz0K1KYUa9vfRO7XbW3+2YFEXfOsWGqB4NWKB+srATu3fjfozZs2UOjCVAZQtflVIfVtnUoPBNG0GmanD62MZEXg13U3Snk9SwhR2SKpaqN+ZDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116040; c=relaxed/simple;
	bh=g3u4AvxhIy3K5IhZ83oq0+88DQ8u9i+LQ+SpuIYThtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXhTfz7QrlT6RY8Yx93JlPFkLuKSsq4/Pq70uj5sJmPagbjGwubLF+TtswpIyts60GZ2DqPCaYMdA5vRV2NQGT/88tw76OaG7iuBQfGqk28vxXfL06LUgJRu9MNXXDqfTs2Q5vf9snPPTNyzrhP44UTF0jQ7LXEcIEaTJwJg7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l4cm8KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l4cm8KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAF01F000E9;
	Fri,  7 Aug 2026 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116039;
	bh=kvJxBd3gc8t2QJ3OWeXPqsrbX6KOFd4kM0p1pakGax8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0l4cm8KMRshO70nppJhVKYLURxcKGpDdNjUoMjEwbcCXnmVLYxWPx/JufgjpkqC6r
	 cMV9MONtfOeuvM4oz2dzW3QKNFe8OI+9Gqy7T11YjZ/NSIJC7cwsn74a/ADfDv7ybI
	 o7E8W8zsN5b34AzgZBrP+CIOxf/WDMahnpndd0tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.6 091/261] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Fri,  7 Aug 2026 16:37:28 +0200
Message-ID: <20260807143417.349801867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Boortz <bennib@mailbox.org>

commit dad6e107b3cd9d20514e7799b7ad8674f81e3f30 upstream.

drivers/pinctrl/pinctrl-bm1880.c initialises its pinconf_ops with
.is_generic = true, but that field is only present when
CONFIG_GENERIC_PINCONF is enabled (guarded by #ifdef in pinconf.h).
The Kconfig entry for PINCTRL_BM1880 never selects GENERIC_PINCONF,
so any config that enables CONFIG_PINCTRL_BM1880=y without
CONFIG_GENERIC_PINCONF=y fails to compile:

  drivers/pinctrl/pinctrl-bm1880.c:1288:10: error: 'const struct pinconf_ops' has no member named 'is_generic'

Found by randconfig testing on arm64; tinyconfig reproducer below.
Add the missing select to fix the build.

Fixes: 49bd61ebce5f ("pinctrl: Add pinconf support for BM1880 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Boortz <bennib@mailbox.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -132,6 +132,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


