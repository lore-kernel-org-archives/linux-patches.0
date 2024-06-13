Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175C5146D68;
	Thu, 13 Jun 2024 12:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280347; cv=none; b=BEfzFFqU3YIs4sdjs9OYIDpXiwYjgelRa5eTbjk5Ka9aZwYdOOpIeIR9oDH9TU/wrho/StsriWNz6DkGd4cI2kKkPPAlO3s4hmxDLGtHrrOYa34kAOK8L6fTiPSfHXAU1tlvDPfD1xXBb2ZKHy+0ePYVp03HK3qcTYw3NWJmCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280347; c=relaxed/simple;
	bh=rL7ZoQKSaJyvtQF6WTJQmZg3F9J3/5PQuISYk4cMTOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMhezt41Equ/T1jY6nZtQPBYADiQBseT3Akw4DWOo732PSBRYEsdg+UPwNYg6U8gwQ/HjCRgLKc1CNme342yK6a/Fcn5cUtmEOaqJkLEl6ESu1odCzX8IgNx9x1Q9WCo3C5gTzgO8ClEIMn1zegUjwLt3UlQqiCLPFeXiyZW3/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMBZVcME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMBZVcME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95481C2BBFC;
	Thu, 13 Jun 2024 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280347;
	bh=rL7ZoQKSaJyvtQF6WTJQmZg3F9J3/5PQuISYk4cMTOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMBZVcME1aVmWQi1J/NJriLBl6bh6UJD489eHEU6EusQyV5LYPQSEkSgsYSz+T+ga
	 hiuJeN4crSnqWiYLE7iR3zdyqquPQj1PgToyC/4eMGE3d6RTJU8NEYXGnAofGWLjC5
	 VsXmCw52c8aDMIKLnzQ2ekPhBDVanlE149gylYRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Joel Granados <j.granados@samsung.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.6 023/137] fsverity: use register_sysctl_init() to avoid kmemleak warning
Date: Thu, 13 Jun 2024 13:33:23 +0200
Message-ID: <20240613113224.187156461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -29,10 +27,7 @@ static struct ctl_table fsverity_sysctl_
 
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


