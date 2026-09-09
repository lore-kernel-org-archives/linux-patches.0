Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C7C582BB1;
	Wed,  9 Sep 2026 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964128; cv=none; b=ObyOhCjhtUM5jH6tRcfkIwAXmj/TQMoUD3NK/jhMolgNF0EDYl+97Tic+LQUNOHZpfcuLVK+xbAEJ7n3nR3P40Gf9jc8YRDl19ko5o18qeC1LANBYmVCPgPDNgBtE3EycA1VMRQHGb8x8k1NBfdI4JlF53ktq0U/F+4bz/0k3Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964128; c=relaxed/simple;
	bh=JXd7hNFLxMXR6alf/Mwuu1+RSDUR9dh8Rayqci/9HK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZPx0yf8ngHIfP90R/ykhHjDQgyyHlPV7GG+x6IeefSCD3UC8qPGAlh1h1HH5lXA4gj8UaIme+fNXdWosHWpjyp2AROoSD4lUtOqsJ68rUg/nr/38+C42mO4VpXA1zPPpNl8YRurk39La/KS1V+2ccwQJ4SUcFs15nKpGC9B3+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEEmEfyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEEmEfyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CF21F00A3D;
	Wed,  9 Sep 2026 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964127;
	bh=gVPqMocGbl1+n6hLmI88QqCtC3ZjTnAYYJXnp17AAfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEEmEfyLUGjqa9AOlEBSyP3Dcfj01J6xOTScSDADdCCvB7dXlft+oQvcSdiwduGgr
	 l5oaZ4uMCKZiyjv62yMrkSxe3h9liPLvfgQBsE8+vywds6mXe3BAjnGtrtTwSHC739
	 ry9YMG7xenIreqU58yw4lFpLvPi0RP5gm0zr6OCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 314/583] media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()
Date: Wed,  9 Sep 2026 15:39:59 +0200
Message-ID: <20260909134248.882147659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


