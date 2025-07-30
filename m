Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A45736124;
	Wed, 30 Jul 2025 09:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868359; cv=none; b=HJf890XHAMz2+xjAZFXqEZwiu/eoOTUMO4Y6ZOnNhAnkeVfYH4//n9bePl/PdQ7tCzjiDx+bQDa9o3uHJXVzUEsNjdNV5mOHpJw0KsYBBTeB8CtG4AdR6va69q+LefDYzH1TKWck2M8DlW1m0GWMMMDsiccmfdlYGWLV5u0AQF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868359; c=relaxed/simple;
	bh=iSwIzpEcsrNstMnNt7ntw4egc4WjfC3uZI1B3kZNcGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK6cbkapruFg+wh/je9XUrlPIJlUWC5Y94Bx8xc08ZJ7BXUgHyG6leepzg3FNaLJXtlWH4/YonHKhCBxpLpOnFK6likGorRX9kEpC192Uu4RC6a4s4VfI4LSNIlujxUUjn2lvtlpCX5GhNJE47TG4qPoB8Ux+kxZwCmB+a0JY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR8C/09k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR8C/09k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48DFC4CEE7;
	Wed, 30 Jul 2025 09:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868359;
	bh=iSwIzpEcsrNstMnNt7ntw4egc4WjfC3uZI1B3kZNcGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR8C/09kSh+TOZdrsG+hb4Yc3Jj00Rpmixo6Lqqn9EiXeVMY3EBvHBrS0JwFyn/Ps
	 RkPKIwbS+ykszP8HkSLnBODlG+OkxdIo0002zju+f68oLTkfN9fB+nBTMd2D0higFu
	 Uu+1LeOGUgQJZhqqurruGBQdxsesHYs9RTnOM8nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 44/76] resource: fix false warning in __request_region()
Date: Wed, 30 Jul 2025 11:35:37 +0200
Message-ID: <20250730093228.543493516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

commit 91a229bb7ba86b2592c3f18c54b7b2c5e6fe0f95 upstream.

A warning is raised when __request_region() detects a conflict with a
resource whose resource.desc is IORES_DESC_DEVICE_PRIVATE_MEMORY.

But this warning is only valid for iomem_resources.
The hmem device resource uses resource.desc as the numa node id, which can
cause spurious warnings.

This warning appeared on a machine with multiple cxl memory expanders.
One of the NUMA node id is 6, which is the same as the value of
IORES_DESC_DEVICE_PRIVATE_MEMORY.

In this environment it was just a spurious warning, but when I saw the
warning I suspected a real problem so it's better to fix it.

This change fixes this by restricting the warning to only iomem_resource.
This also adds a missing new line to the warning message.

Link: https://lkml.kernel.org/r/20250719112604.25500-1-akinobu.mita@gmail.com
Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1222,8 +1222,9 @@ static int __request_region_locked(struc
 		 * become unavailable to other users.  Conflicts are
 		 * not expected.  Warn to aid debugging if encountered.
 		 */
-		if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-			pr_warn("Unaddressable device %s %pR conflicts with %pR",
+		if (parent == &iomem_resource &&
+		    conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
+			pr_warn("Unaddressable device %s %pR conflicts with %pR\n",
 				conflict->name, conflict, res);
 		}
 		if (conflict != parent) {


