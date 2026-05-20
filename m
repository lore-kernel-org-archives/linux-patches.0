Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824BA3D5647;
	Wed, 20 May 2026 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302465; cv=none; b=Tj8I3qzorHvjlwR9tgqsUzqGfe7wViiWfIIqwkuSvQN8ml5PMBfxJN3yBr7NJ+DvMnIPEgRJt93Q4hncgkz4bMsXNTaXQV9AhtxplXws0oSRVzI2ifcKfWB/OSO+OZce4BlJIYUkEdSmT4BgI5wMC1uRE4JcTuruO5uq5YNKjCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302465; c=relaxed/simple;
	bh=HkAoOQWKrdmeqQ48xFdbn7J499NZ9zN2WnSGfd9W918=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS+5SkrGwKRoIVUHQ+4Jo/ygwB7XnEcn7u4kjZFse0Rd5SSmrJwCbshYCFnXvmoQh5LQ8uPKCHVuGx8EdxFpFkdpt0w6nZSbCN1jJvHYbSdryuAUrl3vGw4z4EuJKNoqZuw3aJuBV2LPETZ1knmsrJfB6GRWe8KSb5leePKV1lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+Ut/B6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+Ut/B6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7711F000E9;
	Wed, 20 May 2026 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302464;
	bh=UHTq+CjTt+XjgfiSAj3iQN2qfWjTWmLHN+hWl/Xjm40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+Ut/B6A4WDjVCTVRPkwAxjACIapwsk9ZynWbDr4RfAzGP8qMr0Tv/aShmcvarnCB
	 nC50NaYT1HgONTR6QQjAypDMdo78Hnr6XDu83hYaoiX/6sOh7D7zRDRhr3iZnsWdvS
	 3iNW7nL7Rb5aDvDdgPqn2U3ddTSwmw5VnJordJ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/508] scsi: target: core: Fix integer overflow in UNMAP bounds check
Date: Wed, 20 May 2026 18:21:40 +0200
Message-ID: <20260520162104.649166950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 2bf2d65f76697820dbc4227d13866293576dd90a ]

sbc_execute_unmap() checks LBA + range does not exceed the device capacity,
but does not guard against LBA + range wrapping around on 64-bit overflow.

Add an overflow check matching the pattern already used for WRITE_SAME in
the same file.

Fixes: 86d7182985d2 ("target: Add sbc_execute_unmap() helper")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881593C61AD52C69FBDB0BDAF7CA@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6a02561cc20ce..ad091a216b076 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1136,7 +1136,8 @@ sbc_execute_unmap(struct se_cmd *cmd)
 			goto err;
 		}
 
-		if (lba + range > dev->transport->get_blocks(dev) + 1) {
+		if (lba + range < lba ||
+		    lba + range > dev->transport->get_blocks(dev) + 1) {
 			ret = TCM_ADDRESS_OUT_OF_RANGE;
 			goto err;
 		}
-- 
2.53.0



