Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF432230BF6;
	Mon, 10 Mar 2025 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626732; cv=none; b=BKrM52t9PDT0LP5CTKMPrvgUa8pwe3JQQcV5BJdDbWunbdBhBeNp20a+HA0E72nuVdB2RINw+CC0QKpqg9e9HQ0xdXEXkiECLritwVYUriyjTaxIURP73ml55CLcEMKt8yv7Fg3OHyn0lfXgLWnv3Rsn60snQnPT36Fv6THZl6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626732; c=relaxed/simple;
	bh=8k44+r0wMWiCprAmKUon55zhTQVLYXjT2TUswB9Z6nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7J1BZFrfXLFFuLBKVYn8vaKpdYWzW5lM1jrIGv73Cc2D2/vVt/ZKsJvHhGp4PinRh3UEpcdsnwaK2G5cH0ZfrHY09i9YQGbJSSxqKD+L78tuFxYwVXbNO8DZkcywmhjvtCnTJBi0lVkY7mMC/KiH7BmoLB1PVxLbtbm5/AL2Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAfxMWmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAfxMWmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90A9C4CEE5;
	Mon, 10 Mar 2025 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626732;
	bh=8k44+r0wMWiCprAmKUon55zhTQVLYXjT2TUswB9Z6nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAfxMWmCiRFVKZSvbzZOULsd2mV/UO0VEWjeHmqTxpBTgwHriMahPSZN5uAnubeJl
	 Gs8ZP8uYJYZaVBbHXMagziqsSrmIVDsD6INqCuyI1xzwLOEOb/GtkVsbOBFkeJz5zK
	 yG1QgRgE3cuF/R6Y7M91jCCmaQ2jCZPg3N+eHk8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 093/207] nvme-ioctl: fix leaked requests on mapping error
Date: Mon, 10 Mar 2025 18:04:46 +0100
Message-ID: <20250310170451.456364638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 00817f0f1c45b007965f5676b9a2013bb39c7228 ]

All the callers assume nvme_map_user_request() frees the request on a
failure. This wasn't happening on invalid metadata or io_uring command
flags, so we've been leaking those requests.

Fixes: 23fd22e55b767b ("nvme: wire up fixed buffer support for nvme passthrough")
Fixes: 7c2fd76048e95d ("nvme: fix metadata handling in nvme-passthrough")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index b1b46c2713e1c..24e2c702da7a2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -128,8 +128,10 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	if (!nvme_ctrl_sgl_supported(ctrl))
 		dev_warn_once(ctrl->device, "using unchecked data buffer\n");
 	if (has_metadata) {
-		if (!supports_metadata)
-			return -EINVAL;
+		if (!supports_metadata) {
+			ret = -EINVAL;
+			goto out;
+		}
 		if (!nvme_ctrl_meta_sgl_supported(ctrl))
 			dev_warn_once(ctrl->device,
 				      "using unchecked metadata buffer\n");
@@ -139,8 +141,10 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC))
-			return -EINVAL;
+		if (WARN_ON_ONCE(flags & NVME_IOCTL_VEC)) {
+			ret = -EINVAL;
+			goto out;
+		}
 		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
 				rq_data_dir(req), &iter, ioucmd);
 		if (ret < 0)
-- 
2.39.5



