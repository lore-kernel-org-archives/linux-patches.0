Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A887E26B2BF;
	Tue,  8 Apr 2025 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115919; cv=none; b=Ch40HLuA1AaXymyuWbtXNngqmQZdSzv+Dn4H//84RQclZhf17fcHsb7bQwx4zgBodiAkf3uA8Ati0bupyucAbPAdd8cydV31eNnXB0ZG1Scfow4qBzTFr+m/EgyGmnKZoKwHv0gcbeH7sjRn9gcIH0uoD2vwrKCqeOCUnSu/g2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115919; c=relaxed/simple;
	bh=kbd5zB9m2vApikGpYqA+vVh5KuWBcJ1EzQO52GBUTQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9n+UTdWl+Xik6tOqlfhKvQcp9JpxT62f79uKR3i6a3OcHsGCay6o+G/LJcG3jm13sgjmCgQNgJQzE2wDgVmCHGWLruJgYouq0H6Io+JqKNcMayka2jbYWKBXcuDDKvbVUnr6+pUTsbZqqdH7U/4HfWAF2xz8yVPtDXZh3SawNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW3SXfwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW3SXfwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC98C4CEE5;
	Tue,  8 Apr 2025 12:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115919;
	bh=kbd5zB9m2vApikGpYqA+vVh5KuWBcJ1EzQO52GBUTQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW3SXfwUJKPhCxSA19tcT6PHjkoxES8q06sqssETQIs66mtN4wI5sOX6CawpxJSuQ
	 curZK/BuqLqc3RyGAWHSnswE08/IA8qztIXJyG077SqF7JUvYSTj+WKBuJQlofzyTU
	 CqeXF0GAnowvjT/fcDZjfjab6RMvm7vmwm7hW0oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/204] ntb_hw_switchtec: Fix shift-out-of-bounds in switchtec_ntb_mw_set_trans
Date: Tue,  8 Apr 2025 12:51:22 +0200
Message-ID: <20250408104824.767847392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit de203da734fae00e75be50220ba5391e7beecdf9 ]

There is a kernel API ntb_mw_clear_trans() would pass 0 to both addr and
size. This would make xlate_pos negative.

[   23.734156] switchtec switchtec0: MW 0: part 0 addr 0x0000000000000000 size 0x0000000000000000
[   23.734158] ================================================================================
[   23.734172] UBSAN: shift-out-of-bounds in drivers/ntb/hw/mscc/ntb_hw_switchtec.c:293:7
[   23.734418] shift exponent -1 is negative

Ensuring xlate_pos is a positive or zero before BIT.

Fixes: 1e2fd202f859 ("ntb_hw_switchtec: Check for alignment of the buffer in mw_set_trans()")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 7ce65a00db56b..1bdec59100019 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -288,7 +288,7 @@ static int switchtec_ntb_mw_set_trans(struct ntb_dev *ntb, int pidx, int widx,
 	if (size != 0 && xlate_pos < 12)
 		return -EINVAL;
 
-	if (!IS_ALIGNED(addr, BIT_ULL(xlate_pos))) {
+	if (xlate_pos >= 0 && !IS_ALIGNED(addr, BIT_ULL(xlate_pos))) {
 		/*
 		 * In certain circumstances we can get a buffer that is
 		 * not aligned to its size. (Most of the time
-- 
2.39.5



