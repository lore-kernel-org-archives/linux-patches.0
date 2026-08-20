Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BDD46D0BD;
	Thu, 20 Aug 2026 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243944; cv=none; b=VCiyC5lnnMDhTE06sYUTapFUw7fOBsrJfrYrgM1Q59NwO9K82IndRh3qztcME+ywUx+P2rcg5HVh9SpltXvt7g7WSS4GZHhW3DwV5ZuJne/oXM132HYTZ+E9/oK0fDurED+HPjkop951cOghUJ//z9AvgIBc/Ke43AcRlKuwAyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243944; c=relaxed/simple;
	bh=uYVn3vzTa/UD5fJupGlSmT5/ZykmD7jNH9CMH4BbiGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6UndrkWCaX1I8+tWGxns6wy/Jgpb427mNlDIBsFWLh3YnF1WHNk6pVnL6CM6b+DSgxs0abd4S30zutJHA7QykU1ntYf37Rkz4pTQy8wckVPrgGWuPbWepsI/Yxw6O1LnR7erAztnCEUg6imWCypda2+3t0vC/St5qJUVrK0N5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zELTVzl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zELTVzl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9CC1F000E9;
	Thu, 20 Aug 2026 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243943;
	bh=jPcs/fzEVau1N90exqihj2KxjfMuhpVFzcidNLlzT7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zELTVzl90ZnqmuFOIXQ7/dKVSO/ssp5Plt4rDMBm+0MMN0Wl+rsaVNVZGBmxNEF/6
	 6mPFYEOM/3TnE8riQAiH9S6M/8pW62f7OemSHcyPuJFz8iEf4B5IBAEAVXaUOHHnhb
	 xFEy3KRgyeYClUDJVmWPjQtjEJySeHRdDkUCBdXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Mader <robert.mader@collabora.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 5.15 269/272] udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()
Date: Thu, 20 Aug 2026 16:57:33 +0200
Message-ID: <20260820145239.704918624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Mader <robert.mader@collabora.com>

commit 1d0e25c1ddf2063c499264fb2ba0fa6a3e4f8a00 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -127,21 +127,22 @@ static int begin_cpu_udmabuf(struct dma_
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


