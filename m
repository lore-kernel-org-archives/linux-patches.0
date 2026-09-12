Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27B41C5799;
	Sat, 12 Sep 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225278; cv=none; b=fz2gY6rBNzPD0xDNWZF7IDCaDQTzgVgPgUFCVi3dS02x41WbjpHLU5SJenZXcHgrcJt2cbNfX/9LU4ZU636XEkR4YdqG9iMwrXeMIXZtuz9wXT1nt9CWZ0qqhH5aUFDhm/dZIHOS7ffdFSdyd3XHM3R1F+idA2xtC7j7YyLboOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225278; c=relaxed/simple;
	bh=jC5N14ZFCQoCXHbAF1AUQK98L7JSEjRXwG94sK1LNNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfZOksdOEyYxAdkFlP3JtyVhkBBRiVGknrFsNNQM35SlhQSFb1Lhv72n0ZXW46WXY76u1UjOQ4UCKSoXt2NTtWGi5w6vl3cHbc+FRcplQ4PAq7TZzEXPJnQ1TWw8S/DhqqzChx0YDNF1w6KJgXqkoH0xHBedRbmuTsU3Q+oy/+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfCnCw7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfCnCw7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71B51F000FF;
	Sat, 12 Sep 2026 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225277;
	bh=tDQpWYC3uFDicSoVyukz5HauobQvbfCV+uP3PqQHs2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfCnCw7nysuUiqXloZ9XcsNe5cyfyh5tat8+fAm80bX2LMTEa5xZjSL+olEzBrB8y
	 uuN6xhWz+GfHxBsjf1rO5X6cCVrzkJpJVED3khJFjvKxK7ecEzT7xjG5nezHPhT4nc
	 A4m3hCblz2nZ8xJVj8JfbnusNG60DH+utqMcOLZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1164/1424] nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()
Date: Sat, 12 Sep 2026 08:59:56 +0200
Message-ID: <20260912065633.360918446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 5cf050e562b73..8902e1d2d5593 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -269,7 +269,8 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	return ret;
 }
 
-static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
+static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio,
+		unsigned int flags, bool open_for_write)
 {
 	struct nvme_user_io io;
 	struct nvme_command c;
@@ -327,6 +328,9 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.apptag = cpu_to_le16(io.apptag);
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
+	if (!nvme_cmd_allowed(ns, &c, flags, open_for_write))
+		return -EACCES;
+
 	return nvme_submit_user_cmd(ns->queue, &c, io.addr, length, metadata,
 			meta_len, lower_32_bits(io.slba), NULL, 0, 0);
 }
@@ -702,7 +706,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
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



