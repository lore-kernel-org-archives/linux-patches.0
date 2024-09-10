Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DFF18C34B;
	Tue, 10 Sep 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965128; cv=none; b=p+AsLAeCnlx/etgyP3dE7WNrX4HI1zHunVaCd843qTxYO5WvL5hE7lm6xyYa0V1JAvkGqFCSehiH0U+ugIZTXz3/2rQjodungtOF+OS29mkWx17XKJwyGhFBmZza4Jrnkl72PJ1OVMBVLzN7g+/8mkKMmhCW7/dRxxC32qh10Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965128; c=relaxed/simple;
	bh=CuxxlbMrVXyqIuGfWoX0PN0cbZIp4KME5Qrt7mFz/gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXb62YUuKFw0slmfo08P0d5zSjJjebyiS/oGkM8V7cur6j0OdO94QHuvhzjtYhLIqO7Fv2MYiHsQWRpoUPtb5HGM3jn9Gv5AbwK0foBHCt+2/52+rHpBQXntjwz1QDiDnvIeZ9I+eFm/HNah2bRi+vL83HZ4G/Ir75iE3CVfP3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jejhuVh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jejhuVh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D99CC4CEC3;
	Tue, 10 Sep 2024 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965128;
	bh=CuxxlbMrVXyqIuGfWoX0PN0cbZIp4KME5Qrt7mFz/gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jejhuVh+ImtLquaCiOFR1qqqbc4HcibEh94diZe9nnUTpM8zvd9tDIFdFIr1RHWaf
	 BRtkfmx6rvGcnFbhW8W3zvlv47UZcwSWslLo0dEIebMw+34jK+h3gscXmf2Cz3FhxY
	 ZXGVlJH6zdXaSXtZULfJ7vuRMxDO6CSoaKmiexB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/186] kselftests: dmabuf-heaps: Ensure the driver name is null-terminated
Date: Tue, 10 Sep 2024 11:34:01 +0200
Message-ID: <20240910092600.605270948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 909da9cdda97..aa4be40f7d49 100644
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



