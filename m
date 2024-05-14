Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E0130A47;
	Tue, 14 May 2024 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682626; cv=none; b=a8rvipIrrYCaYK+peYmDH0qG48acY4TlvRkvmgPyi/3Nl2MXwAaVme4NX9lTegciXDo6vnlL/xVoFzZC/qGqAML7+zwp0g/f/3qYkfpZ+S2sYjDFTAYKvbPTX22k8F0qentZ2RZ9JCmHaa6tDJJiCVZUKU+WsFpQMf/LqVOkjYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682626; c=relaxed/simple;
	bh=3/s2i8o6Jw2YTyrBPW2yH8a4HI6r8ZuJlB/m437R1iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWHlztwxMmO2H5ej9RHm066xt7/cWLRu+faDJxPnFT65KBK2C3TiRwjk4DxaBbcw0LPzsiZMq5hWzHkxVZiu6uVGmbx+INiog0x2bk/Va0+RqY3QStAKOJLAVA6hbIjAhfqKTX8jCEoPhP1l/mvkykuo2PxrZnGrSocbBPUmcYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nefyon8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nefyon8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F95FC2BD10;
	Tue, 14 May 2024 10:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682625;
	bh=3/s2i8o6Jw2YTyrBPW2yH8a4HI6r8ZuJlB/m437R1iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nefyon8exRfhmJWGc6OXdBL7lpHJWGG4YQN6xpcdiEi2SCCH9KC55BJ+CGs/yY2R0
	 btJQbzxAf+L23lfMSiDN4oBt5O0SCCuDYiGjimTlojascP/YcLVkNAuCeoAuCaOfxz
	 SUQ752CSPkQZ8JH5byXAdGQF7JGCkIPkBvk5Y6C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 091/336] EDAC/versal: Do not log total error counts
Date: Tue, 14 May 2024 12:14:55 +0200
Message-ID: <20240514101042.041815204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 1a24733e80771d8eef656e515306a560519856a9 ]

When logging errors, the driver currently logs the total error count.
However, it should log the current error only. Fix it.

  [ bp: Rewrite text. ]

Fixes: 6f15b178cd63 ("EDAC/versal: Add a Xilinx Versal memory controller driver")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240425121942.26378-4-shubhrajyoti.datta@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/versal_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/versal_edac.c b/drivers/edac/versal_edac.c
index 62caf454b5670..a840c6922e5b9 100644
--- a/drivers/edac/versal_edac.c
+++ b/drivers/edac/versal_edac.c
@@ -423,7 +423,7 @@ static void handle_error(struct mem_ctl_info *mci, struct ecc_status *stat)
 			 convert_to_physical(priv, pinf), pinf.burstpos);
 
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
-				     priv->ce_cnt, 0, 0, 0, 0, 0, -1,
+				     1, 0, 0, 0, 0, 0, -1,
 				     priv->message, "");
 	}
 
@@ -436,7 +436,7 @@ static void handle_error(struct mem_ctl_info *mci, struct ecc_status *stat)
 			 convert_to_physical(priv, pinf), pinf.burstpos);
 
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
-				     priv->ue_cnt, 0, 0, 0, 0, 0, -1,
+				     1, 0, 0, 0, 0, 0, -1,
 				     priv->message, "");
 	}
 
-- 
2.43.0



