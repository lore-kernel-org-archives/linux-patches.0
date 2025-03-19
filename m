Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C3E1DEFEC;
	Wed, 19 Mar 2025 14:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394875; cv=none; b=KbmzjeSecX9Lkyazcu21iKsKYW/f4lvuLLVsplALTY59ptLvzo7AFcFyy42HgBTsuWOaWEXS/TN9mmPPeZKDHdP/QESKZFF6RsymmY83zKudxD0QTi1Px3h41HKuchqhINdUYnXmWk6wacdSU2yJm30I8gtdkFIKwbLs1hjV09g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394875; c=relaxed/simple;
	bh=cSO+iCZPUbjgqZfsCLJvIjDq0Gj4rQlygvbhfPkxS00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4qN+trT+it2CyvI40JOxnsby1iosoSzSfxtCVifdaFC7v0wXACfunVoeaIPSRHGhC19a7pVFJ7y7njkFk65P6kkyasWmAWrSNut/kIoWPceFHvKDRO5aNgApJ6v9gKlRa0+SqG5xwqo2l+iOcbM7AwJRgRiotXclBjt9+tmVX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LileyClJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LileyClJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C8EC4CEE4;
	Wed, 19 Mar 2025 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394875;
	bh=cSO+iCZPUbjgqZfsCLJvIjDq0Gj4rQlygvbhfPkxS00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LileyClJHhiwXOPI4PVHwh4J6B3dV1d0+1ZOWBTF8u3vhur2j5CGICJadGviyvXeU
	 TbJExYJXuSlip6AS3++24uI7sOBus2+ZNlbMQmdxlPxTYYOs/4olrRXpQ2+e3f72c9
	 YIPRCnPFj4x4tQH7sr+o6CIDO4gm9Ln1bLE9k8do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/241] platform/x86/intel: pmc: fix ltr decode in pmc_core_ltr_show()
Date: Wed, 19 Mar 2025 07:28:55 -0700
Message-ID: <20250319143029.332543849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3e7f99ac8c941..c5dae640a0b2b 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -625,8 +625,8 @@ static u32 convert_ltr_scale(u32 val)
 static int pmc_core_ltr_show(struct seq_file *s, void *unused)
 {
 	struct pmc_dev *pmcdev = s->private;
-	u64 decoded_snoop_ltr, decoded_non_snoop_ltr;
-	u32 ltr_raw_data, scale, val;
+	u64 decoded_snoop_ltr, decoded_non_snoop_ltr, val;
+	u32 ltr_raw_data, scale;
 	u16 snoop_ltr, nonsnoop_ltr;
 	unsigned int i, index, ltr_index = 0;
 
-- 
2.39.5



