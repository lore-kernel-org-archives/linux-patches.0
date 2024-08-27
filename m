Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1FB44C8C;
	Tue, 27 Aug 2024 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770208; cv=none; b=oeyckkQZ0U+/lWoV226byXwuKSIiUOE4oTmO1uOUdIX5mS1rrF3uUw+qX8DqR6mANtvGSf12O9iCbZEB7ouUVmIllY70tX+e4G8dnTixjGXhmX5SRfdh/LDqWVSgU+/R/xigCmbjLZchHIug1dT+MHI1JdkARIYLVoDLOr6LzOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770208; c=relaxed/simple;
	bh=Pg8sDlpUhcqrodSYrPPMiInw37CyOWc/5IE4NasnOXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpMT7g1UxVmUn2xX7Brh1tnmq0t4F3eBd4K2B+rEK3qUa8XA2tUkVQwNw+OAmoNIWA1G2g9CJO5cMB04d6c1DHCpM0cjUWIt5ZuYxK5oT5VMsR9+NSkG+SIegpScEETtgVe/OdyegJqN18A+nseTN7zeNmEfTLp6HeJLpi/xWnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niKTM7dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niKTM7dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEC0C4DDF3;
	Tue, 27 Aug 2024 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770207;
	bh=Pg8sDlpUhcqrodSYrPPMiInw37CyOWc/5IE4NasnOXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niKTM7dLyM6SEkIWNZrY/Iqmn0rMcABXcE05ukJ2TBHzhen+amw8w6/oow39rywm5
	 7E6KPveyQ5o/JRRAXKvzuUofT613ldcBj6r4csx+R2c2wWECKnq6CxQBnvi/6twnD2
	 j1f3DfW3P0kLllIs+0TyJfigCzhPAit3OXQ9hEnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/341] EDAC/skx_common: Filter out the invalid address
Date: Tue, 27 Aug 2024 16:36:23 +0200
Message-ID: <20240827143849.202278154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 1e92af09fab1b5589f3a7ae68109e3c6a5ca6c6e ]

Decoding an invalid address with certain firmware decoders could
cause a #PF (Page Fault) in the EFI runtime context, which could
subsequently hang the system. To make {i10nm,skx}_edac more robust
against such bogus firmware decoders, filter out invalid addresses
before allowing the firmware decoder to process them.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20231207014512.78564-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 03d7a74ca22dc..f4b192420be47 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -659,6 +659,10 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	memset(&res, 0, sizeof(res));
 	res.mce  = mce;
 	res.addr = mce->addr & MCI_ADDR_PHYSADDR;
+	if (!pfn_to_online_page(res.addr >> PAGE_SHIFT)) {
+		pr_err("Invalid address 0x%llx in IA32_MC%d_ADDR\n", mce->addr, mce->bank);
+		return NOTIFY_DONE;
+	}
 
 	/* Try driver decoder first */
 	if (!(driver_decode && driver_decode(&res))) {
-- 
2.43.0



