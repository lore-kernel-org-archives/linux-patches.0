Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5AE145B05;
	Tue, 27 Feb 2024 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043229; cv=none; b=jN6dNdLOcM/zTevKkNykQxA0kBdK7nIpO/7JVK+PXscPloJUpT9VuE3v90w869itSLdHYGPFOlG8IyaNuQc9CPL9muQ36D/80BD8iz41cWhbdBmzRF5RyAopwtH5GKnamiRxXRi7kpIYA8QjzAlQUOTFCT6zi68MkORsCsIyAPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043229; c=relaxed/simple;
	bh=Qh4Eottv1LPOl/PxCUhyYjoojFA3YajgEjSiZQM1xWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUIOmrHdxmyVCV8wStN56DlSqb+Uqbipn8RAz1MnGCbb+GUFtUY4TK7Bp/hxXqGi/mrugLvOmwXspQ6Kf8fd2E5WV6mp/J6ruNV5NY1oJK/CwQ23uMEZMwYvnhw2bSvMIujU//B89dpBX+hMNWErrnvghgbO1VGtlUkyhyR5Gbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwmybgrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwmybgrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572DBC43390;
	Tue, 27 Feb 2024 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043229;
	bh=Qh4Eottv1LPOl/PxCUhyYjoojFA3YajgEjSiZQM1xWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwmybgrZfw6CIKqHlwjZ+MQPU7BWymJyzlSxZcUkRS3auG1nvX0CF5rYZhTpn7hCx
	 OFEElfVAoF8oxLAFNgfJI7DWSxW9njNvNTziUjr8QdpXJalUki2qftvtlvbSQsYBzx
	 yMSzf9olibiBNe3NYirY9TAbaeQwAlXup0nYzr84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/195] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:24:53 +0100
Message-ID: <20240227131611.453427287@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce42afe8f64ef..3480768274699 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1884,6 +1884,7 @@ static void __exit nvmet_tcp_exit(void)
 	flush_workqueue(nvmet_wq);
 
 	destroy_workqueue(nvmet_tcp_wq);
+	ida_destroy(&nvmet_tcp_queue_ida);
 }
 
 module_init(nvmet_tcp_init);
-- 
2.43.0



