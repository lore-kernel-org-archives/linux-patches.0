Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8252836D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvQ4ryRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0036BC433C7;
	Wed, 15 Nov 2023 19:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076672;
	bh=y/cxYkWNW6/gaYb9L8Xh/2MBJPNBg75N5P0F0gDCQyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvQ4ryRZ+MTWAelNV9OqWmQ9Yhs+JdR1almMxpEh1hjEfGPnsiumRnTx6C7IKOO8d
	 A5Nn+bgm7IFMiepk+OxPjefK6L/ZOZDxwYwf7FitPZs8BQ7+mrLRgUyDlLB/1hq5vh
	 TifpSSBNuOeft0XS2wugocc3gBgfHqr9uTtlW03M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 375/550] scripts/gdb: fix usage of MOD_TEXT not defined when CONFIG_MODULES=n
Date: Wed, 15 Nov 2023 14:15:59 -0500
Message-ID: <20231115191626.819591526@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 16501630bdeb107141a0139ddc33f92ab5582c6f ]

MOD_TEXT is only defined if CONFIG_MODULES=y which lead to loading failure
of the gdb scripts when kernel is built without CONFIG_MODULES=y:

Reading symbols from vmlinux...
Traceback (most recent call last):
  File "/foo/vmlinux-gdb.py", line 25, in <module>
    import linux.constants
  File "/foo/scripts/gdb/linux/constants.py", line 14, in <module>
    LX_MOD_TEXT = gdb.parse_and_eval("MOD_TEXT")
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
gdb.error: No symbol "MOD_TEXT" in current context.

Add a conditional check on CONFIG_MODULES to fix this error.

Link: https://lkml.kernel.org/r/20231031134848.119391-1-da.gomez@samsung.com
Fixes: b4aff7513df3 ("scripts/gdb: use mem instead of core_layout to get the module address")
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Tested-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/constants.py.in | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/gdb/linux/constants.py.in b/scripts/gdb/linux/constants.py.in
index fab74ca9df6fc..d16099a2b1c68 100644
--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -63,10 +63,11 @@ LX_GDBPARSED(IRQD_LEVEL)
 LX_GDBPARSED(IRQ_HIDDEN)
 
 /* linux/module.h */
-LX_GDBPARSED(MOD_TEXT)
-LX_GDBPARSED(MOD_DATA)
-LX_GDBPARSED(MOD_RODATA)
-LX_GDBPARSED(MOD_RO_AFTER_INIT)
+if IS_BUILTIN(CONFIG_MODULES):
+    LX_GDBPARSED(MOD_TEXT)
+    LX_GDBPARSED(MOD_DATA)
+    LX_GDBPARSED(MOD_RODATA)
+    LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
 LX_VALUE(MNT_NOSUID)
-- 
2.42.0



