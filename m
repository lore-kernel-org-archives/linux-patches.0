Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62D52459C9;
	Tue, 29 Apr 2025 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947462; cv=none; b=J1i+yxJbSARxoNrrPsgpIrWctdIUrVGm6IilkdbWsXk4ckZqxPPMz9Wspm69RCUtaFat8Xqyb7S5qc40jn899wcsvJuqZVvg4mVOGGzY1o7QKNIw8b6QnS32PVTftMOamKAFWnPp6bwvUXgdDTqb+95rPIH1qiOEab6F49RTZ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947462; c=relaxed/simple;
	bh=cb3dh8Q/ZTRURCAvl0rl9ygtRu0SNR48IJiYP63VGFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc3H+BizqwLPz5KFPKGraVvH5rQ56TJ2wu189DDXuxTkRvAq9quVghP/NgZGYNJR2/InoOAjJH1D6uyUd9NEH7eEOZATVjP5PRdzd1Ho66Uf+FFahLaL+LFsyair5XdeTz2c/4SIboblcqPLHpys6jaV7pqeyuNPjYiSkDiKPPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWA6jYCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWA6jYCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363A8C4CEE3;
	Tue, 29 Apr 2025 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947462;
	bh=cb3dh8Q/ZTRURCAvl0rl9ygtRu0SNR48IJiYP63VGFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWA6jYCSlldovWQynuLpZD9pjG5TDWYnNEcwN0xTWLXutyb8UgEDZjqkrH5QBGMhd
	 qZW8bLmick7AT4LJptI35i1kgEsMFmXNsPBRioRZD3GZpBDr156hrDaWb7Fsx6xBAv
	 a9Vnnc/5EWp9RHK4zfVmM2PvBqQ7U4PMZAJBu7a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Jiang <dave.jiang@intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/286] ntb: reduce stack usage in idt_scan_mws
Date: Tue, 29 Apr 2025 18:42:46 +0200
Message-ID: <20250429161118.692638072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit aff12700b8dd7422bfe2277696e192af4df9de8f ]

idt_scan_mws() puts a large fixed-size array on the stack and copies
it into a smaller dynamically allocated array at the end. On 32-bit
targets, the fixed size can easily exceed the warning limit for
possible stack overflow:

drivers/ntb/hw/idt/ntb_hw_idt.c:1041:27: error: stack frame size (1032) exceeds limit (1024) in 'idt_scan_mws' [-Werror,-Wframe-larger-than]

Change it to instead just always use dynamic allocation for the
array from the start. It's too big for the stack, but not actually
all that much for a permanent allocation.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202205111109.PiKTruEj-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/idt/ntb_hw_idt.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/ntb/hw/idt/ntb_hw_idt.c b/drivers/ntb/hw/idt/ntb_hw_idt.c
index 99711dd0b6e8e..d39fc55f8b0cc 100644
--- a/drivers/ntb/hw/idt/ntb_hw_idt.c
+++ b/drivers/ntb/hw/idt/ntb_hw_idt.c
@@ -1041,7 +1041,7 @@ static inline char *idt_get_mw_name(enum idt_mw_type mw_type)
 static struct idt_mw_cfg *idt_scan_mws(struct idt_ntb_dev *ndev, int port,
 				       unsigned char *mw_cnt)
 {
-	struct idt_mw_cfg mws[IDT_MAX_NR_MWS], *ret_mws;
+	struct idt_mw_cfg *mws;
 	const struct idt_ntb_bar *bars;
 	enum idt_mw_type mw_type;
 	unsigned char widx, bidx, en_cnt;
@@ -1049,6 +1049,11 @@ static struct idt_mw_cfg *idt_scan_mws(struct idt_ntb_dev *ndev, int port,
 	int aprt_size;
 	u32 data;
 
+	mws = devm_kcalloc(&ndev->ntb.pdev->dev, IDT_MAX_NR_MWS,
+			   sizeof(*mws), GFP_KERNEL);
+	if (!mws)
+		return ERR_PTR(-ENOMEM);
+
 	/* Retrieve the array of the BARs registers */
 	bars = portdata_tbl[port].bars;
 
@@ -1103,16 +1108,7 @@ static struct idt_mw_cfg *idt_scan_mws(struct idt_ntb_dev *ndev, int port,
 		}
 	}
 
-	/* Allocate memory for memory window descriptors */
-	ret_mws = devm_kcalloc(&ndev->ntb.pdev->dev, *mw_cnt, sizeof(*ret_mws),
-			       GFP_KERNEL);
-	if (!ret_mws)
-		return ERR_PTR(-ENOMEM);
-
-	/* Copy the info of detected memory windows */
-	memcpy(ret_mws, mws, (*mw_cnt)*sizeof(*ret_mws));
-
-	return ret_mws;
+	return mws;
 }
 
 /*
-- 
2.39.5



