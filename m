Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED1213AA50;
	Tue, 27 Feb 2024 13:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041231; cv=none; b=mWX/ToYMY294CXzOls0GpKViSD/ZbG5WhXhrdBNV/mAymEPwLbt7+lf0OZpJ0EuCvpkR6DI2yneihYziY5IHTEjHzWZfGTRag9Q9i+Q7a4ETlEs5wWf7QQG7lbXNDRbyNBWyXGXFn5gPLExlzPMuRoyCiNkAZ+bTsk/LrVjfdzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041231; c=relaxed/simple;
	bh=DVvdC+0OYrpjWMCbLU3L3Pyvw602ykE7H+1Hi5slMDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7/VXo5y6jbhYjSYdiRakHoza/8lPrZBQzlDW+MiDQ6owQYxMradOrWmkWvoUDkXuHviC0Tc2b6N4FzQbwn9Nn4kUrnfXCANLaOHf7ivikvoYqLlyBzqX9WnyJznohDSbH37yhpK9CmEU+sIGm1m1OrctQeQ/wtSicOCvyejXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gO0aiQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gO0aiQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8DDC433C7;
	Tue, 27 Feb 2024 13:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041231;
	bh=DVvdC+0OYrpjWMCbLU3L3Pyvw602ykE7H+1Hi5slMDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gO0aiQnkKhG+gGIbRE06g9uCIr+l/sRaI8oENFKnhuBr6iFBNJttfIrTC257Yj0J
	 63+tR0CNCDAVHwhDDMG0HQcMETYD8W1idM4Y5Q3eMB4ztSmkX/bc3/3DQ+dCqYyLIQ
	 m9r/cpQnGgeHXIxfhnO7OwCjQePJiYLhvV8QDhDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 267/334] x86/numa: Fix the sort compare func used in numa_fill_memblks()
Date: Tue, 27 Feb 2024 14:22:05 +0100
Message-ID: <20240227131639.585023974@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit b626070ffc14acca5b87a2aa5f581db98617584c ]

The compare function used to sort memblks into starting address
order fails when the result of its u64 address subtraction gets
truncated to an int upon return.

The impact of the bad sort is that memblks will be filled out
incorrectly. Depending on the set of memblks, a user may see no
errors at all but still have a bad fill, or see messages reporting
a node overlap that leads to numa init failure:

[] node 0 [mem: ] overlaps with node 1 [mem: ]
[] No NUMA configuration found

Replace with a comparison that can only result in: 1, 0, -1.

Fixes: 8f012db27c95 ("x86/numa: Introduce numa_fill_memblks()")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/99dcb3ae87e04995e9f293f6158dc8fa0749a487.1705085543.git.alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index efc5f1be8d3af..9d63cfff1fd41 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -964,7 +964,7 @@ static int __init cmp_memblk(const void *a, const void *b)
 	const struct numa_memblk *ma = *(const struct numa_memblk **)a;
 	const struct numa_memblk *mb = *(const struct numa_memblk **)b;
 
-	return ma->start - mb->start;
+	return (ma->start > mb->start) - (ma->start < mb->start);
 }
 
 static struct numa_memblk *numa_memblk_list[NR_NODE_MEMBLKS] __initdata;
-- 
2.43.0



