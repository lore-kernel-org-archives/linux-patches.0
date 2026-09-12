Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DF334887E;
	Sat, 12 Sep 2026 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221868; cv=none; b=MJ64GKiydeGdQ2lBLOWwZxGHEBnnR3r554UASB27NLVLlqqM69tIDpKgN6tiJXLX5DX4iEtESoBQAg8gwNiqozxMAoEYRMeoEVmqanZSPMPl8dHutgK3PFz/MdnHzA82oxZh/97C1KnddwCK2sM1rQ12H6p1aiYi3LUC6uicUNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221868; c=relaxed/simple;
	bh=lkXa4o4XD3igDcKEShOIuLdl+AqbKLvdMNb5PKGtc2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoJdCGAIbPH2Jv9Lse+XWkSvTlL1M/RHFCnNnbgzgwwljMQKefWOgQc1rNktfuUPmGma8D4NqLkj7ANTO9mL++wZY1oURD5bJgVPctHe/p+i43TO4CAh5cqBWXQCI7L3iI5nnK1bwX9FZJo0tLIy8UMDkwpHFajH13g2HS+zE0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgNC5oEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgNC5oEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14AA1F00893;
	Sat, 12 Sep 2026 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221865;
	bh=dY3uYLQ8pRK8nwKHpEleKuQrKjoKoHAl3KQeXt09tkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgNC5oEJY7x9wxdhBnOBaXCj8vDxGrE8brAe5EPZi69TRfUYY9AmbwE5ubQBsSw3l
	 Aun5881id+rcDeToLq+4H059Sos3hFhN4XQumxtsVNek1W+dHykSOm5sSJkM7pJFJ8
	 x2hcHHc2ZdW1QoFVldct4KhkDELavDyzULKiTA9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.6 0469/1424] media: venus: fix payload size calculation in parse_raw_formats()
Date: Sat, 12 Sep 2026 08:48:21 +0200
Message-ID: <20260912065617.791652993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Mohammed EL Kadiri <med08elkadiri@gmail.com>

commit bd595b745eb770e80347c31ffc25351046935305 upstream.

The consumed size is computed after the loop using the num_planes value
from the last iteration for all entries. When entries have different
plane counts, this produces an incorrect total.

Accumulate the actual size during the loop instead.

Fixes: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Cc: stable@vger.kernel.org
Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -171,7 +171,7 @@ parse_raw_formats(struct venus_core *cor
 	u32 entries = fmt->format_entries;
 	unsigned int i = 0;
 	u32 num_planes = 0;
-	u32 size;
+	u32 size = 2 * sizeof(u32);
 
 	while (entries) {
 		num_planes = pinfo->num_planes;
@@ -186,6 +186,7 @@ parse_raw_formats(struct venus_core *cor
 		if (pinfo->num_planes > MAX_PLANES)
 			break;
 
+		size += sizeof(*constr) * num_planes + 2 * sizeof(u32);
 		pinfo = (void *)pinfo + sizeof(*constr) * num_planes +
 			2 * sizeof(u32);
 		entries--;
@@ -193,8 +194,6 @@ parse_raw_formats(struct venus_core *cor
 
 	for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain,
 		       fill_raw_fmts, rawfmts, i);
-	size = fmt->format_entries * (sizeof(*constr) * num_planes + 2 * sizeof(u32))
-		+ 2 * sizeof(u32);
 
 	return size;
 }


