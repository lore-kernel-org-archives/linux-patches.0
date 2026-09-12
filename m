Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650B8347FEC;
	Sat, 12 Sep 2026 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219455; cv=none; b=MWX9wVe482+hEn7MAK3Z0VkbIRAhU1i7zgOpL1mA2iBSFjoBFz2TxF0bDWxP3ncXOxBg1bgjfCdXKsCnzbAxvVQThWn0wIYgAP/DE1AbshPgL+mFxuKb7bJVsal2AfemubqtE9FU8ERPaXVZjXTzrcbWffHQMcoGb1yktP//d9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219455; c=relaxed/simple;
	bh=9E4Tatz9RWgAswH3rSDEdiiY8to/SIR2TNIu43a++Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xc9kgz9miTgkshBO+6ccufxWYcZnxcNeJRPDF+9sAAtikCqeeNQBuKs9bjzn/5AYVJxyzPi01z9ujxmONUnkmQYQgmgXVZgAvtMiIa2Q0WlGYtHUeOYnB1FAJqbSJeKiD0JLkkTuQzNTpOQ/PPnfHU3+dDEV/NWRpTnf5FUgSMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJrr6Omn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJrr6Omn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007121F000FF;
	Sat, 12 Sep 2026 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219454;
	bh=aSU2idH6SrISdLK6jMhLrN8RSuwSMwQIqQmphn7Wn2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJrr6Omn9YV+cCP1FcZhd7QSVlkz44oqrGnfz7VPCTefupQrCIw/zIQAjecXRaq+1
	 8hYyQdiMwWh4a1FdnFbWKQOHkU+3nGvhDiJYiiWEEQCLz4Vj2bnKacuQQUa5tVu+gn
	 7PCWdm8BVzv3o5ER/hp7Qza7AzH0Q77nH/D63a9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuriy Havrylyuk <yhavry@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1355/1376] nvme-apple: Reset q->sq_tail during queue init
Date: Sat, 12 Sep 2026 09:03:01 +0200
Message-ID: <20260912065637.733162565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit a6ab75639e23169a741b0b2e12191fd8acb32c73 ]

Fixes a "duplicate tag error for tag 0" firmware crash during controller
reset while setting up a  queue on Apple A11 / T8015 caused by stale
entries in the submission queue due to an invalid sq_tail offset after
reset.

Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Cc: stable@vger.kernel.org
Suggested-by: Yuriy Havrylyuk <yhavry@gmail.com>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 1cc222fdbf22e..db8c20a60064f 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1025,6 +1025,7 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
+	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



