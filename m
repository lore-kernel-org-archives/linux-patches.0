Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E458417C;
	Sun,  1 Sep 2024 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210127; cv=none; b=o2D2cSigo8pvcB3rgGZUAnXBMpyCSv3HjeTvn9+qR0wEkz8QeRMhFzRbOOIrVM/lq8Ci5cB4fgaJ0gsvqO9xgIeq0xnpl45O1okpdlpS8yoNA2CKX+cW0Hh9m9DusAQeeDW2kJc/pRsemSHM1YSOeq7FRLupHMCQVh1e26pIuL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210127; c=relaxed/simple;
	bh=XPENrdSAawLI5XbQ+kxkjGkfHgJeV9TdUkoXi9s5uUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzHBwjtQ1DWvFeIuKHutqoEz/d0bfJJIwgTkgdj9/BCANB5RP7JWs1T6KksZFD7dJO7PH62sdgIn4UgBEk5wgfF13uUB7dS0yoVlB2q/eCn29eX0/7voKrnlsuYFKhLSvZewCM/mt7zDlvUFsM9SKAh1mlcLQQGb0SCa1DCwOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI2f7aUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI2f7aUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D4DC4CEC3;
	Sun,  1 Sep 2024 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210126;
	bh=XPENrdSAawLI5XbQ+kxkjGkfHgJeV9TdUkoXi9s5uUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rI2f7aUisjJf6byHv7H2rKo3u/djddANsGgOsb8XSBDvhLqd4MllWKFOpbQtGXD2T
	 bOBjnhE9PGWeFFrMD5jjxfQBJdFDx92A8EUmHRecHjqKpkz+jQVoFhoe6JYySfATLs
	 BG4jUO/o8wQG9EjDB4x9/0uRpRN0nXNYGjC3atVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/215] nvmet-tcp: do not continue for invalid icreq
Date: Sun,  1 Sep 2024 18:16:48 +0200
Message-ID: <20240901160826.979056109@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0889d13b9e1cbef49e802ae09f3b516911ad82a1 ]

When the length check for an icreq sqe fails we should not
continue processing but rather return immediately as all
other contents of that sqe cannot be relied on.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8468a41322f25..df044a79a7348 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -858,6 +858,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 		pr_err("bad nvme-tcp pdu length (%d)\n",
 			le32_to_cpu(icreq->hdr.plen));
 		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
 	}
 
 	if (icreq->pfv != NVME_TCP_PFV_1_0) {
-- 
2.43.0



