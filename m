Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EADC33CE9A;
	Fri,  9 Jan 2026 12:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960195; cv=none; b=PZoffVfbydiVS5dYnXlZmiUpG0eDCdDtkM9zCaC7Vzr542FshCLYmcagM6ItELuYWAzQlhzjoByp2If3NPrwyYSZhDg16tkHfVuchHblsX/C0tRn4Bc6lR9Sp+7QqbnKkQzjYK//0Kg/9/+oLHXsJadpAp2aho9LlOYLBy9z0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960195; c=relaxed/simple;
	bh=Pelj5koWRfgpb/bX9yZSQFxbL8LtR/h9qPawgSKr8Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec+J02Z7faoQZfPGqZ7sWfcVvtTgKijC7BN42of8gptiiFoMtWxD7lfsArejb4UEsKLHc4iRTkNU1FLkcZRV/JE0r1tAvjf+JQPy2KDXryhAaajDpfITeVF3dWSgcmFwHJO4s32w9Q7e9gWjVQCKLAnWkv2Uy+wFuGGate3+jPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w916amXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w916amXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF073C4CEF1;
	Fri,  9 Jan 2026 12:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960195;
	bh=Pelj5koWRfgpb/bX9yZSQFxbL8LtR/h9qPawgSKr8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w916amXAsyV4sp/F3EFj5DypRtiFoMOpr0aP0Km1Zf6NBWxQbiwD4+i8GPV0UVaKN
	 TVMOmX3o2fBlaA/yg/skbLPr+LHQImMvXnkyNXohlmn5FQKlye8bYnb3rUcVj+7zyN
	 NV7luFL/nVzzXJPd94S8+kApirWI1SFtS04/OrvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/737] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Fri,  9 Jan 2026 12:37:05 +0100
Message-ID: <20260109112144.770930470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f17a6cf2284ec..dabfc856443a9 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -432,6 +432,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.51.0



