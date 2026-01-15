Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3143A7E07;
	Thu, 15 Jan 2026 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497758; cv=none; b=DENN721jLo7nFWTfNEYSiteG/zosp+qwPy01Izn666QAlRKGBOprVNUbzMl3IsQW6jIFl3i7ziHRMPmnZmB0dIOfveQyXkbb9CdhrsA0eTF7pCWkcIsgZSZJQwKifcw6Yw9LVTDEVAYVeneu+z9cJnf8ZKXUInDXp+LvK8JLunU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497758; c=relaxed/simple;
	bh=LtxZILs3h9nAOWpxi1wJ/+tTN4fR6G9mLFrUC/GiHH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbGDadsPLpXw74x3gSHpuqf4fje2A5FGjrFCJeUGXAuynsVaubBXeIsbSZDug8zVt+OHFLFmTtkqHZZztebcmL2xzsDlRwASqUUH8knYbHGCEm2N/ItdlmVv11BWMWhoekjm7onavc02KwC7POlvKER0FrGNcCrtj8A0o8De0Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1fspJpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1fspJpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68870C19422;
	Thu, 15 Jan 2026 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497758;
	bh=LtxZILs3h9nAOWpxi1wJ/+tTN4fR6G9mLFrUC/GiHH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1fspJpxMRmIcMMu+N1tuG2CTGjwYbx7Z/v7fY9CgxmiZ0wMie9ktpHb64r4q1bjr
	 ITrSrYeVkqZoL9c3ZxZTJZImdWrOUrRI4XhE+HcD5rS4LSKEgzCEaib0CH6cw6r9E+
	 CBaedwoAzyTaxA1qwK7KZU6dCmwUfvVNIlHQO3H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/554] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Thu, 15 Jan 2026 17:44:19 +0100
Message-ID: <20260115164253.245492218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d93a4db235124..d9e17fd5fe764 100644
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



