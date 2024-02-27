Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE413EFE9;
	Tue, 27 Feb 2024 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043751; cv=none; b=VVBSkpEf2NwLhyff8ZbXcmd40HTPAW3iSfKEJpZULSpwAZ0nfgIwz9MF/gqaVuHAraOloAuUYtwMQo42gP4XlleRbNNME3tjMS7J4afNwINsRWLWqJ2GdubJFgXKc17Llqh734jplDMVkH9iU+Vrs99xEyFwTA9f4xsvQ79aU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043751; c=relaxed/simple;
	bh=WMXqdPlSXe2J3aJ1ywfJUYb3AmW9e3+6UYBB71Ud0Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK/XYBQ0dSJGEuiUm/vwvXBdiawxD+piaSf1GDngdtQdEkh8IOBi7UKjKijUABGKmVWIpRtPBZiA7glf3UOdGZTW/eOcKxGDku8UoaCHLbJPc+oseDN+OIoIQ4J7Xt63yvGDntVuNP7iy9MOtX8ldzT2oCqgcGy4VfZgjFAEjo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+3ginOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+3ginOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED4DC433F1;
	Tue, 27 Feb 2024 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043751;
	bh=WMXqdPlSXe2J3aJ1ywfJUYb3AmW9e3+6UYBB71Ud0Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+3ginOAsdihIr8ZVcCUXjOOjwdB9J6gS+4IAihzY5Eejx3l78Xc6Q5FLAYDq2jpk
	 6FFbvuUfqtNb9B3p+a8eXoAeW+ufKZBNEf8Emancjvx5h8RtTl1hJ7yF3THpdBt10V
	 UyLfw9QexHzP76BbfaxI7LlwUP8TRg45BqwvlvlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/84] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:26:51 +0100
Message-ID: <20240227131553.651441605@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 47c5dd66c1840524572dcdd956f4af2bdb6fbdff ]

The nvmet_tcp_queue_ida should be destroy when the nvmet-tcp module
exit.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index be9e976575578..d40bd57537ba1 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1817,6 +1817,7 @@ static void __exit nvmet_tcp_exit(void)
 	flush_scheduled_work();
 
 	destroy_workqueue(nvmet_tcp_wq);
+	ida_destroy(&nvmet_tcp_queue_ida);
 }
 
 module_init(nvmet_tcp_init);
-- 
2.43.0



