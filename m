Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675AD344DB5;
	Sat, 12 Sep 2026 08:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203148; cv=none; b=E8IkNFov/pMktMeOTE5PX69z7c0AueUwuvb0VYQppRIrScNWATII4NyF+fHtoIPlQ2rcbYTsVuJf1bHLs42aI14QToWaxN9xA/J61KoQWoifGs29nyEBf9WjrWlYEQUmo6Ax94xAAg2jWw7a/CRHxHlTgUHEx0y5DmcE1vKYzBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203148; c=relaxed/simple;
	bh=OJ211UsM+Dn+E24vyB8cqLHLP+6syhTySvHZWqEmse8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWAN9CydhGqAicSQAFHQmPDM2WFmilvWWn6x6dLsWC+GiB1vETdtRKbavNEGG94vn9F3h3Hgg3yJq65BO0cAcGZf+kgVdbk0P3Ny3pv0GfNJpfVK7HN66poXUXKy6vxxMF+ihRHMWi7XoxdL0bjI4zTT1+T2nhEHQVBiXu0BA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITFvut5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITFvut5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F861F000FF;
	Sat, 12 Sep 2026 08:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203147;
	bh=w/iOJI5TP8952MkAdR6e6LzU828HqmLPCENQg68tBCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITFvut5qTWh6JID2f7WUeYIq3iu779+H1orUIWNC6dRDPIydn8vuVcjX3gecmpllQ
	 0jszmCNPd5uT/b8irLszZhHlQba3w9PRifw6p5iI/OnV5o9xZjYj3Qf85ftFo4q95W
	 sec4mEYic6+RyAZtDe8+EjRWVMEzEzhFHBSeRpPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1349/1815] nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()
Date: Sat, 12 Sep 2026 08:51:39 +0200
Message-ID: <20260912065720.689624388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 664216eece4a6..752d7b2490009 100644
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
@@ -595,7 +599,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
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



