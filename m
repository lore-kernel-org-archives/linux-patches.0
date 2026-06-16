Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BFC47277E;
	Tue, 16 Jun 2026 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627528; cv=none; b=r40TOLaFjm1tszdLr6SSovhMzybnXGc3xrdvf7GkAJO3oef7G/RGx7SBpfSyKFMN8LG53nDTaec38s05dHsXQRZpF8++3JDVZXPd0SNvzN1LGbMwV0ARNDjo7bhLGC3z0s/YV2c6oRbXReTH3GQAJf3Q8TZ2Ezf6NxklHgK1Z8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627528; c=relaxed/simple;
	bh=TPkkCC5YpA6kSYnyj3X3RB/qw7/U+k0UNdiyz1AjDzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvFBkglTlh+RJc5wfUuj+hW/RkEN0ECg10UM2/Jd8ro5yFWZioKQGL7l0REG7sZoU9pYzXYKdcmptBqS/NqSOi2bcvU77KBW/0k/OccN8/KuE1htpopAem9+xVCTfG7NdfbJb9LRMaX5FXy/u618YyfuOVt5CVO3S2sDCzF88RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiwGzVje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiwGzVje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CC21F000E9;
	Tue, 16 Jun 2026 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627526;
	bh=2wl4gGbef52BFqaZpyVDLRr6sNc4chrGIaWBUx/IIfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiwGzVje9Esw1HVJUxEEBHSlfMGUhwOIW8RkdrWnTM4sOWHa2X8m2dEBmfL8DCh9e
	 QTistRPQeBLrXvkVcri1wNiu+dj+wJ146nKzk19C2zo1ajNn0WYyOhFD+mvtU0Rze6
	 On/hOQRWY4M6YjD25nfF+OtiOJRcQslPKCeK+H1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 188/261] octeontx2-af: fix memory leak in rvu_setup_hw_resources()
Date: Tue, 16 Jun 2026 20:30:26 +0530
Message-ID: <20260616145053.778071363@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 09a5bf856aa759513afc4afd233d15bcc711b84e upstream.

If rvu_npc_exact_init() fails in rvu_setup_hw_resources(), the function
returns directly instead of jumping to the error handling path. This
causes a resource leak for the previously initialized CGX, NPC, fwdata,
and MSI-X states.

Fix this by replacing the direct return with goto cgx_err to ensure
proper cleanup.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have
access to Marvell OcteonTX2 RVU AF hardware to test with, no runtime
testing was able to be performed.

Fixes: 3571fe07a090 ("octeontx2-af: Drop rules for NPC MCAM")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260604143756.1524482-1-dawei.feng@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1135,7 +1135,7 @@ cpt:
 	err = rvu_npc_exact_init(rvu);
 	if (err) {
 		dev_err(rvu->dev, "failed to initialize exact match table\n");
-		return err;
+		goto cgx_err;
 	}
 
 	/* Assign MACs for CGX mapped functions */


