Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1653264F4;
	Sat, 12 Sep 2026 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228423; cv=none; b=boZvDba3yA/fDpX2Z859D8QUV1t/1JLXx5yFXRqGelPi5TIHcKTmw/yq2GqDXCMx1DR9EfxB/X2OZdIwjUA5cuZ1gZfC4rHzmdkazV1csL3JRQZnu41NoiIJtTRdthtVrepXs/xvukTS29ywtsB6KlRx1x+4rwZVxsoTF6LibCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228423; c=relaxed/simple;
	bh=j5P3X+Ikk73PD2Ck07Q/0O4316nBLzjZeTAWmvlqXjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVvkiqYf46UCgVM0UPVDzEK4ojATVp9VleJhVKr6sCFEzAGzRsr8DmSNsOl9R6CMe03Ka4k4xvupJL5TzNsnpzCqNUksvxhDFH/7TfgZXecBnSnqUlrWeYJ3YmD6O7GRXZE6t4q2NlvsKPRp61OqrBV2Uc/UD8f/siTBEVLjEHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpguWkI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpguWkI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417481F000FF;
	Sat, 12 Sep 2026 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228422;
	bh=ueFMzwetPOAxGoUFaQzhrNnEYy48Yp1NOfpRA+vjqRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpguWkI41iyMYe9J5Z2qq1yf3JP2A/6GA51cIJ2UEcNVgIuLjBkqzhH1Z/mGVOEjt
	 7ZIEMJDWqMyOhJQih2k7mIVIPTewbOkssgti0t89XAIeRU6y6Sl7LRMbXrZxWPHvrk
	 Eh8cs6W3/yfwHcAH1UJkhBW5rVM8QWVT2SUhHvic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.1 0383/1191] media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()
Date: Sat, 12 Sep 2026 08:51:51 +0200
Message-ID: <20260912065556.842674839@linuxfoundation.org>
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

commit a51cea23e409278f6e2ea072280aba93cc1dd75e upstream.

parse_caps() and parse_alloc_mode() return only the size of their fixed
header fields, excluding the flexible array payload. hfi_parser() uses
this return value to advance through the firmware response buffer, so
underreporting causes parser desynchronization.

Return the full consumed size (header + entries), matching the correct
pattern used by parse_profile_level().

Fixes: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Cc: stable@vger.kernel.org
Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -85,7 +85,7 @@ parse_alloc_mode(struct venus_core *core
 		type++;
 	}
 
-	return sizeof(*mode);
+	return mode->num_entries * sizeof(u32) + sizeof(*mode);
 }
 
 static void fill_profile_level(struct hfi_plat_caps *cap, const void *data,
@@ -146,7 +146,7 @@ parse_caps(struct venus_core *core, u32
 	for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain,
 		       fill_caps, caps_arr, num_caps);
 
-	return sizeof(*caps);
+	return num_caps * sizeof(*cap) + sizeof(u32);
 }
 
 static void fill_raw_fmts(struct hfi_plat_caps *cap, const void *fmts,


