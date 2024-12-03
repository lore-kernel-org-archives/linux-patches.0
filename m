Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83D11F75B6;
	Tue,  3 Dec 2024 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240038; cv=none; b=QVx/77Ts0Pp1rzIhaNNjtWrFQox3UcqYUKeynK8uldsaFdk4KhthuVoKwe07eKsvdBjwf2C4H32zO9eRkc161koT6hisW71sLK1hA9VQ3H27qk9yND8FR4FKYFLx8zjSSDt4prQ5Dxq2s/4Pmx7b2+uX7LfYuNYs+0Pcqn0JE8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240038; c=relaxed/simple;
	bh=uJyb7gxqXkIZELQNYCRxul568AnVmgd+vS8EKZ/sApg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plQOJpoDQREBIGow3F1jTCkJPkgwt3y3MCzNFWxIcLYVDnTundg5P4DmhCAciG+DIH6cwcvNEYHbs7P9VIwkLNcdi7+ZNhLb1CGkRyL+PvxDvOcFKaztCCsk0vD/wF9pniKQ8vbH3Ov2lMpwUrZ024GWjJBMD7za2Tm3JAMf+s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUtaskQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUtaskQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3079CC4CECF;
	Tue,  3 Dec 2024 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240038;
	bh=uJyb7gxqXkIZELQNYCRxul568AnVmgd+vS8EKZ/sApg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUtaskQoBsZUO1+b6HOMZ+zRrj4DlORhic94H+QrLC49FI+aGwT/EyNl/YDQnAccx
	 AQ5z71x8Lf08gWXCxSe5CL8kocEXjWA5Q5Q1AuXtvYld5yYMaOLp3OBhPpamU/S0Gl
	 CX+inGLzTjTpqDPXxv0Qt6SMtWr4hBJUz36tQo9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 813/817] sh: intc: Fix use-after-free bug in register_intc_controller()
Date: Tue,  3 Dec 2024 15:46:25 +0100
Message-ID: <20241203144028.189056375@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 63e72e551942642c48456a4134975136cdcb9b3c ]

In the error handling for this function, d is freed without ever
removing it from intc_list which would lead to a use after free.
To fix this, let's only add it to the list after everything has
succeeded.

Fixes: 2dcec7a988a1 ("sh: intc: set_irq_wake() support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/intc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 74350b5871dc8..ea571eeb30787 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -209,7 +209,6 @@ int __init register_intc_controller(struct intc_desc *desc)
 		goto err0;
 
 	INIT_LIST_HEAD(&d->list);
-	list_add_tail(&d->list, &intc_list);
 
 	raw_spin_lock_init(&d->lock);
 	INIT_RADIX_TREE(&d->tree, GFP_ATOMIC);
@@ -369,6 +368,7 @@ int __init register_intc_controller(struct intc_desc *desc)
 
 	d->skip_suspend = desc->skip_syscore_suspend;
 
+	list_add_tail(&d->list, &intc_list);
 	nr_intc_controllers++;
 
 	return 0;
-- 
2.43.0



