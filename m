Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639011442F3;
	Thu, 13 Jun 2024 11:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279260; cv=none; b=ge/lFCACwFfIl7q/Sc64VQu5xdFwjzfGoSwQfrzsV2u54bvVJD3Ypl2Hjd6YSJuXLn1tuw8DV22aNmprDi64K2NaYVAuEVCwxPaS4s2vdvqKssvRgeGjBHf/DoYJWc+b5EZhzyo8EMX6I1B+SbukZBc914l+4UtWyds6TFrgpMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279260; c=relaxed/simple;
	bh=lGigOKJNpWeSlxN+G2lgUWht1lawuhF7+H0tRVvmf6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAcVFhA1ySrcHIfclS0XH53yXqxTxN3FoNI6PrKWEx9Lht0eB6y3hXq6MPs7OM/hb+hHkGoDLU9c5qK9SAj7ISBThAEB5Op+2GDRg3P043eJLb/AniTnUky21tHsLO5wBbLJowTnocjeHajX0N1mANzRE4+fBVJnrnmeb/hpSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHhGGidf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHhGGidf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ACAC2BBFC;
	Thu, 13 Jun 2024 11:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279260;
	bh=lGigOKJNpWeSlxN+G2lgUWht1lawuhF7+H0tRVvmf6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHhGGidfgjo5ONRLOLwYnc7C+QM/ZUlxA9JhM6eNKLNzghkY86hlOPl3QoOYnUDnN
	 ECUtQniHzYJwnVAVVLb5d7c/8HIF1LNOIk3oZvFB42TEATPCFP+hLHZZgajDJiweJk
	 7rJn7d3d/heWi3mrD/x8YD1PJVNatz6mh4rokuhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Joel Granados <j.granados@samsung.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.9 016/157] fsverity: use register_sysctl_init() to avoid kmemleak warning
Date: Thu, 13 Jun 2024 13:32:21 +0200
Message-ID: <20240613113228.035056012@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit ee5814dddefbaa181cb247a75676dd5103775db1 upstream.

Since the fsverity sysctl registration runs as a builtin initcall, there
is no corresponding sysctl deregistration and the resulting struct
ctl_table_header is not used.  This can cause a kmemleak warning just
after the system boots up.  (A pointer to the ctl_table_header is stored
in the fsverity_sysctl_header static variable, which kmemleak should
detect; however, the compiler can optimize out that variable.)  Avoid
the kmemleak warning by using register_sysctl_init() which is intended
for use by builtin initcalls and uses kmemleak_not_leak().

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/r/CAHj4cs8DTSvR698UE040rs_pX1k-WVe7aR6N2OoXXuhXJPDC-w@mail.gmail.com
Cc: stable@vger.kernel.org
Reviewed-by: Joel Granados <j.granados@samsung.com>
Link: https://lore.kernel.org/r/20240501025331.594183-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/init.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -10,8 +10,6 @@
 #include <linux/ratelimit.h>
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_table_header *fsverity_sysctl_header;
-
 static struct ctl_table fsverity_sysctl_table[] = {
 #ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
 	{
@@ -28,10 +26,7 @@ static struct ctl_table fsverity_sysctl_
 
 static void __init fsverity_init_sysctl(void)
 {
-	fsverity_sysctl_header = register_sysctl("fs/verity",
-						 fsverity_sysctl_table);
-	if (!fsverity_sysctl_header)
-		panic("fsverity sysctl registration failed");
+	register_sysctl_init("fs/verity", fsverity_sysctl_table);
 }
 #else /* CONFIG_SYSCTL */
 static inline void fsverity_init_sysctl(void)


