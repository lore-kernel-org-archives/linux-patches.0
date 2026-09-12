Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1374480357;
	Sat, 12 Sep 2026 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218300; cv=none; b=kbXOe7Ks8kfVkbuwD7zTX7TnuPZ6ZVw+0LeiQJPGzARykRZU7g+GolW+Gif7UjFFxFiOVGmeS3+ValPlq6cu9FRWA0AKCbaO0EUcnvfmfD4MVeu8DcWCWgj7JLAUN1JyA+HzSX3223VL7VThACIwUIpixQccGagihxi9FyxEE8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218300; c=relaxed/simple;
	bh=h9tZVcMPGbPaFn3Tt+nZQuGWkRtuE3HnLAyMdrA/Ir4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKg6H7Bm3jb3FQqARoCZ/MER216pHbfcXCOb12DNTS04HXByOhyuzBRGxonMdZRUkA49DUirmH6u9eC/f8svRVOngArzlLMUX8WiDgSOgy7lY7Fe9gQk1EPgAcVugb61Gvri1xhR8u3doALbLzZueXgjPSVAF4SHyQELyx/D16E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByBebY1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByBebY1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695B11F000FF;
	Sat, 12 Sep 2026 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218298;
	bh=2DFc7Bxv0wWDAo37QWqDrVTn6P+8OfX/euAUMBRS92w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByBebY1y4o09aJQ7KGZW8/BWRtJ9OE9KM0Chq9U2oVs7vbpo3HBfHURhZjQEaAhqS
	 Kgx9TLgb0VNGntF5ctyHKhTk7YqSMAtEwHU2Y+zOg2CuZFslj8TQUoUnQUrZLP5CLB
	 CVOqAtd7Ik1iVFci02yygNq347W8EMSqyMmyoi38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1063/1376] nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()
Date: Sat, 12 Sep 2026 08:58:09 +0200
Message-ID: <20260912065631.249874379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit b53d495c7f0db46b6748b5ade48371a10dd5d3bc ]

Unlike IO_CMD / IO64_CMD, NVME_IOCTL_SUBMIT_IO never calls
nvme_cmd_allowed(). Unprivileged callers can thus issue I/O on a
partition device or write through a read-only file descriptor.

Pass flags and open_for_write through and reject disallowed commands
with -EACCES.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 1161be71d1ec ("nvme: reject passthrough of driver-managed Set Features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 930521c633d23..635e639650e84 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -220,7 +220,8 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	return ret;
 }
 
-static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
+static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio,
+		unsigned int flags, bool open_for_write)
 {
 	struct nvme_user_io io;
 	struct nvme_command c;
@@ -278,6 +279,9 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.lbat = cpu_to_le16(io.apptag);
 	c.rw.lbatm = cpu_to_le16(io.appmask);
 
+	if (!nvme_cmd_allowed(ns, &c, flags, open_for_write))
+		return -EACCES;
+
 	return nvme_submit_user_cmd(ns->queue, &c, io.addr, length, metadata,
 			meta_len, NULL, 0, 0);
 }
@@ -582,7 +586,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO32:
 #endif
 	case NVME_IOCTL_SUBMIT_IO:
-		return nvme_submit_io(ns, argp);
+		return nvme_submit_io(ns, argp, flags, open_for_write);
 	case NVME_IOCTL_IO64_CMD_VEC:
 		flags |= NVME_IOCTL_VEC;
 		fallthrough;
-- 
2.53.0



