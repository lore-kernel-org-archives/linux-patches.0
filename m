Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94735230BF5;
	Mon, 10 Mar 2025 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627428; cv=none; b=endYcAT+DkDrIJ8FtRdwnh6O6rm1fpvdfATQs2QUBRByGwfo+d+/74mlOZea4kKh4rKUsHoY7dzCHggZ24CGmWXT5VXZE26rquzAUhBUhhDJftDjRgC++OBLIKsdER6HMm7c1DFUQFH17orTHh/DnJLnt43j8z1IbTBpmaW4TSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627428; c=relaxed/simple;
	bh=/nrtmwo2zEhdptjqgof2mdx9hmXC3sAYLpvsIRgHH08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgRZc954R3MLAinJ1p/F21G6s75SweRrsY98J/B5QSbRS8UPcI+mey43KLYxq/JcplPXkf8eq8HRM2vOzqYo5Jyojv1bOUzDO8XOuKMRO75FaTY7FRaAo/+V9UJ+hAsIj0oWyYHOF5N/FKFNTy+dSK3IkSlASJWg8Joal68J8OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/aB+ouh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/aB+ouh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF428C4CEE5;
	Mon, 10 Mar 2025 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627428;
	bh=/nrtmwo2zEhdptjqgof2mdx9hmXC3sAYLpvsIRgHH08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/aB+ouh3wJXXMVaQrvPh9B3F8lQXNFz94cRJ6WcXqnm8ROC7aUZHQqgrR2wooBtg
	 C7gB5CfJI0pmqKM8OD+8kyGD6hm5uCm6MUOcymU74pCY8OEL4qwf1NvX/TB1Phj/sf
	 Vpf7OH7g6KCyohu5pYUZtiqE6ZMaePoORwGxj7iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 127/269] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Mon, 10 Mar 2025 18:04:40 +0100
Message-ID: <20250310170502.786007118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e842f9a1edf306bf36fe2a4d847a0b0d458770de upstream.

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -871,7 +871,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;


