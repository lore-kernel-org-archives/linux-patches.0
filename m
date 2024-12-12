Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FD1216E2D;
	Thu, 12 Dec 2024 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023663; cv=none; b=arHK5Hlfi0MNkBa9Ohi07A6742O41a0C9jgOLFCNid6ORrWnO0lnuZoJ/xsVsbKy5A3jsZi2y3x5cCH6iCsnQKA2ImUqn24xcjFl9VTt8TYm5Ng3ZPGLGzoMJUP4H2hnF+ubGoWu/8Q9nE4gWY1YGSDVoGfqB/J9ZhJNQR4dIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023663; c=relaxed/simple;
	bh=/Sk/KzHskv6mcG8MXSMnEPwEZM7i0uNxfKllwwNIx6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnnf53bgNLUX3uYZUnHz7pju7zhV9LVyamemP6LzXLJ/z8y/1tsNLEgJb6tyAv0T6oM6iN+8BhMyHZF9QGcpC0wo4+kIm+2F2dmnzy67ebGEVOUn6kqbpjhtgamoeC4PYg2H83V6+VjutfuJ1COheWvlHNsDUkTxIpj42gqycQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3q9a82w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3q9a82w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236E6C4CECE;
	Thu, 12 Dec 2024 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023662;
	bh=/Sk/KzHskv6mcG8MXSMnEPwEZM7i0uNxfKllwwNIx6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3q9a82wChJsAxI2jifucZ1Uu1iyJP1LjZ+n1h8094np/Lt5xITk3ONtPJXFsoZBT
	 AwfzO5hGh4r0gttBb2/2knUiFBdlFnLfC6MP11yhabY9r1jeO0Q4yfwURfhVo0GHgO
	 nd5ynwBYeN38M95LpHHEP8z6xG7F62TbPQ0GzN7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/459] x86/amd_nb: Fix compile-testing without CONFIG_AMD_NB
Date: Thu, 12 Dec 2024 15:56:18 +0100
Message-ID: <20241212144255.111783429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 455066a06f607..d561f7866fa16 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -118,7 +118,10 @@ static inline bool amd_gart_present(void)
 
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



