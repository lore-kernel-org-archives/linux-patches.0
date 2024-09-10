Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518F117BB0C;
	Tue, 10 Sep 2024 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964871; cv=none; b=DOLeQ9lhDz4VI9l32n4cfXurUCknO+psH7Usgnf5Hqw3/F+1xG7CYU5nKywQ4Clldu0NZ6/1lubhYi7PCXa4TQ1CbC2Ab/57InCZbflcsaCJdMWzygvdmcL0NDN2aKouzRplvD0uHFvcnhm5EUTkX5m/WzZevPllOY+oxszCFBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964871; c=relaxed/simple;
	bh=5LT3BcNgjkSlox16UgKQx017AGhRqsmSlTeB0x4BGzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Veegzqr16azQSFp4PSJQw/aXftlGwuNtjk6mdz82KHP1UYUDAMi3bs73vWXmmk2S78+jgzFgMrB66HQJSjZE1gEf1jGTv3fi1CFHn5p45PfjSLxfhA1CoMv+Bp1ROLdvmFcw9mu335wA0xpD6omMuc/b2ipTG+Ny//uKY24LRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeb/EnjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeb/EnjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB80AC4CEC3;
	Tue, 10 Sep 2024 10:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964871;
	bh=5LT3BcNgjkSlox16UgKQx017AGhRqsmSlTeB0x4BGzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeb/EnjH906Latj7+XM14tuhQsZaosVWnGYb2lCNzM9V2bovV7n8s4sph/Cru/9Lm
	 NPqsoNyXFKGxnrp/T6wbZScEi07liiIpT5gSXCBLatagWjt/XBX4/0pzWa9/gfYCX/
	 oH64vKHlIohw1utHBWvb/w/ZpqgRTyttUCVH95SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.10 059/186] ata: libata: Fix memory leak for error path in ata_host_alloc()
Date: Tue, 10 Sep 2024 11:32:34 +0200
Message-ID: <20240910092556.917515720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

commit 284b75a3d83c7631586d98f6dede1d90f128f0db upstream.

In ata_host_alloc(), if devres_alloc() fails to allocate the device host
resource data pointer, the already allocated ata_host structure is not
freed before returning from the function. This results in a potential
memory leak.

Call kfree(host) before jumping to the error handling path to ensure
that the ata_host structure is properly freed if devres_alloc() fails.

Fixes: 2623c7a5f279 ("libata: add refcounting to ata_host")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5429,8 +5429,10 @@ struct ata_host *ata_host_alloc(struct d
 	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
-	if (!dr)
+	if (!dr) {
+		kfree(host);
 		goto err_out;
+	}
 
 	devres_add(dev, dr);
 	dev_set_drvdata(dev, host);


