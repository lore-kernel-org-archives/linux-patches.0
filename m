Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958AE324B0A;
	Fri,  7 Aug 2026 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115399; cv=none; b=NaBHhfsL1NGs6km7fpA5AxxMa5zpmx6WMjWa+T4RlvVavbjuw7GTUuZQhlzYqjQy2bwKSZHQW6PKBNuRasJNcl6wC8Bh3x257fKEzoqh52JpPIDM6qEiCrAGc8MtQB4b9NpvVuRY1K3gMXUmGoORboRmwbgJ7VZd3Y6FPhF0PzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115399; c=relaxed/simple;
	bh=GzqrLZAbGLuMs06krhI0XoQuc6iHpgCFF5z59MA9YXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxE0HvI7g27xKWFugkRDl7fz+8djUtGZaCNyxVZxfxmq/rE1rUERgtj1R07nHPhZKoCTEg3lsdhwHm/CMRO4ez15VPHo8UnktweKj71N5TuG9oj2GAuInwHspFHcK/h2Jo2Axe6rRj7Cr90F8OyVaDpIM+4ffBNoF4kDLfCbjdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLm4lIy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLm4lIy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C05B1F000E9;
	Fri,  7 Aug 2026 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115396;
	bh=1XL7ErMrp4EywVOl23KboxLc1rOuvL0fLCC3lYZOhtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLm4lIy4Qob4TNJr/A+KUxUVJ+DoiJ2YBqKCXb762JDu9psr5H0IoOBorxVN1mptm
	 pYxxWWeBGqQyXyzJ/Z1uD/X46tWleCtMoGkgKDAM5BdhsIcAY+TzZ9WbIxQpEeGbso
	 KE51hZetfEfeS9fkL/SxHhmc7+jlYnDcSF/rojpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 262/396] i2c: amd-mp2: Unregister callback on adapter add failure
Date: Fri,  7 Aug 2026 16:37:02 +0200
Message-ID: <20260807143429.908337420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 82048795242f04275a3f49ffc66ad851b6120954 upstream.

amd_mp2_register_cb() stores the platform I2C context in the MP2 PCI
driver's callback table before the adapter is registered. If
i2c_add_adapter() fails, probe returns and devres frees the context,
but the PCI driver can still dereference the stale pointer from its IRQ
and system-sleep callbacks.

Unregister the callback before returning the adapter registration error.

Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260721144147.31150-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-plat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-plat.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-plat.c
@@ -316,8 +316,10 @@ static int i2c_amd_probe(struct platform
 
 	amd_mp2_pm_runtime_put(mp2_dev);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "i2c add adapter failed = %d\n", ret);
+		amd_mp2_unregister_cb(&i2c_dev->common);
+	}
 
 	return ret;
 }


