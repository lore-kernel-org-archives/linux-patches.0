Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3B1A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tpszi3Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569A5C433C8;
	Mon,  9 Oct 2023 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858477;
	bh=YybSlvN+zxdRIp8rZ6xJA2mctISQH7pfuhcE9+vbSP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tpszi3VlEJ0tXV0qKwYZ2xOHlNvq08GkEwhdZi9BNZTgef8NhbMUOL27oWwbTQcRf
	 hB2MJkZvCySgbaXG6sl//E17z4LSp0ruyMcfBSkbjRDDGpcb31Xq2BqEYSUpYlEN7s
	 fu9KIDmhK9vF+GBtIHMrq7+CyXnL2dVf5bXwRD3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@canonical.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/131] modpost: add missing else to the "of" check
Date: Mon,  9 Oct 2023 15:02:28 +0200
Message-ID: <20231009130119.728253404@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@canonical.com>

[ Upstream commit cbc3d00cf88fda95dbcafee3b38655b7a8f2650a ]

Without this 'else' statement, an "usb" name goes into two handlers:
the first/previous 'if' statement _AND_ the for-loop over 'devtable',
but the latter is useless as it has no 'usb' device_id entry anyway.

Tested with allmodconfig before/after patch; no changes to *.mod.c:

    git checkout v6.6-rc3
    make -j$(nproc) allmodconfig
    make -j$(nproc) olddefconfig

    make -j$(nproc)
    find . -name '*.mod.c' | cpio -pd /tmp/before

    # apply patch

    make -j$(nproc)
    find . -name '*.mod.c' | cpio -pd /tmp/after

    diff -r /tmp/before/ /tmp/after/
    # no difference

Fixes: acbef7b76629 ("modpost: fix module autoloading for OF devices with generic compatible property")
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index c91eba751804b..8c0d1c191d557 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1455,7 +1455,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	/* First handle the "special" cases */
 	if (sym_is(name, namelen, "usb"))
 		do_usb_table(symval, sym->st_size, mod);
-	if (sym_is(name, namelen, "of"))
+	else if (sym_is(name, namelen, "of"))
 		do_of_table(symval, sym->st_size, mod);
 	else if (sym_is(name, namelen, "pnp"))
 		do_pnp_device_entry(symval, sym->st_size, mod);
-- 
2.40.1



