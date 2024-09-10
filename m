Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0280B18C00C;
	Tue, 10 Sep 2024 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963738; cv=none; b=btMTxNW/KS6Ri4v2mhn+6JXVhcGyCZCIff/aOv4Z0PtgP6LKTtiu29lYqi2p5rAJFNflzp8DH2q/92HyQA6th5gI/GD3dRwt+QRDNTtj3jtNL0cPNM7vXVirDFppG9DohawLW7tvxIRvsjl8BayY0EbM0R/0twddlR2oxLeSshI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963738; c=relaxed/simple;
	bh=/csc5sLJmTv/F4znLUR3SDnAjpsh26SudZIWwdJPRd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLHmPgXtnwlnx+LCW3xdrpMRxKdMY+8rHTDFDoqqHSTQPXDXMm+VwomKe8Iz++wdF8BUoihR+YacmDLmYBs0EWagt2MEneKswOXt8cXKVTnjoxAGY7YSo1P0kPowydK76SQI9sYyWVA5cZq/2tOfgQh/q5glvsXQ+uMZkGY0wig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+vyUZLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+vyUZLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F67C4CEC3;
	Tue, 10 Sep 2024 10:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963737;
	bh=/csc5sLJmTv/F4znLUR3SDnAjpsh26SudZIWwdJPRd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+vyUZLZ85TyY20oMkc6aGClY4CBwtYVOzfGp4oipiPkaAVOmwxz5dWhQCpuYJ9E4
	 DIFewIHQMC250ux8OKhh8kqVsqrcg03ICEY1LdhUURO8jUxtDNegE7HX+TA2F2QKEe
	 xlJNy7RpcQgBCiDZaFGQwQYBoO/PbsrNiy6fF9Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/214] kselftests: dmabuf-heaps: Ensure the driver name is null-terminated
Date: Tue, 10 Sep 2024 11:33:02 +0200
Message-ID: <20240910092605.241014132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit 291e4baf70019f17a81b7b47aeb186b27d222159 ]

Even if a vgem device is configured in, we will skip the import_vgem_fd()
test almost every time.

  TAP version 13
  1..11
  # Testing heap: system
  # =======================================
  # Testing allocation and importing:
  ok 1 # SKIP Could not open vgem -1

The problem is that we use the DRM_IOCTL_VERSION ioctl to query the driver
version information but leave the name field a non-null-terminated string.
Terminate it properly to actually test against the vgem device.

While at it, let's check the length of the driver name is exactly 4 bytes
and return early otherwise (in case there is a name like "vgemfoo" that
gets converted to "vgem\0" unexpectedly).

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20240729024604.2046-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
index 29af27acd40e..a0d3d2ed7a4a 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -29,9 +29,11 @@ static int check_vgem(int fd)
 	version.name = name;
 
 	ret = ioctl(fd, DRM_IOCTL_VERSION, &version);
-	if (ret)
+	if (ret || version.name_len != 4)
 		return 0;
 
+	name[4] = '\0';
+
 	return !strcmp(name, "vgem");
 }
 
-- 
2.43.0



