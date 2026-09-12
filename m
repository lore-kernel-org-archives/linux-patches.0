Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAEF47ACCA;
	Sat, 12 Sep 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237788; cv=none; b=IKLckcPmrYafXHP6hH0svhRyKxbo4ZNTYxdYgzUGE2n/xdZWHUw8d5zhzOY/dljuvSJTq2DiwK4Wp56jPZzKF4mj3/FBC35PU6dbyaOTKDP9lTvu0RUqi3fSxsPRTOWIUKajYDlYKv9DgO5apT5x+2Dps7+nECoR0UOmaXnVcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237788; c=relaxed/simple;
	bh=aCmVepQowF973B3RFh5TFdRhHrVrwSfLWPpMJ/Ymcoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6Uwht4+Z4Ey5NaAE3mgb7EN8TP+VO2mdqckjphQeeeowHPimvrIM3549kTTZoDsibU+wdcQ8nxiJRun5aYjcBRbOVNvikp4CEP24yzPmOZM0Sr96HCrDy5NGHCgTObdNFQRqCt6DGee9QR9B0OJoV45ViZvm1bxAHsUzks53t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oq0dyUe9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oq0dyUe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1673F1F00893;
	Sat, 12 Sep 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237786;
	bh=cnLxC5qGt0UoC7VK6FR4KUXKnftYU4AWX0hgxdWOYNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oq0dyUe9e4bGtlmtGQ2WrZ2UmoqTVc9FHUQpPukIXOISt+tuleyli7nGSG6tj88Zn
	 L879czKAAWmOu4ExVfdm96PakwrocMv3htzzqj7Gyh28bWI3TZXM4a5EmdhHNLYMvV
	 +m7f5cEUZWR9HsLCJnZhcT2x4AnDK1ENmEzdy29I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 5.15 329/935] media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()
Date: Sat, 12 Sep 2026 08:55:59 +0200
Message-ID: <20260912065534.346673157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


