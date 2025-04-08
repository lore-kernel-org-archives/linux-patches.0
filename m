Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0D26982F;
	Tue,  8 Apr 2025 11:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111908; cv=none; b=nVEk0ilWhoboi5G5qj955E2pb88DLKP+/CIAQTMjmHHOEh5wfCb8hKLgxSyx86TMryBdZgkgsF0o7RCLcSL7iJRkdOqfwuN5CekZoeG3UZxy6BUOXtaLqjXLoxbZxZongE2ZqXdLuqRI78Z5JlMtlCAWYpeUxxDvD9RgM56+qKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111908; c=relaxed/simple;
	bh=AZ0AHA7/s2QCHYYOMLd/8EbJTV4x/S9UY+X7n++ixRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuPhgGgcBYwqwSsl239WR5FidosOZ1+X+r5HY9xY/eYa9+P4jHYijhO+MlXn8xHOimpBqB3dhuyNO+jh/Qz2TCMwrjEV+vSUejUPXgKvlLZscEJBL2mM9OPn4Yw387ocRpzUKobBiCLwuMXXpoaTQ4sCSNxNbH/Fe7y1znO4FD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXevPqz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXevPqz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA107C4CEE5;
	Tue,  8 Apr 2025 11:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111908;
	bh=AZ0AHA7/s2QCHYYOMLd/8EbJTV4x/S9UY+X7n++ixRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXevPqz3R8czrI/MJBT+HYk5IAw2hkK9l4FAgLclYBLqvo4jcpgnaIHydMur6CMqN
	 +GiFhlCwn5Oqvg5+G3ZwG4bDiDn68Z7WE8ezs/1HOBOh5l8R3sq0y1hA3jkRWtbNBR
	 DrNlEYb000dHxtYYIJ053re6BKB0ttt+HOQauTB8=
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
Subject: [PATCH 6.14 605/731] nvme/ioctl: dont warn on vectorized uring_cmd with fixed buffer
Date: Tue,  8 Apr 2025 12:48:22 +0200
Message-ID: <20250408104928.346042146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



