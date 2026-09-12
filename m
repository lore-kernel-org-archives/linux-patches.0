Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163047CA92;
	Sat, 12 Sep 2026 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218124; cv=none; b=aliLHwqRyyTzfb8zzBv+92a/RFWnn8nPw5cm1J7pMDEA+vZRYto4ScVZYEJGb6hKLZrzJF5FMcVouaxpztF0wsuaTiAXDNJOolhBxJ39G5KhDinShsH4YCLpg3b+1d65V/OR7MFKUDqk7WaUfJ+0IZPJcNhRU8yKUvGOHIq2VqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218124; c=relaxed/simple;
	bh=rXBeOp/ZeOJNC0Dj/YO44axJsb5vJDKoMczxbOaO2os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azBS+0KVDMMhI0l9akO5lT8AeuMBK0f4J2VgMqqXzrYi4b3rnw/eP45aLViOF5Uo/tzhW8AaO/SLFY8MKxiWxM0jHNtBMoWXvdqcTx0gNz3s4B86LxXp9nnJ1CYR3gdX3+cJqs2lnXJHM50DFEejn+yLon8fYxRbVl6m7RDb72U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU5BKdZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU5BKdZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B23E1F000FF;
	Sat, 12 Sep 2026 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218123;
	bh=0h308MZ3lRO1n9+v6vKyl7krzhfz/2+opzLfT2i1UnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mU5BKdZKVKBVw/fg5Ty1/erSH9no2qhkR9qa37MiH35BAEPCh+Ct7LDZ9xqctKbTP
	 dtHCNg8FDMBbCpS0iN3MePqYW1PhIntiO8PtX6V2hxkhpnGmCaV1WRcCTdUXnksICF
	 fTE+211/yUzYpnx9IQo1GtDpYr2NJi96NSowSeVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1081/1376] ubi: Fix rollback for explicit UBI device numbers
Date: Sat, 12 Sep 2026 08:58:27 +0200
Message-ID: <20260912065631.654717875@linuxfoundation.org>
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
index ef6a22f372f95..d8d3317f9763a 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1317,10 +1317,10 @@ static int __init ubi_init_attach(void)
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
 	return err;
-- 
2.53.0



