Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844FC26F453;
	Tue,  8 Apr 2025 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115180; cv=none; b=kGLzPKmKdwdtx+ZBOmmDc78yEu2EJ6eZ+fZvz75+pXdMbs3CEfS4ZDraTX0q+9MklIF+GwiFRSqCfjsOpo6nJYpNXMCN9g4zfiCWpgkpQFXY4CcPboO71ZsjkC3f4Wa9GL2zlXpgNFbiJau5CpxVr7wj5iUEuPFH5BE/Qq3xufI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115180; c=relaxed/simple;
	bh=HzV3oDwi1vk9KKIlMEb/LegV+pEaMJxETqlszwoxJvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJaVq/I8xCo5d2wz/ekzgt9NmeZC4xKw16OvtiYMbbY2uvAMd52FfJhrl/chx+asYN4KWvUf7VCn/2c2TyymRqS4IM0oo9ZJQQiaROY47itjeI5GuPxXMvLAAeKBAjfwagtsAaS8dhYWDszYuLx040Qm1FMnH5JFWijKqcYfvzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ua/r9fY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ua/r9fY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B029EC4CEED;
	Tue,  8 Apr 2025 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115180;
	bh=HzV3oDwi1vk9KKIlMEb/LegV+pEaMJxETqlszwoxJvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ua/r9fY6FNqxhAu9GCB6bertZI4c97c9W0IzVOzZdF/aXq0C2m6VIfxxUqR8wlGVK
	 fwn4EoIWuPthTnlSAYHJdxy1YJP8dW0sI/Y5dCPXVdazMAweRCtRigr7QIILDYrTz6
	 HN4zJupB35YTbprkj9+LjDe0FuVFfwRZ4WTvhkQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 377/499] nvme/ioctl: dont warn on vectorized uring_cmd with fixed buffer
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104900.635352321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit eada75467fca0b016b9b22212637c07216135c20 ]

The vectorized io_uring NVMe passthru opcodes don't yet support fixed
buffers. But since userspace can trigger this condition based on the
io_uring SQE parameters, it shouldn't cause a kernel warning.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 23fd22e55b76 ("nvme: wire up fixed buffer support for nvme passthrough")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 24e2c702da7a2..fed6b29098ad3 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -141,7 +141,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC)) {
+		if (flags & NVME_IOCTL_VEC) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.5



