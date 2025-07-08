Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA216BE46;
	Tue,  8 Jul 2025 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993667; cv=none; b=oqeHfGOF93lj2Ym7EIiZGDdiLZXFvHbVAW8d0NdQShBUKW8Qn8Y1lVYEmituNqwY1RjO3NAdxfGBjglGWPElpjevX1sWXYoOE+0+vGIJ5q5L/NAkn4iOlHLI1eSXK7d8l8vQmqDwKzaF0vtXVwv89JVMQpoIYPjxI1PKWu1Afe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993667; c=relaxed/simple;
	bh=H+Vh56akS7SyquGghMYyRCpDk0PvMHhP/3bbGMl0qFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHofO71Y7hw3fHgr+ajUAavUd4xWVeOgJIVNca6Fji/QjsnBKM62eucSD44WOmRUptzJHRCbsxYUO/eM505A/m5JympiuRNbeO+7TvswVmX+Q1uudZNYcGFg8W1lD7UzVUr6A99xSkBXImDraecBPzzSfJpiXRTq+bnk1qjnw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZihjsht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZihjsht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3539CC4CEED;
	Tue,  8 Jul 2025 16:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993667;
	bh=H+Vh56akS7SyquGghMYyRCpDk0PvMHhP/3bbGMl0qFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZihjsht0kwBCsg05a7x6bvSYkGG3ET5zMOxtVBE/NcVMfHS/pzRUxDvFHsQhjmH5
	 oritgCEm7LMfMAxjpPt4r2xcrgcotZ73MoF/BwIQFRp6d2COzyBpBoT6tjgbDM/KnI
	 n5MPFSTrzJtc3j1tl7HC7fzcU9kUkIE78foD+Gwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Schneider <johannes.schneider@leica-geosystems.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.15 153/178] usb: dwc3: gadget: Fix TRB reclaim logic for short transfers and ZLPs
Date: Tue,  8 Jul 2025 18:23:10 +0200
Message-ID: <20250708162240.502124374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SCHNEIDER Johannes <johannes.schneider@leica-geosystems.com>

commit 80e08394377559ed5a2ccadd861e62d24b826911 upstream.

Commit 96c7bf8f6b3e ("usb: dwc3: gadget: Cleanup SG handling") updated
the TRB reclaim path to use the TRB CHN (Chain) bit to determine whether
a TRB was part of a chain. However, this inadvertently changed the
behavior of reclaiming the final TRB in some scatter-gather or short
transfer cases.

In particular, if the final TRB did not have the CHN bit set, the
cleanup path could incorrectly skip clearing the HWO (Hardware Own)
bit, leaving stale TRBs in the ring. This resulted in broken data
transfer completions in userspace, notably for MTP over FunctionFS.

Fix this by unconditionally clearing the HWO bit during TRB reclaim,
regardless of the CHN bit state. This restores correct behavior
especially for transfers that require ZLPs or end on non-CHN TRBs.

Fixes: 61440628a4ff ("usb: dwc3: gadget: Cleanup SG handling")
Signed-off-by: Johannes Schneider <johannes.schneider@leica-geosystems.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/AM8PR06MB7521A29A8863C838B54987B6BC7BA@AM8PR06MB7521.eurprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index b6b63b530148..74968f93d4a3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3516,7 +3516,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	 * We're going to do that here to avoid problems of HW trying
 	 * to use bogus TRBs for transfers.
 	 */
-	if (chain && (trb->ctrl & DWC3_TRB_CTRL_HWO))
+	if (trb->ctrl & DWC3_TRB_CTRL_HWO)
 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
 
 	/*
-- 
2.50.0



