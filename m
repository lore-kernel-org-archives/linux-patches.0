Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12563FD956;
	Sat, 12 Sep 2026 15:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228427; cv=none; b=Ea8rxxLzjbcqGOQV3jMtblhnQKbfW1jNg0q4HQnyYpnd3Nd3BClbrTqz0TIjo1ZCAcy4g+FHL1LH0W0nnftf21sJpUnXyQ10ULgoNfuenYFNIX+PMBSawG3Fmt2PolDda5AMI2/n9IRoZeFYGzFbCnOS1zNshuzeQE4qHefSe48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228427; c=relaxed/simple;
	bh=urlmxDI2aqBoFAGU0AkQP7fQlo3lYXX6k07K2P60MWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKG0E5+5RV8XUhAKCMCzOV/45PdX9bom101y5sFUthnGZxRYiB7ZyWvTktN4Pi3addAHq6AG9xkN9n+0rb+x3BRZbOUwXeZIB1aj4z3mJOWJLUyboFaoj1TyJahMeLy5l6Cn9oBqAb6xRjfPwzHRO8dDjvBLG/6TP7ePfVTl/lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5IvIgVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5IvIgVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE28F1F000FF;
	Sat, 12 Sep 2026 15:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228426;
	bh=Q4FnjU167XKyDbRRU6cNAZNyGQhCwVZQeEBR8E0atsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5IvIgVduvjMgSfef6e2QaJZO0rSznRYTVxF2V0l3MZ31hiuGh708/T1cIUw1Uzhd
	 5wUDmJnJ6yupOL/IknYsfc/EBFz3C9v1obGYR4qgnf3lPRd1endwwKuBk0lZWyNixP
	 3/t7ZR8UbR7J20rbP2D5gD61qSXNSvRuIMOWu30w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.1 0384/1191] media: venus: fix payload size calculation in parse_raw_formats()
Date: Sat, 12 Sep 2026 08:51:52 +0200
Message-ID: <20260912065556.864696804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


