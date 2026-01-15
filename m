Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DE23BF2FA;
	Thu, 15 Jan 2026 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499201; cv=none; b=RieueMlrvEb/RnCNbT0z+XozZylob/Mu1heKrVp2QfuQL1ipfrax+RydmccU+quODDl6RcUVGV3pol6yWYEalw6n2B5lzeohH0X9sv/Av9GKTiglfnCNJtyOOvnMvWzemGfBdiHymnRa95OSPAzwgRAYgIfo2iKHisUx1ULVDUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499201; c=relaxed/simple;
	bh=nPT1tkI00q6wcN0gmZvrSO5DfpBgSY7nxdeYZdoyCEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ui/D+Z3VYPT8brgrIwegHVNNRDo38iCnriWxvSSrgBBCEyLWSi+/0t1yqUaILxVUrtVE2I21vX4EyVFfv+ZRz9E4txLRCP+PP5cTyK8ZZ7N8M5PgbYNuo9pbNVFZ2DAsY3Z/Nm09tZq2/TS+EC7yi/SQzFlQm+AV+KuSRQbvPk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooKh+n3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooKh+n3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87406C116D0;
	Thu, 15 Jan 2026 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499200;
	bh=nPT1tkI00q6wcN0gmZvrSO5DfpBgSY7nxdeYZdoyCEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooKh+n3+ojtqtQHZb776dgxMx+CPITt0c7FPxhcvfzNMKQRjHtap2RXdr2ESNZT8A
	 c9AHStmCRBMKzNhuJ6kCJednoNcQYvwM9W9SiqG99pHL1/uQTbrTuCE2rk5h+TzI0z
	 fJlhYyjNhdxnLONW9EFOvRSRbX23l6QvxqHvINWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/451] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Thu, 15 Jan 2026 17:45:44 +0100
Message-ID: <20260115164236.090040520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit ab08f9c8b363297cafaf45475b08f78bf19b88ef ]

The log_writes_kthread() calls try_to_freeze() but lacks set_freezable(),
rendering the freeze attempt ineffective since kernel threads are
non-freezable by default. This prevents proper thread suspension during
system suspend/hibernate.

Add set_freezable() to explicitly mark the thread as freezable.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index e3d35c6c9f714..ec194ed87d624 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -454,6 +454,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = (struct log_writes_c *)arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.51.0



