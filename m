Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25AC266EFE;
	Tue,  8 Apr 2025 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110576; cv=none; b=Eujz80QHxEbUQf0lXm1OmokmcEllSKJn2TstziUpEe9HcTNI5hytTCI61e0iojsEXpXaerTELEcT02uwQ9BLeV1ikSeM+ws9qmEnt3zfE7RDu2p4eTMVVc1HmlgrQTB6hgMoCxFHgRmWmzhUtCFBsJJHKpY1KzRZBkUgLjagfSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110576; c=relaxed/simple;
	bh=RDT3yzyiZGD+lsaEAvnLXx5Rf583QmjHzEppNAxtNb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaxcQHySZbc/dEFyVuw+uPSRIWhn7r0H2hGkh0Q7y46nHXyae68PVz+oKeiXMVns8HbhwWkJH70fxc3QDstdBTJ+I3uuk8zC6DwbvDTM9bSkTLfLSOMzYosrXG6xpcN4XGUCV8U2yxClPTzggfD7j2ujMaV03GNMct3AojnaiWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRdeVt8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRdeVt8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D9DC4CEE5;
	Tue,  8 Apr 2025 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110575;
	bh=RDT3yzyiZGD+lsaEAvnLXx5Rf583QmjHzEppNAxtNb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRdeVt8UOagoDusuMXi7LPcJ5yAMXFbxw+cWoUaIO0k/3VHH2Qu0lpm1UVST33Ybv
	 GS1cMGc2GaU6b3HnhNhFhP45W4ep8n5jYnuUEQPHP/OLYerND6HcbazEgDytG7vuK0
	 wMEiOg+5/NKVPUbXdUYSfCFKhhrzS7weTAdQA0yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Homescu <ahomescu@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 114/731] firmware: arm_ffa: Explicitly cast return value from FFA_VERSION before comparison
Date: Tue,  8 Apr 2025 12:40:11 +0200
Message-ID: <20250408104916.929032163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit cecf6a504137aa238d768ae440a1f6488cb2f436 ]

The return value ver.a0 is unsigned long type and FFA_RET_NOT_SUPPORTED
is a negative value.

Since the return value from the firmware can be just 32-bit even on
64-bit systems as FFA specification mentions it as int32 error code in
w0 register, explicitly casting to s32 ensures correct sign interpretation
when comparing against a signed error code FFA_RET_NOT_SUPPORTED.

Without casting, comparison between unsigned long and a negative
constant could lead to unintended results due to type promotions.

Fixes: 3bbfe9871005 ("firmware: arm_ffa: Add initial Arm FFA driver support")
Reported-by: Andrei Homescu <ahomescu@google.com>
Message-Id: <20250221095633.506678-1-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 8aa05bbab5c8d..ce1ec015e076b 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -145,7 +145,7 @@ static int ffa_version_check(u32 *version)
 		      .a0 = FFA_VERSION, .a1 = FFA_DRIVER_VERSION,
 		      }, &ver);
 
-	if (ver.a0 == FFA_RET_NOT_SUPPORTED) {
+	if ((s32)ver.a0 == FFA_RET_NOT_SUPPORTED) {
 		pr_info("FFA_VERSION returned not supported\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.39.5



