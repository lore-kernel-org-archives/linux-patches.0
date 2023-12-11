Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1F4437B;
	Mon, 11 Dec 2023 18:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBhzjIOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995F8C433C8;
	Mon, 11 Dec 2023 18:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320362;
	bh=hi20+JEWc9ZDhVOgpNSHeuUop+7QkFPMRCkSInLBHwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBhzjIOP5zOuUwt3Qmp8zYiM8j4+QWGRSoRP0ZeCi24MK0jeFWQ8s+XJ/25uSIOAD
	 qteryltEkiyN0JlOcG9qGgYJs168CEulp4Dlx9DmJFsU6tXrLr7Cr+NzxfUnLBQR9+
	 Kv6wevnl4dIp7FA1/KCnx0hpRxNHwJLrIlghWzJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/194] dt: dt-extract-compatibles: Dont follow symlinks when walking tree
Date: Mon, 11 Dec 2023 19:20:06 +0100
Message-ID: <20231211182037.335081830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 8f51593cdcab82fb23ef2e1a0010b2e6f99aae02 ]

The iglob function, which we use to find C source files in the kernel
tree, always follows symbolic links. This can cause unintentional
recursions whenever a symbolic link points to a parent directory. A
common scenario is building the kernel with the output set to a
directory inside the kernel tree, which will contain such a symlink.

Instead of using the iglob function, use os.walk to traverse the
directory tree, which by default doesn't follow symbolic links. fnmatch
is then used to match the glob on the filename, as well as ignore hidden
files (which were ignored by default with iglob).

This approach runs just as fast as using iglob.

Fixes: b6acf8073517 ("dt: Add a check for undocumented compatible strings in kernel")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Closes: https://lore.kernel.org/all/e90cb52f-d55b-d3ba-3933-6cc7b43fcfbc@arm.com
Signed-off-by: "Nícolas F. R. A. Prado" <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20231107225624.9811-1-nfraprado@collabora.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/dt-extract-compatibles | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/scripts/dtc/dt-extract-compatibles b/scripts/dtc/dt-extract-compatibles
index 05c47e3d8c00e..9686a1cf85498 100755
--- a/scripts/dtc/dt-extract-compatibles
+++ b/scripts/dtc/dt-extract-compatibles
@@ -1,8 +1,8 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0-only
 
+import fnmatch
 import os
-import glob
 import re
 import argparse
 
@@ -49,10 +49,20 @@ def print_compat(filename, compatibles):
 	else:
 		print(*compatibles, sep='\n')
 
+def glob_without_symlinks(root, glob):
+	for path, dirs, files in os.walk(root):
+		# Ignore hidden directories
+		for d in dirs:
+			if fnmatch.fnmatch(d, ".*"):
+				dirs.remove(d)
+		for f in files:
+			if fnmatch.fnmatch(f, glob):
+				yield os.path.join(path, f)
+
 def files_to_parse(path_args):
 	for f in path_args:
 		if os.path.isdir(f):
-			for filename in glob.iglob(f + "/**/*.c", recursive=True):
+			for filename in glob_without_symlinks(f, "*.c"):
 				yield filename
 		else:
 			yield f
-- 
2.42.0



