Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0C16423;
	Tue, 27 Feb 2024 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042630; cv=none; b=lpTsRQikliLBujYzweHTwpj/IgZhwHqKkkRkKtRNfyqztSkiJT+QI01uBhBPVFVrVDH73fle0p9lC7u1mr3F/KpBMYx9yGnh8LGPYHZqJjJta3BtBumpYVr1F/qJLBLvEyoUZagxxr7ZuEbqLnou+JpmrDvJ/b/l9EPQHYISZ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042630; c=relaxed/simple;
	bh=Y7gfWtVbA8fWAo8mMZg8q0vBxZ14qEL0dN8VxiWgv7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI3tOa6DdSSP1GLIKYwW6n/MstU9g2hCzWhkWniV8g+vjotbtAeLf697bUEEuKqB0NxDxQZkZV5JDN35E/0qlzqOgGCr0meykXLUIzUe9Vm49aYtqoVFt/9VO6BVMNuDrtHKV9OvBGJ5PV63ZggOEgwgEuAxwh4rg4jQpp3omwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IqjuQnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IqjuQnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3513C433C7;
	Tue, 27 Feb 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042630;
	bh=Y7gfWtVbA8fWAo8mMZg8q0vBxZ14qEL0dN8VxiWgv7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IqjuQnzMDgpvZBl8EDg0ghz5ziEuWgOVcttiq7pLAcb1Ycc8cWlotKeQQ5VstoGw
	 vBpyxsKnjCfYP9poIp0cKgqgZCXj9iP6+L6HwAHTFXPqoKJXm7MYKStjc/T9YOUKvk
	 5RxznrT1JaUJYsVJMGZSj9eUAUSFF1T7nKPtPrGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/245] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:23:43 +0100
Message-ID: <20240227131616.260942272@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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
index 4f2164a3f466b..8468a41322f25 100644
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



