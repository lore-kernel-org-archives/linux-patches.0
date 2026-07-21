Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892743B6C17;
	Tue, 21 Jul 2026 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673728; cv=none; b=Yt2V62SGLdLernqqHFsnn25+MYQVtzzVqIQ7CkSqWIfIQT9BHCZ5wMZwD81S4mO3UxeV+o9TBu5VgXrLraAfDRIjd97nkkg2cIGmPz/2HNxlpxcCb5q1UyylJr5J+e1EPEtrSpxnQCl+y41fpjEq93l2DdIh8Ja0SJJaj/JvQ3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673728; c=relaxed/simple;
	bh=IFnbiG7Z+0NmCfvLe20iKT1p958DfvjYcoF7PXw5Z2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itp7hCxrtp5BMgTZsz8dgTy5t03ynt5wQ88laHkW/A75gP3rCxKo5QBLtFucbVlrF4PxLGdOC+4reDDVt/hyLmDScx/mVx+a0X6UiYxFaJt47sgzkhenmlQwKZz8gra9vbSTfg/eOfn6wDnUtohWfjybRAX++R6Wsr0yoVgYOCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSN2wpTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSN2wpTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED86C1F000E9;
	Tue, 21 Jul 2026 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673727;
	bh=2bY4C+vEiZsoGEWJNnry1c8H2iTaZfPtJkFsEH/uvPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSN2wpTr1z1FP3Jb1hujoJJxWV5pHKDYKyWozuHxgBao57uUkcXsELaDRx8AUL8uL
	 8X8Z9Xlk7tCmOWavlpZMS/2II4uJwgoDMVXdP63RvRNLGVND0FhgyOfMU7pfeOFUwv
	 3AuiWIIxPqLZ9MBMTkb+J0S3xaCaWLzCFZhPwAbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/699] ARM: imx3: Fix CCM node reference leak
Date: Tue, 21 Jul 2026 17:19:38 +0200
Message-ID: <20260721152400.641595928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 36d46348eb5fc4bc505cd2290ddd70c25fbe6bb3 ]

of_find_compatible_node() returns a referenced device node. The i.MX31
and i.MX35 early init paths use the node to map the CCM registers with
of_iomap(), but never drop the node reference.

Release the node after the mapping is created.

Fixes: 2cf98d12958c ("ARM: imx3: Retrieve the CCM base address from devicetree")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mm-imx3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 5056438e5b4276..02d056ff73e63c 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -107,6 +107,7 @@ void __init imx31_init_early(void)
 	arm_pm_idle = imx31_idle;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 
@@ -156,6 +157,7 @@ void __init imx35_init_early(void)
 	arch_ioremap_caller = imx3_ioremap_caller;
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-ccm");
 	mx3_ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!mx3_ccm_base);
 }
 
-- 
2.53.0



