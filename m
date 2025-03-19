Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52391DED55;
	Wed, 19 Mar 2025 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395184; cv=none; b=spPsvJlkKCZgO8+K1Q9ITgjPQn5QagFOnZNDz4gLSJ8UGtE0QVj0sTszRaFgCj4P804boFBAXpYRKsQBs18BNXTSjse2MAVYqcs+zdOoOsbOjWcG1fQmHB+BMCtzxPCyTCTLgud52rY8gq3zAjHAWP7o8Z8hWCiiRDGGyIrlb+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395184; c=relaxed/simple;
	bh=4E+pyr/ucOpB58JNArbCf4bVc9ECb6gHV6I53UmUjDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8ZWjref3AReNPdmX5FAYFsmcdlpJcitMwm9wdOvbELSr09HkbDTH7QH6SNjZzQtJroFx4o3vJEtXovpr+gepSV67pe3l325rrFeol97UBr4cMZiFS9ZTPr2RD9pjTLEdlRRxYomkf2g4bYTr2T6j4acDp09Rn3P7CV0GQo/5Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZQlF6tC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZQlF6tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F15C4CEE4;
	Wed, 19 Mar 2025 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395184;
	bh=4E+pyr/ucOpB58JNArbCf4bVc9ECb6gHV6I53UmUjDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZQlF6tCDMzWQv8WmvK0+irk5yWii0/vApE6VkTIGxGEofPF3YNJ8Tk9nR4iv6y02
	 xACWWRI7sQXhpw7VBdIoFEDqGEpn+pSGm4QVez4BtEds09F4Dq3wuzBbypWWVqX2rG
	 rQP21vHUXrVAZHMSQa4E1o2KiCWTRE7h8W4usNBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/166] platform/x86/intel: pmc: fix ltr decode in pmc_core_ltr_show()
Date: Wed, 19 Mar 2025 07:30:13 -0700
Message-ID: <20250319143021.129841623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 583ef25bb2a094813351a727ddec38b35a15b9f8 ]

In pmc_core_ltr_show(), promote 'val' to 'u64' to avoid possible integer
overflow. Values (10 bit) are multiplied by the scale, the result of
expression is in a range from 1 to 34,326,183,936 which is bigger then
UINT32_MAX. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250123220739.68087-1-d.kandybka@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 022afb97d531c..2fb73e924bd64 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -620,8 +620,8 @@ static u32 convert_ltr_scale(u32 val)
 static int pmc_core_ltr_show(struct seq_file *s, void *unused)
 {
 	struct pmc_dev *pmcdev = s->private;
-	u64 decoded_snoop_ltr, decoded_non_snoop_ltr;
-	u32 ltr_raw_data, scale, val;
+	u64 decoded_snoop_ltr, decoded_non_snoop_ltr, val;
+	u32 ltr_raw_data, scale;
 	u16 snoop_ltr, nonsnoop_ltr;
 	int i, index, ltr_index = 0;
 
-- 
2.39.5



