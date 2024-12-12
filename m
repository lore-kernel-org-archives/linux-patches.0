Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E64521766B;
	Thu, 12 Dec 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016007; cv=none; b=KGkNz5/Lni6q861cb9HK3GvXQWjHsbed+cwFAvU2Evw9kJstxz0V24MRG4b/ce+ZSw97paVwsdjSu62CAdym2JNSrZF1sNSEAzVxoImN4qNnBHsL35JPIRA75jbhtPc+MQ2mv98y2jOGNyIOtCKBdbvjIyfintVBY+c3kAjc8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016007; c=relaxed/simple;
	bh=MSeky+d8LidpYuddQugZXQMdj1MCVIZN2okYHyB0/Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/h8pEy5rA6e9N8SrA2FiOFRv9lfJbdQ8ZcXhOHvseFUMy9n/OHT8lGS82AU9x4my4PIzYVJyv8Wq3q9jvIUrzJiGuo3VCq6qJc/N0W5j3OjsvQV3dcWNosGNNfUmfu0SVxPFKIhD8e4KX51za8BDD4kbwEVxnOUt7Ow5kfNoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFZoR5Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFZoR5Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB9C4CECE;
	Thu, 12 Dec 2024 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016007;
	bh=MSeky+d8LidpYuddQugZXQMdj1MCVIZN2okYHyB0/Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFZoR5Z2f3cV+jID9v0SJ+saOGyyt4oFEh4iYC8pfHNdZajy7U+kjAwIVzX4TZRl6
	 Zbp3zRwI80xTiJC2yZu8Jq+/o5eoTrqF2k6WJn6glIQr7uYVFqXmXAXqIoaJLCtGVC
	 iLDlpudg3tdL9QwQHM4wpv1cFrFxGCiueuumK6Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chunguang.xu" <chunguang.xu@shopee.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/466] nvme-tcp: fix the memleak while create new ctrl failed
Date: Thu, 12 Dec 2024 15:54:35 +0100
Message-ID: <20241212144311.006996858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunguang.xu <chunguang.xu@shopee.com>

[ Upstream commit fec55c29e54d3ca6fe9d7d7d9266098b4514fd34 ]

Now while we create new ctrl failed, we have not free the
tagset occupied by admin_q, here try to fix it.

Fixes: fd1418de10b9 ("nvme-tcp: avoid open-coding nvme_tcp_teardown_admin_queue()")
Signed-off-by: Chunguang.xu <chunguang.xu@shopee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 3e416af2659f1..55abfe5e1d254 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2278,7 +2278,7 @@ static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 	}
 destroy_admin:
 	nvme_stop_keep_alive(ctrl);
-	nvme_tcp_teardown_admin_queue(ctrl, false);
+	nvme_tcp_teardown_admin_queue(ctrl, new);
 	return ret;
 }
 
-- 
2.43.0



