Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB33E274B46;
	Sat, 12 Sep 2026 19:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240105; cv=none; b=XeKDar40EmSYV1IHgJI7tYy1DG80/EWdGvryxrp3dneki3Z4+8BA23h2eF/USHQ4AKWm7knwC9sE9v+sjCPtKb8IjCj9Ow3OZ8jqiozfv8bR0p4FpOusewE6NLRUHOwEdJPDUG+wgpt6LZqc2HeLpv2U8SOAFcAqBaaUyOX2uG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240105; c=relaxed/simple;
	bh=4M5gihXZcyfw1S53YPMrctTMAcIvjAxP9A9D0Ju1Q+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlCecNp+CCUMUJjAuNp/KFV5RlsxnVOUwbO0vMiHyWInI1dGQrJi1TSt96+aSH7+j4muDsACTWd2qxRUgfqHvLTpnZhWVfbPpXYe0FvULTxnKBvZ3YlMk7UNrpAoxTgHg0D6/bzEe2FNVgIPy7mq7G2+SfGxqcn0a49NZsGFWZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1UEqnx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1UEqnx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4211F000FF;
	Sat, 12 Sep 2026 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240103;
	bh=8STRA4X2esRMKKUqMFPBj5rhGVfJgqXjK68ciUo/unE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1UEqnx7C/2mAYZGMCzm2etjWfKw387T8ZoaOhDxO5xErqFaMgN1+9yrfL8dq5usP
	 qMfHmDu5RXhjAZAr3YcikmXAz7MRTPqwSrd8TznrYg+WONWDYbaV7+vZ7x/mV5riA9
	 tXyGvgy5p84fym4T2e3to3nXwa270w1UzRelzWe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 799/935] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 09:03:49 +0200
Message-ID: <20260912065545.165194996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 5b0a6b554e12a97f9771a9a9f4ea1f5457373c73 ]

ubi_init_attach() rolls back module initialization failures by scanning
ubi_devices[0..i-1], where i is the mtd= parameter index. That assumes
the parameter index matches the UBI device number.

That assumption is not true when mtd= specifies an explicit ubi_num. A
successfully attached device can be stored at a higher ubi_devices[]
slot, and a later failure can miss it during rollback.

Scan the full ubi_devices[] array and detach by the actual array index,
matching the way UBI devices are stored.

Fixes: 83ff59a06663 ("UBI: support ubi_num on mtd.ubi command line")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a0f4f4be17c0a..184a68dca2439 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1316,10 +1316,10 @@ static int __init ubi_init(void)
 	return 0;
 
 out_detach:
-	for (k = 0; k < i; k++)
+	for (k = 0; k < UBI_MAX_DEVICES; k++)
 		if (ubi_devices[k]) {
 			mutex_lock(&ubi_devices_mutex);
-			ubi_detach_mtd_dev(ubi_devices[k]->ubi_num, 1);
+			ubi_detach_mtd_dev(k, 1);
 			mutex_unlock(&ubi_devices_mutex);
 		}
 	ubi_debugfs_exit();
-- 
2.53.0



