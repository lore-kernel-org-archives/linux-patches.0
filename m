Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02BD1C7019;
	Wed, 19 Feb 2025 09:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956451; cv=none; b=RSJTblqx0yg2sUFq+bRqTmb8qbuf+yrdLInEVIHaN70munBtOeAG+qR9pxpTurb0kbnGEBbnjXnG7eBcZJYBPHDb1s0hA62sEfY1BRAvXZUJ5qdrNNAvAoh/+mu1kJWJR5Fwdtns5ACnrazjIXDfxcxTYfFDiJBMlGVaEawnDro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956451; c=relaxed/simple;
	bh=R8pHwj52zCvnYapysKLA774BPC48/yChw4Xh6cWdCIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBdGVOthMwcFxS28gm2rAtXUAhlmCYHEyijz7+Rr+Qy84BnV6HQOEPQQanvu4zu/cMuULbGrXd5K2Vge6cjXZrJNFb+5o+OKJEK/NhsK2z2cHsCSkXtQ7koBCqvcXF4zQUKBacOVpM7baemDmm9/iKXGFTn50QS8VNS4YBsPeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OotIqVVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OotIqVVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA453C4CED1;
	Wed, 19 Feb 2025 09:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956451;
	bh=R8pHwj52zCvnYapysKLA774BPC48/yChw4Xh6cWdCIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OotIqVVndERgnhp0lilU+0/oQ73TDJ2vak0GYJJcxZ+lZdOwLy3oWziMs7uiESW6M
	 r550Kf4K2CIktD35B6PMW2ITejmZ/Ua+sEy94LJKkKKvlM3P9Imizg/lEgCCiCtWnC
	 a5ERQWlh8MyhpYJLOA+LPY9UPvabIzUmbh/ITPb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/578] RDMA/srp: Fix error handling in srp_add_port
Date: Wed, 19 Feb 2025 09:22:34 +0100
Message-ID: <20250219082658.878299137@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit a3cbf68c69611188cd304229e346bffdabfd4277 ]

As comment of device_add() says, if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count.

Add a put_device() call before returning from the function to decrement
reference count for cleanup.

Found by code review.

Fixes: c8e4c2397655 ("RDMA/srp: Rework the srp_add_port() error path")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20241217075538.2909996-1-make_ruc2021@163.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c4dcef76e9646..8df23ab974c16 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3983,7 +3983,6 @@ static struct srp_host *srp_add_port(struct srp_device *device, u32 port)
 	return host;
 
 put_host:
-	device_del(&host->dev);
 	put_device(&host->dev);
 	return NULL;
 }
-- 
2.39.5



