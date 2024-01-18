Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E951D55A;
	Thu, 18 Jan 2024 10:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575065; cv=none; b=bBwdul76ImeJm1nR6CrgS7NRhywzq+UWIsFt/SWcwXqPJIbXv/udpH5FVa5LY/oPetj2vw3hWqWS1fFbRxGJmfiVYF7cUSViJ7V1LVCYpP8FU58Ouk15EiZP78h3rCZ8VOzf9TeBDzg3ddh7nGEmyFlI3T+EgI2U2CzR4sxDNwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575065; c=relaxed/simple;
	bh=b9OJ9fAcqOKrB/GeXBHqUzA9HBk0xGoLEkT2mRNCmUA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=oupgJXYYVtZz/1G3d1nvEdEsGBS1+T1hf1rNa6y4aT+nKLRi1Pd9UrsL++PTgdgax3/Jd5z1QLd+IF1uYH+H/CFW+uJPLuAu5/8br9OM3jb2CcOEuVpaX42r2CuMfYXcaVpao2tNYz6HOl9SnojIO0xlg6VYTGOeAEutvaqoyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6vI4R+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6vI4R+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DDBC433F1;
	Thu, 18 Jan 2024 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575065;
	bh=b9OJ9fAcqOKrB/GeXBHqUzA9HBk0xGoLEkT2mRNCmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6vI4R+ojzUc4QUfJ+JIPT4lEvx0DSs0BNodbtrFsQtSmnqFmYHdwpeXSQP6N5p7P
	 tm+9iUVvGSs6GR+9rJZpQDORFnJ351Sk4vZcRnPPr9AJAQQ35BAbUG+nVYpfWndBdC
	 WvFntWnszMhiQxFb0fnHv8vSRqPQnlWGqKFME/F8=
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
Subject: [PATCH 6.7 28/28] mm/memory_hotplug: fix memmap_on_memory sysfs value retrieval
Date: Thu, 18 Jan 2024 11:49:18 +0100
Message-ID: <20240118104302.177463352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 mm/memory_hotplug.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -101,9 +101,11 @@ static int set_memmap_mode(const char *v
 
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


