Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6E569F1A;
	Wed,  9 Sep 2026 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962755; cv=none; b=QBsadePgYUAyKpylEXXYzhLoo1oyCPKMDjqlqCHybGkrvorp54v8nCm3NnNfiU71KFMSJxuZaUrZ5I9Q3g2KGS5jVj10r2k/XL7XsgTNb/rFSg11W4V583Dn7t2RHjFJXmtGVzwXglfS8xNWe/4QuVqAIM04hZalZ9aS6lNtKJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962755; c=relaxed/simple;
	bh=xKbeW8ctw359ZOvFks8iTzGIjz/BgfXflYUxaJd2MaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu8yzleZc6/u8RYon0bFevy0f93Uitf93EbN5Ajc7mubqgVCLkF4k+Q3iSKaoSTfLiqn5b6pWjWaOIVHnD9/6+ytwpubuckwydtdVl8EOs1XWkDhwnF1bDN4Esd+MtcODVmN1YxzKw9i0y852bqZ2KbFiCFpNRcTw3uXk4Teq5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGavF3AO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGavF3AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8DD1F00A3A;
	Wed,  9 Sep 2026 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962754;
	bh=pCclrtC0z1eY+7kf717lfn5T/AX7Cye7mKWAHI34g7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGavF3AOITwz6uHKEXBKpRIdVPKqcRioAIXWCndP9nVjrZHb4MXcVbkbTE7q+9u9o
	 wS7g0ois0paI5VvtG+ILPszof5zLTECSVUC+zYt6r3vI707oafsmL8MJ8s7jaQZEoT
	 6qWASztRpvyJtwWg0yFfp6MS0r5+czduifnjY+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.2 401/556] media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()
Date: Wed,  9 Sep 2026 15:41:21 +0200
Message-ID: <20260909134244.741253152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


