Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3A51292C8;
	Tue, 30 Apr 2024 10:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474066; cv=none; b=VvnjhyRR/K9w4pFMjyT916UezValKYpG+TU1ilyZv+8EpzullubSMU5u1BNQAk2we/zxfDsIhNVAfc3yGXvl9NwJF3mWqtv04IUCjM4vFnUPgGBAo9qFFUpNIg4MRRYSAnj3OiLE9kiMDaGjkd3pao/eOpQ9wAbJlcEROmkSIGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474066; c=relaxed/simple;
	bh=lknzl0rIRQfZTqmQQpzFvI4LJ0eiTogfhkr7cTfVDIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3BtW2RJtDBh4pndl6PWq3J3lrCIjpSC9MeGSB4i1JEck5MDw4oiLdYztCHOKNW0BSj3G/zBnsLsd0MQpiATTL2nq25d4Ql0FpLtPDSYH7pJrhL6X7kRkrQZ/wT+53wjbwVwZbDgYzAJyE+YNrPl4aRbYvnVu/ZhuuXML8pHogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpaLp6je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpaLp6je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE77C2BBFC;
	Tue, 30 Apr 2024 10:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474066;
	bh=lknzl0rIRQfZTqmQQpzFvI4LJ0eiTogfhkr7cTfVDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpaLp6je+dGWD5swwj68flyY+dEgTd43ADIz3hBgkJzFFNFWbOldHuqV5KL8h93b2
	 iJ6VP4qjt6EvHFwgVu8ks6tdGBSASCvhc7fwNDvAHMTebktzO+9RTbxqFf5ymZOlX/
	 bKmcVcsjfDlH3OdSwj4rd1eRnpgaUKz3A1dmArVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 048/228] net: libwx: fix alloc msix vectors failed
Date: Tue, 30 Apr 2024 12:37:06 +0200
Message-ID: <20240430103105.200123514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duanqiang Wen <duanqiangwen@net-swift.com>

[ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]

driver needs queue msix vectors and one misc irq vector,
but only queue vectors need irq affinity.
when num_online_cpus is less than chip max msix vectors,
driver will acquire (num_online_cpus + 1) vecotrs, and
call pci_alloc_irq_vectors_affinity functions with affinity
params without setting pre_vectors or post_vectors, it will
cause return error code -ENOSPC.
Misc irq vector is vector 0, driver need to set affinity params
.pre_vectors = 1.

Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 8706223a6e5aa..08d3e4069c5fa 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1598,7 +1598,7 @@ static void wx_set_num_queues(struct wx *wx)
  */
 static int wx_acquire_msix_vectors(struct wx *wx)
 {
-	struct irq_affinity affd = {0, };
+	struct irq_affinity affd = { .pre_vectors = 1 };
 	int nvecs, i;
 
 	/* We start by asking for one vector per queue pair */
-- 
2.43.0



