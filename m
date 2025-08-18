Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E7C31E0FE;
	Mon, 18 Aug 2025 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525852; cv=none; b=JyAf569WZnv5PGJj4QQ+b02zzqJ872YLs/Qf7wvYHHfu+rLcHNY0VWobjz/c7M/JDVrbQ/VnCB0sWgHI97rgEED4u/sRpoFh+vLFCSug3tvMlLMZPniTaFHTZfLwEwM0co+K6W6atEOq+gAUC5L3RgooFhO5JBzBzMsahj9cHUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525852; c=relaxed/simple;
	bh=xXTmZA1mwAAT72wGJenz4MbHh2aBaUw0jklN2jDWSGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naE6cScqil/AYHKVjMn/BYnqI89gT1N1DHNRcthnaxbaYEwBW4Y9sBtY2bisQ1ycjvjZcmglXmWLgpxdtTL2Hch6u5A1jL0x5vjBDIOCpbOh2w03XSKULNUsmhlTo+ujrUEJxzlidPZIyrcGWcFqjf1JpxyI8TG3zJVV+OimAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK3xbkgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK3xbkgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49B2C4CEEB;
	Mon, 18 Aug 2025 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525852;
	bh=xXTmZA1mwAAT72wGJenz4MbHh2aBaUw0jklN2jDWSGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK3xbkgxdWGLiU/ZXBOelrir9CTduQa392ZjTqb0x4v/fwh61GTtHhwAz6m+7TrZV
	 sIwoInua7RC+vavZW1KxpFhZreF5LOQoivPKEousw7vTiD//n/qdw7fj/lYL0jJ5gO
	 JHJdDrQ/jnwGSd1BHybDk/B3eeB9PYSMkz1y5yXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 386/570] MIPS: lantiq: falcon: sysctrl: fix request memory check logic
Date: Mon, 18 Aug 2025 14:46:13 +0200
Message-ID: <20250818124520.715943434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 9c9a7ff9882fc6ba7d2f4050697e8bb80383e8dc ]

request_mem_region() will return NULL instead of error code
when the memory request fails. Therefore, we should check if
the return value is non-zero instead of less than zero. In
this way, this patch also fixes the build warnings:

arch/mips/lantiq/falcon/sysctrl.c:214:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  214 |                                 res_status.name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:216:47: error: ordered comparison of pointer with integer zero [-Werror=extra]
  216 |                                 res_ebu.name) < 0) ||
      |                                               ^
arch/mips/lantiq/falcon/sysctrl.c:219:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  219 |                                 res_sys[0].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:222:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  222 |                                 res_sys[1].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:225:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  225 |                                 res_sys[2].name) < 0))
      |

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/falcon/sysctrl.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 1187729d8cbb..357543996ee6 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -214,19 +214,16 @@ void __init ltq_soc_init(void)
 	of_node_put(np_syseth);
 	of_node_put(np_sysgpe);
 
-	if ((request_mem_region(res_status.start, resource_size(&res_status),
-				res_status.name) < 0) ||
-		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
-				res_ebu.name) < 0) ||
-		(request_mem_region(res_sys[0].start,
-				resource_size(&res_sys[0]),
-				res_sys[0].name) < 0) ||
-		(request_mem_region(res_sys[1].start,
-				resource_size(&res_sys[1]),
-				res_sys[1].name) < 0) ||
-		(request_mem_region(res_sys[2].start,
-				resource_size(&res_sys[2]),
-				res_sys[2].name) < 0))
+	if ((!request_mem_region(res_status.start, resource_size(&res_status),
+				 res_status.name)) ||
+	    (!request_mem_region(res_ebu.start, resource_size(&res_ebu),
+				 res_ebu.name)) ||
+	    (!request_mem_region(res_sys[0].start, resource_size(&res_sys[0]),
+				 res_sys[0].name)) ||
+	    (!request_mem_region(res_sys[1].start, resource_size(&res_sys[1]),
+				 res_sys[1].name)) ||
+	    (!request_mem_region(res_sys[2].start, resource_size(&res_sys[2]),
+				 res_sys[2].name)))
 		pr_err("Failed to request core resources");
 
 	status_membase = ioremap(res_status.start,
-- 
2.39.5



