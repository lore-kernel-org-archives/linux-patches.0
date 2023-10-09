Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F07199B1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbYvtDI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C06C433C7;
	Mon,  9 Oct 2023 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857944;
	bh=10q0OLJq49Zspt/0GQBudOTwjHLz+wjgVQuFfLO7obs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbYvtDI7nb74MOVmfoUwXBHIr49IRKwR7CMxfprWsnUHkafEY5p3QmH8UZu6JGqLm
	 q5Y81xBX8mM/N95Dz7nwrvHE0WZT/cRPOS5OTxM+uGQS+ifcsFgJXzQJSS3oXGV8Ft
	 rMhGfY+bT3otQ9BDArZa8Ussavd6n66ziOcGDThw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@canonical.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/75] modpost: add missing else to the "of" check
Date: Mon,  9 Oct 2023 15:02:05 +0200
Message-ID: <20231009130112.741365066@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 49aba862073e0..05089ef5cc0ec 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1547,7 +1547,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
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



