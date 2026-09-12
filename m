Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C88A472074;
	Sat, 12 Sep 2026 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210915; cv=none; b=agFXiBylhrzVIVJ5kyvhPuWn0QeXnqbcPuNZd1aNt/ky3ky8EbsTzWaLDNgixBhEUULmtDMSEylO2bV/0mQ3RVfY+AAMD6vYy0eg82+cAuHZ1BJDBFVI9yGlB2Tw6aFRcMHdeJIfclvaUpRViMlyuU/WqZSCQpEZu9kIOfp0rk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210915; c=relaxed/simple;
	bh=aQdXL8IxC3vlsxPxj+Ok3u5z90MtJygHdmOO22HJI24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV4ke5iapj6n61HBrPjDhqvnTYH0VZdrYTFK89CBB28Ksws+AoBpZSdgSrQa7fi8p+zY8rycraD00NRbI4sjVFSbZaoPqWKcGh7DBDqyRQsY4erQ9TKq6m4Z5PeAV+tZ2YTkmCgADPXBj+q7nXYvMmhtVPIHEd+CSCKR7kq8vg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9/B6ACQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9/B6ACQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381191F000FF;
	Sat, 12 Sep 2026 11:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210913;
	bh=Kfs19zvbY8WWQ7nCwAOPcyGPNQxzLncHuXNTBpfnSPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9/B6ACQ/JbKXgaDeJ+Qrzf8RNuFGg3sCqoVG55nWbG11/BC+RqE+Gxd+QQ3yV4hQ
	 RSrCkmP1lYFSu7mapoYDKjKQnNpf5R+VX8JFC+YYVtXjJXEro5upypHBpt/MdD9uYF
	 NutE0+f5hm5nzhob/YVBDsCyMxe0RmbJuNOAik+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1123/1518] nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065648.857640574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5bbaf257fd6c5..9f6e09a20a916 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -202,7 +202,8 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	return ret;
 }
 
-static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
+static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio,
+		unsigned int flags, bool open_for_write)
 {
 	struct nvme_user_io io;
 	struct nvme_command c;
@@ -260,6 +261,9 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.lbat = cpu_to_le16(io.apptag);
 	c.rw.lbatm = cpu_to_le16(io.appmask);
 
+	if (!nvme_cmd_allowed(ns, &c, flags, open_for_write))
+		return -EACCES;
+
 	return nvme_submit_user_cmd(ns->queue, &c, io.addr, length, metadata,
 			meta_len, NULL, 0, 0);
 }
@@ -586,7 +590,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
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



