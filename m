Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8155C35B137;
	Thu, 30 Jul 2026 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425484; cv=none; b=OP7ZM/Ri81S+UE7aJjNvkGFn8bdM8ZenGsaMk6Zf3MO0cFpfAYrSE3eavPBVI1PNWvC/gbOjUSvmsVkRMlO/g4r4M9P+bizT2ONtnL2EuljG+1sGDn9SBm52gUOsToexOmalBVSUTsZ81URulTdbVo352oZyBQIhfNq9F7lU6tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425484; c=relaxed/simple;
	bh=g+VC1sdV00Iyye/X4A55KHxt7XcjmsINUMt9znvlVZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItVMFhOHLQj/kABjyDZciAuwUbYM8+7AEDZDt+WyxH7b4SP8Uym9lYpUAdWdVmHMSeTooem8i+z5dme4y96qr1C+V4RfcNlhJnH1WmNaP7RVOxRITIlx73kmmWQPsHpl6fdNCWNJBK77P6jkle6SO0uHX4OIa94kqAMvCC+xgSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y770HKoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y770HKoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F501F000E9;
	Thu, 30 Jul 2026 15:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425483;
	bh=W3A6tkEl7z7rwznsAgMb1RgBvPF7EW8y7Ibz/cB6PPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y770HKoJXjgLOMSKatelOFum93VnxU+FPJ3JQNX5jgxDse6qMa/ijKZXZ62hSZDYF
	 nO4e0MAR+thV58bXmNNbHPUa03q4kD0iJ1PYnhrmNYoOjNb3fwdU4dfzV34+5pJZBM
	 XRC27a0vHBLbFdPep8JxrBBSYtmo2rlKFQQiI5do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Mader <robert.mader@collabora.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/602] udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()
Date: Thu, 30 Jul 2026 16:07:55 +0200
Message-ID: <20260730141437.741557201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Mader <robert.mader@collabora.com>

[ Upstream commit 1d0e25c1ddf2063c499264fb2ba0fa6a3e4f8a00 ]

The message of commit 504e2b4ab97a ("dma-buf/udmabuf: skip redundant cpu sync to
fix cacheline EEXIST warning") says:

> The CPU sync at map/unmap time is also redundant for udmabuf:
> begin_cpu_udmabuf() and end_cpu_udmabuf() already perform explicit
> cache synchronization via dma_sync_sgtable_for_cpu/device() when CPU
> access is requested through the dma-buf interface.

This, however, does not apply to the first time begin_cpu_udmabuf() is
called on an udmabuf, in which case the implementation previously relied on
get_sg_table() to perform the cache synchronisation.

Ensure to call dma_sync_sgtable_for_cpu() in that case as well.

Fixes: 504e2b4ab97a ("dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning")
Signed-off-by: Robert Mader <robert.mader@collabora.com>
Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/20260627105725.9083-1-robert.mader@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 5c92834f3fc86d..b81fd91e30e777 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -207,21 +207,22 @@ static int begin_cpu_udmabuf(struct dma_buf *buf,
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct device *dev = ubuf->device->this_device;
-	int ret = 0;
 
 	if (!ubuf->sg) {
 		ubuf->sg = get_sg_table(dev, buf, direction);
 		if (IS_ERR(ubuf->sg)) {
+			int ret;
+
 			ret = PTR_ERR(ubuf->sg);
 			ubuf->sg = NULL;
+			return ret;
 		} else {
 			ubuf->sg_dir = direction;
 		}
-	} else {
-		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);
 	}
 
-	return ret;
+	dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);
+	return 0;
 }
 
 static int end_cpu_udmabuf(struct dma_buf *buf,
-- 
2.53.0



