Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062927;
	b=X5k/bzX0LX94dT52TQrQtd3lyudil4l3M3mqgQSr8ueLe9BaEFcioIAhhA3FIi2f95Q1
	 tTH3DHyTXQvOoAdvOE74vJUtvU5b2/NNgiw3fl0ds1q0Dz3Ki3mYGeW560fOq6yR39l2V
	 otdynW3eWSdOHl/qoNOggKJLGAEoQBYiyWD4g3T5JoAPZ8vc/ywLu76TN9X2cf/peJ+zg
	 gC+AzaIjNuL4ckxwJjkmIGksepoya7prlavzszsuIov32unN7JFtYGR/s6BWvx5zD/2/X
	 6RRedOTPyljE2ZvcLzb5e7pYftwUtDQeWFTM2+Zkso4fgAysYz6G9buV+Q/6i/PrWIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BwcxGxscgkpDwfEsuyCCR+h8y4lHd8lYhXiW48dHHWk=;
	b=fn640VmizLi8e5xKyZQQBNN33bjsDCueSd0oawxzW0FMSBQP2vw1B+uR4L4Wi+5iqrsG
	 sPK7TFGGnsXu+QXRad1q4uLhhjTlA0WQQJqLxv80kyBZYhzs+XjVU3m1YEOdHbMcrNtRL
	 awG+7ibk32T4h4a4KHEuK3a0I4XvZTcdgHYqvjkUU+Wy5aTcNotr+AWXdrTeKL46fAPJP
	 rU5e6YlasrHOgm4qGYJPsDNNuXASfsjlDv0gkFY0503QtwNBQDRu5DbVg0DAh+1A+rat/
	 iQwVPetapscfQxmk/AGjr3cZxIxMb2n+KVtQWhIjFcPch9mKDhFp7e5uCj8WHMDlwNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMq3gk4I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D5606A326;
	Sat,  7 Nov 2026 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMq3gk4I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA131F008A1;
	Sat,  7 Nov 2026 14:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062927;
	bh=BwcxGxscgkpDwfEsuyCCR+h8y4lHd8lYhXiW48dHHWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMq3gk4ID/GUTTZEnHsapr8jqlReqCE0JKQsiP3NenZenONbHyNUrBVvstrD0kGIX
	 DACEov6BkmKu5jNy2TkHim/XQTXnkL/u0Xb3p8l3QmuHe63FUxIxb97XccNSSJDXkZ
	 onTU5w8m1qFZYbHprUQtNmQ84SGOwdQm28zS3Mhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qzhuo@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/869] EDAC/i10nm: Fix mdev reference leak in i10nm_get_ddr_munits()
Date: Sat,  7 Nov 2026 08:48:01 -0500
Message-ID: <20261107134858.784077713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f0d8c34b3b5e845113581d7d3b24ddaa61bce1f0 ]

In i10nm_get_ddr_munits(), get_ddr_munit() returns a PCI device with
its reference count incremented.  If ioremap() fails to map the MMIO
space of the memory controller, the function returns -ENODEV without
putting the reference held by mdev, leaking it.

Put the device reference before returning on the ioremap failure path.

[Tony: Dropped the Cc: stable tag]

Fixes: c545f5e41225 ("EDAC/i10nm: Skip the absent memory controllers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qzhuo@nvidia.com>
Link: https://patch.msgid.link/20260916091251.1997522-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index dfd49412f3199..59d359f3f3fb5 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -834,6 +834,7 @@ static int i10nm_get_ddr_munits(void)
 
 			mbase = ioremap(base + off, size);
 			if (!mbase) {
+				pci_dev_put(mdev);
 				i10nm_printk(KERN_ERR, "Failed to ioremap 0x%llx\n",
 					     base + off);
 				return -ENODEV;
-- 
2.53.0



