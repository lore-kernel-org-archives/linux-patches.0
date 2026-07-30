Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57ED4519BA;
	Thu, 30 Jul 2026 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428323; cv=none; b=mUolruAL1n6sRz37NmEDgoQmu/8UQBhsO+lt0yRYnex0nNWYNVrqWToujP1Y00no/Xm1rlMG3Pd6Js2JZWwdLyfmqwdBfgsCtCRvRHaTRhJrPapM9SDZpZVEUvuqbYANktd0knoViNi3nX6Y99rOYcgSk6Jz39ae2Qe1QPPRgPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428323; c=relaxed/simple;
	bh=vYkeAwCZ9DjnVnHCbDLz0SUXpfNEKO+Lk3lkN1Vfs2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWipG1ljuJq1lrQTwyEIkFhZ0nTXYoLrUwub1EA15OvXya8dWStPoTKzmoIskTuNH36V8W/eD78CDZI0lLMCS7YRioa9QZ9cimDlyzAVLJXNfwDQJM2pxyV0f1Gc4k/SD+uHliI9cMU9sij8ZLjhazbmdwBxqHVbxKkMWxGSLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do4VWfCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do4VWfCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99871F000E9;
	Thu, 30 Jul 2026 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428322;
	bh=1M8Ry8yChjn3NXD6HP4NzfdVvR0bFZxJB3Nphk/uiDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=do4VWfCIqpgcNgHahdZ7Ah+Tnw62wnDdZDJO/8gs8L6bcd/KlSOkWItT8tpngyiSq
	 G/iB+n8ob8eM4XP/9HVA4Ii5tAypk96t54EIJDo3tsC9K8eXA+TEyQvvRZEpti6iV/
	 leKpu3k5X2cYboWzBqHMX5EUl5V+z7UAIodGeoiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Mader <robert.mader@collabora.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 6.6 482/484] udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()
Date: Thu, 30 Jul 2026 16:16:19 +0200
Message-ID: <20260730141433.964694474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -155,21 +155,22 @@ static int begin_cpu_udmabuf(struct dma_
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


