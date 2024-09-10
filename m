Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5912818DF69;
	Tue, 10 Sep 2024 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962731; cv=none; b=TwZ94WInHT6G5lv8HiWfT5T1krSNW5/E0njSWkWJhGxNJ8F5ksN7rPqCI8qIaIySgcLD5IzS51pSmiVo+h9aCusCh578UEzZTBvJeTiZjP8cR+G057JxEdb5dwrHkNoML0xv3d+Dqwq4JDyeGY6Qa+agv6C01xQjT4GwUzbz2Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962731; c=relaxed/simple;
	bh=1uRGUE2Lvrt6U5Ry5pQaW/hknDCJtdiFEzYICTsWgT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjbiSvlNsyK4Coy4S/7PXBLAAlvPT2Rjlz908X1lF1t+S7SUuO39Uyoq5+KLNnKEVC9v6OMl0aatTlR7Q127Qm1koCqDaSSrXuMT9Kp8+zoSvR3L+CurpkPZbk/25FhusbmyloifSMhETl07hrI7xcWyBdrT97YcHGqFX+IcOSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaDrP/y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaDrP/y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28D8C4CEC3;
	Tue, 10 Sep 2024 10:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962731;
	bh=1uRGUE2Lvrt6U5Ry5pQaW/hknDCJtdiFEzYICTsWgT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaDrP/y5rZpjiSDYNVJ5iCJo6sWH6xwiWrHyOjW5s2L1sYU2acLDwJ3vq0BwZKanc
	 W5ylkmd3yhIHKErVoc2gP57cnfMLLojfUcllHm2jfFWcHVNLpudi0Q7tpHKE2fqZFx
	 YPOQUcl9JWnsyp4U7/WbASmRooz4bCgQxQW6taTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.1 011/192] ata: libata: Fix memory leak for error path in ata_host_alloc()
Date: Tue, 10 Sep 2024 11:30:35 +0200
Message-ID: <20240910092558.387026976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5532,8 +5532,10 @@ struct ata_host *ata_host_alloc(struct d
 	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
-	if (!dr)
+	if (!dr) {
+		kfree(host);
 		goto err_out;
+	}
 
 	devres_add(dev, dr);
 	dev_set_drvdata(dev, host);


