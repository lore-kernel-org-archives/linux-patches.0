Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28FB2D249B;
	Mon, 17 Aug 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978990; cv=none; b=UBgqAO+dqCCsuo/eQAQHP8ykKKpaWybPULmJBa71xX6eF/hzlndRfA0Y66drPX6JlAAy4CVTaUSPzW9yoyEn2TtMSTqUUjs9+2kntRsya166L8IcNDJERL5Jb4Z/DMq+DA/wzdsqZK/dlUpUMtXy3LCrlF2bnxS4c8TxKhr8a+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978990; c=relaxed/simple;
	bh=CRiUCMDmiIv0JDAti1+CyWorNAWOEHJNqaRMKsAe7KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPGW/WmzdwEQf2oNVdB0almpI1y0atUMx93opWHEu0F1pRSU2796halQnnvsGVuBD8G2cTYB7unWObPfAhKuVWDKoVqapjJTMMKctaiwSq8ZqOGZ8ikE1IFHmY1/dBS7KhRT2cDjHwKvV44O2qBIjVGGjd366u6TDppvKqruTlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc/f6jJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc/f6jJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0811C1F000E9;
	Mon, 17 Aug 2026 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978989;
	bh=hyBknhxD62+cMcw6WWToUIGJDc58RDSxbmf09af8TZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc/f6jJfKXq9gExzS7rAfyZyEQKSIemr7NItt2SJ3ErZtbtTXhpNSuntF/PhGkWGA
	 jrDTAzJl1eQdALEwTEohNtPxA4LqYkahSDizh8s6MsLvASCOIlYn6df0+sykoaTkLf
	 LaSzHJ2TLHHLbupdrm9WiNLmfY81J2C3oYxcSVEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/609] firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()
Date: Mon, 17 Aug 2026 15:25:26 +0200
Message-ID: <20260817132544.256369096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>

[ Upstream commit 8ae5f8e4836667fcaffdf2e3c6068b0a8b364dd8 ]

ffa_partition_info_get() passes uuid_str directly to uuid_parse()
without a NULL check. When a caller passes NULL, uuid_parse() ->
__uuid_parse() -> uuid_is_valid() dereferences the pointer, causing
a kernel panic:

  |  Unable to handle kernel NULL pointer dereference at virtual address
  |  0000000000000040
  |  pc : uuid_parse+0x40/0xac
  |  lr : ffa_partition_info_get+0x1c/0x94 [arm_ffa]

Add a NULL guard before uuid_parse() so a NULL argument returns
-ENODEV instead of crashing. Callers are expected to always supply
a valid partition UUID, so NULL is not a supported input.

Fixes: d0c0bce83122 ("firmware: arm_ffa: Setup in-kernel users of FFA partitions")
Signed-off-by: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
Link: https://patch.msgid.link/20260617-ffa_partition_nullptr_fix-v2-1-bc801b4ce34c@oss.qualcomm.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f7c72fcc9b5e32..67ab5698a14241 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -655,7 +655,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 	uuid_t uuid;
 	struct ffa_partition_info *pbuf;
 
-	if (uuid_parse(uuid_str, &uuid)) {
+	if (!uuid_str || uuid_parse(uuid_str, &uuid)) {
 		pr_err("invalid uuid (%s)\n", uuid_str);
 		return -ENODEV;
 	}
-- 
2.53.0



