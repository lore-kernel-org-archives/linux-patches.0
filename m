Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F1D12CD9B;
	Tue, 30 Apr 2024 11:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475262; cv=none; b=VES+HI/mxLkHtKldIoogB00uBAyRh/WsWC6KOm0lB1sSQUonokfAOL7y1XH0eTc06LWYfaE3C6jPuODktfLK/09OL1eNejPuNQqgHg2DOiNEoYQeqBF3a/D9L/AKskLMrwqQnYWGkfz8C79C2W8Q8kpqkprYZ370cGhEDhuiLyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475262; c=relaxed/simple;
	bh=ieXGq9iDTKDY2YQzbcwOSu68tRwjw7f8O/zwc7+Usrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCFzr95YmWDdruKTUkrq12K8xz2sZJL35saPIr+C6O2TpVT2nsCmsUFBBW50ubHoZJ823n3cIZ1gzOwtgLsWEFG2Dq6XOLhEAPnQ5CymamYOEfAGYRjWGp8UhbhsjLVkqnAtbcwJ9dh/tQuea+v+jf5nENMTKyQkSSVq7ZqlUGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBmYNphS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBmYNphS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D791C2BBFC;
	Tue, 30 Apr 2024 11:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475262;
	bh=ieXGq9iDTKDY2YQzbcwOSu68tRwjw7f8O/zwc7+Usrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBmYNphSDk78dmRBDaVNzcj2YzEGyzLlMrIuU8J68ZmwGVUYG7cNAV5Dt2PQS28J/
	 GDi+BKgjGUifGWjw/kW0t1CDJdha55dj0n969CfUr1/pnJd4HM1ghKpGciyn5oYNwk
	 BJP/YnP+uwknPDDOKkS1F+Zy9ABjoNSYc7OR0a9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors failed
Date: Tue, 30 Apr 2024 12:38:16 +0200
Message-ID: <20240430103059.311606449@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e078f4071dc23..be434c833c69c 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
  */
 static int wx_acquire_msix_vectors(struct wx *wx)
 {
-	struct irq_affinity affd = {0, };
+	struct irq_affinity affd = { .pre_vectors = 1 };
 	int nvecs, i;
 
 	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
-- 
2.43.0



