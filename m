Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1990951814A;
	Thu, 17 Sep 2026 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667001; cv=none; b=XLuqN367x/omYO+4Nmm/HYx71PkPFgROzszx/lXswqb/LL2v8hEJGr+XbalmRvq16QGvE+YivZJ/QGdUq4zXR5+gVVfwTymijiP9SWqWp/DyJWUxzoxCvsEqsQsPJlHjNMvzP7x45vxHtATIggMeVJDcD9sIDOykJp2FMYEgTJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667001; c=relaxed/simple;
	bh=uldryTEtVyYfH8h3e14LK9EVGlpVCXT7M+zWJjlSLy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzUZMP2wrr13fdcb1DTNzPqakWOmCN8CSP178pi+D3S9n+rFKfzO9uy43LsNW6fZRHvbF+2D1HuQDwUUVkHZtu4MgIdu13aIconJcvmsEsx4542SC79wEFEVD4pFqmndgWyjCYfgzA7MvL+YAQ51R2kShkLph5LHoMHOFxVo35w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJUAt9mt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJUAt9mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215D1F000FF;
	Thu, 17 Sep 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667000;
	bh=Tq6ptWUeTCMUxrWTHZvkHlJPWQAMr79iBiHdEiLwXhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJUAt9mtKwIa/DBiyhlF0V/fZJ5Coe3LjQSxxUgBMCPqofzhvJqv6HVUJ1CuRyzAK
	 0jg03URMx9Q4uDrayyHbjf2IUfSXEejIrfbi8j5y7ZtFPbm41TprwUb1idBIiPO0yz
	 SVAPBP1I5mCwAMmXAmkp6VzNF9WZWRJ+Ht7BVU+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1196/1250] init/main: read bootconfig header with get_unaligned_le32()
Date: Thu, 17 Sep 2026 16:16:31 +0100
Message-ID: <20260917151624.704183017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 499f86de4f8c34e19a57daf2b6f0cba848e91994 ]

get_boot_config_from_initrd() scans up to 3 bytes before initrd_end to
handle GRUB 4-byte alignment.  As a result, the bootconfig header
immediately preceding the magic may be unaligned.

Read the size and checksum fields with get_unaligned_le32() instead of
casting to u32 * and using le32_to_cpu(), avoiding potential unaligned
access and silencing sparse "cast to restricted __le32" warnings.

Sparse warnings (gcc + C=1):
  init/main.c:292:16: warning: cast to restricted __le32
  init/main.c:293:16: warning: cast to restricted __le32

No functional change intended.

Link: https://lkml.kernel.org/r/20260113101532.1630770-1-sun.jian.kdev@gmail.com
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7812d6dab069 ("bootconfig: Fix integer overflow in initrd size check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,7 @@
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
+#include <linux/unaligned.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -269,7 +270,7 @@ static void * __init get_boot_config_fro
 {
 	u32 size, csum;
 	char *data;
-	u32 *hdr;
+	u8 *hdr;
 	int i;
 
 	if (!initrd_end)
@@ -288,9 +289,9 @@ static void * __init get_boot_config_fro
 	return NULL;
 
 found:
-	hdr = (u32 *)(data - 8);
-	size = le32_to_cpu(hdr[0]);
-	csum = le32_to_cpu(hdr[1]);
+	hdr = (u8 *)(data - 8);
+	size = get_unaligned_le32(hdr);
+	csum = get_unaligned_le32(hdr + 4);
 
 	data = ((void *)hdr) - size;
 	if ((unsigned long)data < initrd_start) {


