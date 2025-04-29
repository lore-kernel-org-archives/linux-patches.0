Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C328B21772B;
	Tue, 29 Apr 2025 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945479; cv=none; b=sprnHdjhGfmx8oFid3MpOsc+lL0SLBI6ii4UMTDDeYo3lpDT56J2uYMMAljIpFBeszvlBffVk0Ey9OplHsD/zM6QtTGAiBlDASaLHf16t9FBoc8OhWo8LRjp3tE/KNhSvijleoikueyg1oEV5cCjYA4EsnQ/xHK4PM3ZKt7MLJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945479; c=relaxed/simple;
	bh=j5dSkBa4fDDhOg67A4Nbrr4eJV0BfxYkUAsorEZBM1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSNxcBWr7X3GpWWyYDzBfoUybcrmV+bJx8wdKxBGmNte5LDzsY11930BReAyGm2uVOiOoZ5t8BnVSTWQBPZz8ZPKq3bHQS1zp+iY+8u9tihTl3x8PpxX2ztjy/IU5oRx+OGIrSdA6pH5z+zXtxLW+lrLxLKzIWkP0oVmnaE7WmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwMaDMWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwMaDMWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E724C4CEE3;
	Tue, 29 Apr 2025 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945479;
	bh=j5dSkBa4fDDhOg67A4Nbrr4eJV0BfxYkUAsorEZBM1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwMaDMWqpFLw+qLV2Hk5SkY12OAHuZR9qT8hUdkbpanseWaZITIEei2923KOQqaSg
	 DhFBWp5cq57Z2V1RpPNmIRn2Q4A84DoXKcmpVGI0/BmnvmfAMLDyjNQvMD/OR6a7wK
	 ++XTiGCARYtfGd+4tRylTdzxvDu0JIkPTyCR9Xso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/179] platform/x86: ISST: Correct command storage data length
Date: Tue, 29 Apr 2025 18:41:08 +0200
Message-ID: <20250429161054.531091730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 9462e74c5c983cce34019bfb27f734552bebe59f ]

After resume/online turbo limit ratio (TRL) is restored partially if
the admin explicitly changed TRL from user space.

A hash table is used to store SST mail box and MSR settings when modified
to restore those settings after resume or online. This uses a struct
isst_cmd field "data" to store these settings. This is a 64 bit field.
But isst_store_new_cmd() is only assigning as u32. This results in
truncation of 32 bits.

Change the argument to u64 from u32.

Fixes: f607874f35cb ("platform/x86: ISST: Restore state on resume")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250328224749.2691272-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_speed_select_if/isst_if_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
index cf7b6dee82191..d561e49741ba3 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
@@ -74,7 +74,7 @@ static DECLARE_HASHTABLE(isst_hash, 8);
 static DEFINE_MUTEX(isst_hash_lock);
 
 static int isst_store_new_cmd(int cmd, u32 cpu, int mbox_cmd_type, u32 param,
-			      u32 data)
+			      u64 data)
 {
 	struct isst_cmd *sst_cmd;
 
-- 
2.39.5



