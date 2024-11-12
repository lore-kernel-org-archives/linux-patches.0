Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AE220D54;
	Tue, 12 Nov 2024 10:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407834; cv=none; b=YOAz5Srnk8xUsBXd0HhKJ+q2ghMbk4AHGqfQzcPmXWck6kLDkArwkpR9DeONqYuZziIVMK98htq9/t6nKXoofbo8u9IuGDlboyVCmSN8xMfhgFx3A+j4qW1FeME19iYVRrV3YE+2PD7CcVCQ6ANg97akCVTELvgzdkFWIWKYbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407834; c=relaxed/simple;
	bh=xZMxm2YKqABZsmCuuVs50FsD/hFLaefkUp665AOJEPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoITBu6aDwedQL9LL5XfY+zaJ0++cYtVxgs8GC0b5h4juuZejiwU/TydUG6xYEsxxx5wx5vqsLfWg/m2s4mopbJqOc4lOVhCkqTO0hAy8HZnmOuc2X7jh00uJanriQD9JQQ2Mtm9ar1LfW1eGGL16jJF2ZXYPYwzafmcAnycKpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcnEBBCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcnEBBCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851F2C4CECD;
	Tue, 12 Nov 2024 10:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407833;
	bh=xZMxm2YKqABZsmCuuVs50FsD/hFLaefkUp665AOJEPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcnEBBCitIASfKSsVQdagscTbcJMDdznb/HWpZnrDajlc+z2Katnhq8l/KfK01Jxq
	 ab2eLcG0hJJuyKZkI2U65tPo0s+8Y13VFBxqtpJSLj05nCZN0pDW9jtQg0wIyRkRX0
	 rVoV3e9+qbRhAUoJarGsuYSmgdQNxPzo31uZKcZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 065/119] media: v4l2-tpg: prevent the risk of a division by zero
Date: Tue, 12 Nov 2024 11:21:13 +0100
Message-ID: <20241112101851.197219438@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit e6a3ea83fbe15d4818d01804e904cbb0e64e543b upstream.

As reported by Coverity, the logic at tpg_precalculate_line()
blindly rescales the buffer even when scaled_witdh is equal to
zero. If this ever happens, this will cause a division by zero.

Instead, add a WARN_ON_ONCE() to trigger such cases and return
without doing any precalculation.

Fixes: 63881df94d3e ("[media] vivid: add the Test Pattern Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1795,6 +1795,9 @@ static void tpg_precalculate_line(struct
 	unsigned p;
 	unsigned x;
 
+	if (WARN_ON_ONCE(!tpg->src_width || !tpg->scaled_width))
+		return;
+
 	switch (tpg->pattern) {
 	case TPG_PAT_GREEN:
 		contrast = TPG_COLOR_100_RED;


