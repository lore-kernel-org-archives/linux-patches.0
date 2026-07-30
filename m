Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F543644C9;
	Thu, 30 Jul 2026 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421210; cv=none; b=bJ4o2BhfdSjzWaSKaihY4czs99YH/5AE1qjbE8K+Nr27XM96cJBFigVrFEq5dGbGLvP8Z9eWP5qbr5mp2LrrEBpq6UpyHvZi4qq/bh2YTaDYLyGHhAMnWt68qbam3KIAIn+S0mK7Yl3DSOUvrzn4cQGBahF2XtS3ku8F9ZpyjEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421210; c=relaxed/simple;
	bh=2S0g72EWWokej4nnwoemndzXD1E+LRB3plJCdnFNbVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8JPZfVLvd6meiUEa17eOp/lZ1APDG9dO6DkK2rZMgJDF3+Qs1cg2CHrx0Ad1dhkOlx07QgyNaUFauif9AtnurwFWRdcElSwQnecAUxbproXABMdbAWxZ36lp4EgP1dHtr32xPF+7iDhs033uzx0Dmk6OTOyIamz2SSDYtzzhRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Mq+By1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Mq+By1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D681F000E9;
	Thu, 30 Jul 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421208;
	bh=upss4VnNve35VBp4QiTMbemS4w9/Mh44r2LCBbP+R3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Mq+By1FoBhYCfiAKgt9D/YhmUtTh0WOzLi/kHzNgwznbx4MB5zgEoINtiUpbJD5+
	 850dsfZ/l50l8d4+t2AKOE1xm0h6kAe15M8ZAgk4HVpcBXZzXbSywlsPnl/AODeZtf
	 tAkb/8XJt4YR+dfjIlOLWyiZcV9HBbPmrIKp7eSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 027/744] firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()
Date: Thu, 30 Jul 2026 16:05:00 +0200
Message-ID: <20260730141444.862500865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2438ca09da24b..ea0671180a16d9 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1137,7 +1137,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 	uuid_t uuid;
 	struct ffa_partition_info *pbuf;
 
-	if (uuid_parse(uuid_str, &uuid)) {
+	if (!uuid_str || uuid_parse(uuid_str, &uuid)) {
 		pr_err("invalid uuid (%s)\n", uuid_str);
 		return -ENODEV;
 	}
-- 
2.53.0



