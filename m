Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E639393DC5;
	Tue, 16 Dec 2025 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888088; cv=none; b=VDKoLUkzdEQMI6VVjUK3Qtlbo0BqAZLa8IErmdPuISoMyO+6BJSIGEykhCPpGltGk3obTGv7HVbAbcgjmC23jzTSktKiG07885ne92c0fP4c2xzzdIAXmHmIucrY7krcbCE4YE7qrs0BuvbWAOavqlZTiR7O0eyk2d1NdEyUmmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888088; c=relaxed/simple;
	bh=Kolbi0F/hwU2Sh2aDHXG+0/g7gZRjThHcPV0GbvxeQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCvhNw6sMcqtN+LR5uj4PPcDgIT7OjQf+bmi91Hpy2hAF712WEW809XtH8cbiWZt4+kwDmR3jjK8DCXRTKnzsXACh+ev0poDZvVa5hGnQWR71BtRJbgzncpIbCH+9A3eTB3C/5vR+aIrJY2zoALeD0etIiignaxcruY726ZacGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR/RuSgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR/RuSgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013B5C4CEF1;
	Tue, 16 Dec 2025 12:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888088;
	bh=Kolbi0F/hwU2Sh2aDHXG+0/g7gZRjThHcPV0GbvxeQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GR/RuSgEcStbAXOGCsWwpZ/5If2gvkaayw4lktADMnMIfxnYjDMthr1n5PuCGz/tw
	 o/MTM7N3mDaN1NpvzBUfKXd02p/KtgMwTVL7j/GYIjglaQFbErSNzB+1B+KD57mgvp
	 DVT8VMQSkUAxFJDllsV0yV3vtSGTcHVFF2hdv24w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijun Wang <jijun.wang@intel.com>,
	Jay Bhat <jay.bhat@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 429/614] RDMA/irdma: Fix SRQ shadow area address initialization
Date: Tue, 16 Dec 2025 12:13:16 +0100
Message-ID: <20251216111416.918770056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jijun Wang <jijun.wang@intel.com>

[ Upstream commit 01dad9ca37c60d08f71e2ef639875ae895deede6 ]

Fix SRQ shadow area address initialization.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Jijun Wang <jijun.wang@intel.com>
Signed-off-by: Jay Bhat <jay.bhat@intel.com>
Link: https://patch.msgid.link/20251125025350.180-10-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index afccd9f08b8a5..b8655504da290 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2307,8 +2307,8 @@ static int irdma_setup_kmode_srq(struct irdma_device *iwdev,
 	ukinfo->srq_size = depth >> shift;
 	ukinfo->shadow_area = mem->va + ring_size;
 
-	info->shadow_area_pa = info->srq_pa + ring_size;
 	info->srq_pa = mem->pa;
+	info->shadow_area_pa = info->srq_pa + ring_size;
 
 	return 0;
 }
-- 
2.51.0



