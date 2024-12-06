Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9162066F0;
	Fri,  6 Dec 2024 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496571; cv=none; b=lb9oqSZ8RmoBhe1yJNOoZmePEK9u1OlaS69z1XvTWgHon64Ts4hI59LtQEeUnpUWdwXxDaE9nDMSDCzCrhYoBBA5Qe/n0roSZRO1aH52rVVlVF2nCRpl7K5iicnbSoMyuAfurI5Lc17BjQphanRmuxAjSOL8ZHD/kRf1jizcD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496571; c=relaxed/simple;
	bh=oi2Tn8VPatbtRD+bdf9hbSbwiCmPd/HTF8baez/Bbjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AH+izGE9jUO3YIqP3rRAgafPFFYnSBxl1sEvYdHzVWfss6ZpVMCOfJU4LyZJRswtRlkaph899Zsrj+UQ0pqgCyLvtPtuG6sbEiev4IIZ/1qjOa9mOa16hw0i9CG8hwcDdpT2Q8iaQIeZIYxTRPh9O3gTxguEFkx4+Ul3WVKiCVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+BIk1Oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+BIk1Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF61EC4CEDE;
	Fri,  6 Dec 2024 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496570;
	bh=oi2Tn8VPatbtRD+bdf9hbSbwiCmPd/HTF8baez/Bbjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+BIk1Oa0QJH51+xtw1ZZimqjVUOnBtHP5m8fk3T1qxkTlpw6OEUgEBNU1Icm/Y2m
	 RkQLcdJrcj0VZoykJL0F1QbkuO1S6d44Jveebo0ZSUdxLAr0ZOqbL346WdXPSAac68
	 yddMOcT5qlsiUlPc0PuF/gRuH5PnZOWkbV2vZFgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/676] x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB
Date: Fri,  6 Dec 2024 15:27:11 +0100
Message-ID: <20241206143653.837564680@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fce9642c765a18abd1db0339a7d832c29b68456a ]

node_to_amd_nb() is defined to NULL in non-AMD configs:

  drivers/platform/x86/amd/hsmp/plat.c: In function 'init_platform_device':
  drivers/platform/x86/amd/hsmp/plat.c:165:68: error: dereferencing 'void *' pointer [-Werror]
    165 |                 sock->root                      = node_to_amd_nb(i)->root;
        |                                                                    ^~
  drivers/platform/x86/amd/hsmp/plat.c:165:68: error: request for member 'root' in something not a structure or union

Users of the interface who also allow COMPILE_TEST will cause the above build
error so provide an inline stub to fix that.

  [ bp: Massage commit message. ]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20241029092329.3857004-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/amd_nb.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index ed0eaf65c4372..c8cdc69aae098 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -116,7 +116,10 @@ static inline bool amd_gart_present(void)
 
 #define amd_nb_num(x)		0
 #define amd_nb_has_feature(x)	false
-#define node_to_amd_nb(x)	NULL
+static inline struct amd_northbridge *node_to_amd_nb(int node)
+{
+	return NULL;
+}
 #define amd_gart_present(x)	false
 
 #endif
-- 
2.43.0



