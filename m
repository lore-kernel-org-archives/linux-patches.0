Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14BE46D569;
	Tue, 21 Jul 2026 18:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657151; cv=none; b=S8FjtiJf2B6wcdT1ertHZoCyndH2uG77vqrqQnEj64mDMRRgSsxSE63kOwmXvSXrhsJOKqroPAzHiEI2JuHDUphKYtcTdZ0mU68uYx1iRMa/goYYvPfXXvzv5CvJ3nCqJoFksdFDY/y9WpNO4X6v1zlLYczTb8dS7NcdPkjSk3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657151; c=relaxed/simple;
	bh=Xa1osygYwCH40yvgrWfQ0DgV2S6vbE/q2CZdMWrIbdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8ig4egqkS8Vr0nESWqCxqie2MkdCoHMDQC+4vTRwG5vGwNeaKoaEDjn26Fe5mokocta6JgLtAiRHbvAguEM2t2fqVItnVHG5SuXkc7n91dezN78QSq3gFYlFXdVj4yHMBLZqaEaAbOkIpUMej9NrRHGtTAgtG0w1DT694DprEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lh5LTKHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lh5LTKHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE611F000E9;
	Tue, 21 Jul 2026 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657149;
	bh=QYo7O3ftDuqQS7N2j08teaOUtEK1xZJesiO0G+cEaEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lh5LTKHVdh7bxqiA1h19/9t73+hY4qPTn68z88niFchIdCgKC1c+GL7illEwOPQGV
	 KGdgGRXRhFomNGJi+3BBuek/7H1be0MUrCqmQ0ZY+xhywIGXgC4rNnUbt+UqFXeUdo
	 iC3mt2GXdSDaEcKds/x1h32d2Cb0PbQb9d269wvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Hans Zhang <18255117159@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0603/1611] PCI: dwc: Fix signedness bug in fault injection test code
Date: Tue, 21 Jul 2026 17:11:59 +0200
Message-ID: <20260721152528.950229004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 94ac934d2c054fba4a22d8dc84749094c5fa0ec0 ]

The kstrtou32() function returns negative error code or zero on success.
However, in this case "val" is a u32 and the function returns signed long,
so negative error codes from kstrtou32() are returned as high positive
values.

Store the error code in an int instead.

Fixes: d20ee8e2dbd6 ("PCI: dwc: Add debugfs based Error Injection support for DWC")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hans Zhang <18255117159@163.com>
Link: https://patch.msgid.link/agL-Uwfn26SI4Gb0@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-debugfs.c b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
index afcc08efe25315..bc741d2261fbbb 100644
--- a/drivers/pci/controller/dwc/pcie-designware-debugfs.c
+++ b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
@@ -256,6 +256,7 @@ static ssize_t err_inj_write(struct file *file, const char __user *buf,
 	u32 val, counter, vc_num, err_group, type_mask;
 	int val_diff = 0;
 	char *kern_buf;
+	int ret;
 
 	err_group = err_inj_list[pdata->idx].err_inj_group;
 	type_mask = err_inj_type_mask[err_group];
@@ -277,10 +278,10 @@ static ssize_t err_inj_write(struct file *file, const char __user *buf,
 			return -EINVAL;
 		}
 	} else {
-		val = kstrtou32(kern_buf, 0, &counter);
-		if (val) {
+		ret = kstrtou32(kern_buf, 0, &counter);
+		if (ret) {
 			kfree(kern_buf);
-			return val;
+			return ret;
 		}
 	}
 
-- 
2.53.0



