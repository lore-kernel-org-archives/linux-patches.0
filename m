Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20780476CE1;
	Fri,  7 Aug 2026 15:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117150; cv=none; b=DCyBNTHCN8H9DXcNQOnTtmEufnUgzmC2ifIeEhl0jWgs7PxfxgppyFkUGAJ2OazrBVPPGemAklDC4DJNNL7KSA+8XAc7/TjbMBH42QMU2o3SOWKCVcYrvZBMM3XC+aYY14Qcvogk1RtXXug+8Z+4/h4FJ6RohJBn5rtLV56YfJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117150; c=relaxed/simple;
	bh=AKKLBGDgGgnuTk+gBF20mj+szPyDaMYRMvIZoEjuJvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVkeYEZTfL0Gc4dNx2eTpyuVCA0h/djFpr2hsW0Zy73l7HFsbmj+O3BnvVD5yd89rvpRQR2mE2Yaqw7o85LbCZd79wAElmdC4E+pWTmueJJotpWGRJ3tvKl/kLZLSeDM+B0q87JwEC3J4FvyDxvs88LCxwuTjk/YWw/i0TMJq+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keFv/iPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keFv/iPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A971F000E9;
	Fri,  7 Aug 2026 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117148;
	bh=pY0V3APU7nJaZYc4nhZwOcVjcanPr/Ya+mSqOZojpfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keFv/iPLdcxVDVrO2GjKqlS81b4d2LpTRwk7CmpDa8MQqHtp7Tr38jbcSQp+avuST
	 sc6RBkDDNG9wEpZYwz8/S7zyI25EvKkFRrGfRWjdB6xiSPvc7zeQXRC6/xL+VvuvxK
	 4oNTmgJ0IPi/cgXEWoWBC56DnJkPj6myX6Y9FZ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.1 210/438] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Fri,  7 Aug 2026 16:36:46 +0200
Message-ID: <20260807143432.490639417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,6 +166,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


