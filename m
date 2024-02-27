Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA6414534A;
	Tue, 27 Feb 2024 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040609; cv=none; b=QAFuJTmpbEaCLxMi/OdWUYirI5mmd0acer8VqbV5/ECO5Hoxvky/EHZ8hv2610pSJyiumYT5sw9KxdgojuOXd6xS3Y/rOvgXY4bqEC9HUVEJt67k7ccJdTaYuEwqbB7iEQD+FEK6lNPcKQSRI0lLktwar+o9cYKrn51mW/KTg5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040609; c=relaxed/simple;
	bh=YrO4UiRY+opecO4J0BSh001ZjDAQY0707q+amBdbhs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeNedql9hMVSwZQYi5/Tk42gJuh28yDI22fJ5f570AS3q0Vzi6Cusb6JmQzL7fRg5PLULGXafvwchMVxTXQP9oa6fIysBYNn1Y68a9Mheuh4PuSqPmU6NVz7DpoQ2B/Ix2NNoLiDbj2DK7joJuy/SNZMvCgEiO6iNWUWdC0TYfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5/h22yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5/h22yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E16AC433C7;
	Tue, 27 Feb 2024 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040608;
	bh=YrO4UiRY+opecO4J0BSh001ZjDAQY0707q+amBdbhs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5/h22yiqm5QsBalIgSCXHtxJzAqCivZ3xAxqr0UmIA1lCvchNTTO619xirFOAQiF
	 ogwv+x1fc9vpy+AB2xJGMd2pyZYmMf0ruX7YKTO4ce+JKci+U5CkOqaIm2Aw37uMkf
	 PgVb5V5/m2cMpK9spoGSzBQG3KBqQNdvRshxWZB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 045/334] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:18:23 +0100
Message-ID: <20240227131632.038000709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 80db64a4b09f6..bb42ae42b1c6e 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2204,6 +2204,7 @@ static void __exit nvmet_tcp_exit(void)
 	flush_workqueue(nvmet_wq);
 
 	destroy_workqueue(nvmet_tcp_wq);
+	ida_destroy(&nvmet_tcp_queue_ida);
 }
 
 module_init(nvmet_tcp_init);
-- 
2.43.0



