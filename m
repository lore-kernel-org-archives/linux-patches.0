Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4E402435;
	Tue, 31 Mar 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974827; cv=none; b=RyQeONhd+nSHxfRyT2zYzi9hutwv7YclJ+VxGEW/HqZSAiFDDPHwEuK+Jzzd4t1s9TX1BryqsUslzqBdtCuWr4NFrIWHzh+6s1mJwXCoR14P80W1iL8lTCM9kevztzW30TS8jGa/Gf/mkWg5UWCEZpffCTokE93f8iY7Qil+vDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974827; c=relaxed/simple;
	bh=Rl/SROiXkN5GprmnpwVrziKXfCZ6v6+ZDET/Ijmx8JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6lFyy0zuR3WFji87iIXabgA1agWdyJ/SSE/33qjPaE2c2Ff70CSnSpe2rLhMppj+nj/J8MPd2srlE8l2prBgCnaLAaOPRNxUkkv26t/HKLzQlwPSeyMXBfP322olXgoWe6tXXmlcV2z1x6sMIUJzH4cwave/bvuvZLJ3cr+qNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkUx/QVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkUx/QVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3803AC19423;
	Tue, 31 Mar 2026 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974827;
	bh=Rl/SROiXkN5GprmnpwVrziKXfCZ6v6+ZDET/Ijmx8JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkUx/QVyEP3Z9PwAfzIYYtSfSO9QZYWueRWSSC4Qx524YJXIUys6o70KejBH05Dio
	 hi3ZiEzvxgXkAzek1lDrWRHHg5e35YmTASz9sqfB1AIYiylkD+a8P9CLEguA/ml1Nb
	 AG8iibkid7sGLQMG2YWoRVVktD7OMztmDahGenqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daniel Hodges <hodgesd@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 026/342] nvme-fabrics: use kfree_sensitive() for DHCHAP secrets
Date: Tue, 31 Mar 2026 18:17:39 +0200
Message-ID: <20260331161759.873885818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 0a1fc2f301529ac75aec0ce80d5ab9d9e4dc4b16 ]

The DHCHAP secrets (dhchap_secret and dhchap_ctrl_secret) contain
authentication key material for NVMe-oF. Use kfree_sensitive() instead
of kfree() in nvmf_free_options() to ensure secrets are zeroed before
the memory is freed, preventing recovery from freed pages.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 55a8afd2efd50..d37cb140d8323 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -1290,8 +1290,8 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
-	kfree(opts->dhchap_secret);
-	kfree(opts->dhchap_ctrl_secret);
+	kfree_sensitive(opts->dhchap_secret);
+	kfree_sensitive(opts->dhchap_ctrl_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
-- 
2.51.0



