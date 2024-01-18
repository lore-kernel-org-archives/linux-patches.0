Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0D01774B;
	Thu, 18 Jan 2024 10:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575488; cv=none; b=R+CuGX8SFP+zBB2uRgErrNbMwHEF2cyG+TcK+ZXQPePdlhotdvECmVP/y8Nm0usMw2KJxVf44/TdddNSIKFucO+HCCAgIazNeX5IWES9+g2vK3XZVLd0+QQGbtA7RAhMW4hT4vmmMwbOQFU3pw0BV2vfYabpgx2aiww8q3B3ifE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575488; c=relaxed/simple;
	bh=9TWK2t7WlGOSx4FX18jBWiAZksclzLbgeyWtQdasJN4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=EMQQBrKItLQ+mYg/tnvZ4NrMi9/9CVvmnZJnjHhMaf9a8e9gsD3rJ/HqYZk7kaQ6s4m2qR2UT2VvFix15HHbQHEjskVLdhJ9bCop2KXXY3FsvPUeG2VmIna6q2ll5fT9BscyqghTar2Deuk5FiSu0Ejsuj1MSK6x075wLvJQo00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZoACzrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZoACzrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD86AC433C7;
	Thu, 18 Jan 2024 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575488;
	bh=9TWK2t7WlGOSx4FX18jBWiAZksclzLbgeyWtQdasJN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZoACzrnqgxBJGvwlzfIZKL9fMi5ABl5UTYAfSmlVsS0Qyn763X4dVPSPP7ln/Spw
	 f8nL7PKGMq29Uk08zCBVYhASpj6mzA2O0n/QRMwciebonwZOq/8qKHsBePaCIoGVni
	 ON8c2m/3KwuVgYKJepjMXwGjedPYeaT9IJdwJtuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 150/150] mm/memory_hotplug: fix memmap_on_memory sysfs value retrieval
Date: Thu, 18 Jan 2024 11:49:32 +0100
Message-ID: <20240118104327.005303427@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 11684134140bb708b6e6de969a060535630b1b53 upstream.

set_memmap_mode() stores the kernel parameter memmap mode as an integer.
However, the get_memmap_mode() function utilizes param_get_bool() to fetch
the value as a boolean, leading to potential endianness issue.  On
Big-endian architectures, the memmap_on_memory is consistently displayed
as 'N' regardless of its actual status.

To address this endianness problem, the solution involves obtaining the
mode as an integer.  This adjustment ensures the proper display of the
memmap_on_memory parameter, presenting it as one of the following options:
Force, Y, or N.

Link: https://lkml.kernel.org/r/20240110140127.241451-1-sumanthk@linux.ibm.com
Fixes: 2d1f649c7c08 ("mm/memory_hotplug: support memmap_on_memory when memmap is not aligned to pageblocks")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Suggested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b3c0ff52bb72..21890994c1d3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -101,9 +101,11 @@ static int set_memmap_mode(const char *val, const struct kernel_param *kp)
 
 static int get_memmap_mode(char *buffer, const struct kernel_param *kp)
 {
-	if (*((int *)kp->arg) == MEMMAP_ON_MEMORY_FORCE)
-		return sprintf(buffer,  "force\n");
-	return param_get_bool(buffer, kp);
+	int mode = *((int *)kp->arg);
+
+	if (mode == MEMMAP_ON_MEMORY_FORCE)
+		return sprintf(buffer, "force\n");
+	return sprintf(buffer, "%c\n", mode ? 'Y' : 'N');
 }
 
 static const struct kernel_param_ops memmap_mode_ops = {
-- 
2.43.0



