Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190C51494B8;
	Mon, 12 Aug 2024 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480493; cv=none; b=Jy5qYz1WI/L4ys/eJMV3dhUEoUORY9WHRnRJ1KYf5xocfiO4iJpaagnGk16ibdTmKpvnC+Eho3wI5uKk7+w6rIfHXeLus5gOzdCJcAN/iB+97VrvtYCdy74PGrw6/6trm48Wd6UTHQc1Q77vVZhTetYwQ4PN3Zrc4J96ntdplvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480493; c=relaxed/simple;
	bh=i3fyZNZrq/RupFKDH8njZtYjpg7hBOrZ9LOY3xhOQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9DbLJgu7C/KqETTZYhBlOOt8T52hZx0n3ndBKMK485Wc1kIi6f+rHSwp/50pv1O7IuNzQ0IHxWT3KmXwNBkFzqmJ5MmhQKTE9+bO1IX2qaSwIQKAMo7NSJfKxAP9qdDl8SChZkKeA4JHUUR/hepTP4iwG3XKinvObKlQsdSSVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK7AOoTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK7AOoTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D2BC32782;
	Mon, 12 Aug 2024 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480493;
	bh=i3fyZNZrq/RupFKDH8njZtYjpg7hBOrZ9LOY3xhOQ0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK7AOoTXHIm6kU9Q3t8s92OeoaoRAvs57RVBujUQQrW8lAMH5GCw7Fv9Sc5fGR2sD
	 Mwwq08jV/iDB/YdsicxvrPfbzJ36oKG72GmwTmdhXA5sJL0GrydDNcv4xcKRbjef/H
	 eOwtLDGR00ozsDMn8GRXbybBp7K5K4iHzuYNh7pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: [PATCH 6.10 212/263] tty: vt: conmakehash: cope with abs_srctree no longer in env
Date: Mon, 12 Aug 2024 18:03:33 +0200
Message-ID: <20240812160154.661135002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Krummenacher <max.krummenacher@toradex.com>

commit 6e20753da6bc651e02378a0cdb78f16c42098c88 upstream.

conmakehash uses getenv("abs_srctree") from the environment to strip
the absolute path from the generated sources.
However since commit e2bad142bb3d ("kbuild: unexport abs_srctree and
abs_objtree") this environment variable no longer gets set.
Instead use basename() to indicate the used file in a comment of the
generated source file.

Fixes: 3bd85c6c97b2 ("tty: vt: conmakehash: Don't mention the full path of the input in output")
Cc: stable <stable@kernel.org>
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Link: https://lore.kernel.org/stable/20240725132056.9151-1-max.oss.09%40gmail.com
Link: https://lore.kernel.org/r/20240725132056.9151-1-max.oss.09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/conmakehash.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/vt/conmakehash.c b/drivers/tty/vt/conmakehash.c
index dc2177fec715..82d9db68b2ce 100644
--- a/drivers/tty/vt/conmakehash.c
+++ b/drivers/tty/vt/conmakehash.c
@@ -11,6 +11,8 @@
  * Copyright (C) 1995-1997 H. Peter Anvin
  */
 
+#include <libgen.h>
+#include <linux/limits.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sysexits.h>
@@ -76,8 +78,8 @@ static void addpair(int fp, int un)
 int main(int argc, char *argv[])
 {
   FILE *ctbl;
-  const char *tblname, *rel_tblname;
-  const char *abs_srctree;
+  const char *tblname;
+  char base_tblname[PATH_MAX];
   char buffer[65536];
   int fontlen;
   int i, nuni, nent;
@@ -102,16 +104,6 @@ int main(int argc, char *argv[])
 	}
     }
 
-  abs_srctree = getenv("abs_srctree");
-  if (abs_srctree && !strncmp(abs_srctree, tblname, strlen(abs_srctree)))
-    {
-      rel_tblname = tblname + strlen(abs_srctree);
-      while (*rel_tblname == '/')
-	++rel_tblname;
-    }
-  else
-    rel_tblname = tblname;
-
   /* For now we assume the default font is always 256 characters. */
   fontlen = 256;
 
@@ -253,6 +245,8 @@ int main(int argc, char *argv[])
   for ( i = 0 ; i < fontlen ; i++ )
     nuni += unicount[i];
 
+  strncpy(base_tblname, tblname, PATH_MAX);
+  base_tblname[PATH_MAX - 1] = 0;
   printf("\
 /*\n\
  * Do not edit this file; it was automatically generated by\n\
@@ -264,7 +258,7 @@ int main(int argc, char *argv[])
 #include <linux/types.h>\n\
 \n\
 u8 dfont_unicount[%d] = \n\
-{\n\t", rel_tblname, fontlen);
+{\n\t", basename(base_tblname), fontlen);
 
   for ( i = 0 ; i < fontlen ; i++ )
     {
-- 
2.46.0



