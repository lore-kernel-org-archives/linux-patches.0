Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D375A3A7826;
	Fri,  7 Aug 2026 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114270; cv=none; b=jDrvqPET9HgS5nX+SMrYHRzvUPcjAHYnb6ZgROeDQU9iHUs0CpoSZ38zBgfnIJhCwwcCXe74cxFDiKa5/v3hYgBSVghNeJgs9P0CnkfCJsh8l3PX6gQ2ZQo0jUnvCH0Ucy/UqsoyKRnTswhSwwkAugVnW8pTIqFfzu0GJA8S5WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114270; c=relaxed/simple;
	bh=5j1kMrmUZFMrtyv4jV+75EJ9ycm1OJyKPFHCYqC8/sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSXgvvReR+HI2FRWHd3HvYd0EFaL5e4LoBrE12uBx5iEJtiF7Uo/lfywgSfyHb73jZtpF5KxUKazUvld7zOeidX6saHN/Ds0UWAaPjbUwf+iaFVMSVQN5QDgzyYQKNvjHMdmPm3DjROO3iB5vvBSeKAlUa9iOvLl4brk83NvR2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWcxePZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWcxePZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA991F000E9;
	Fri,  7 Aug 2026 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114266;
	bh=dLqLhip5qBn2Rmg7U7xC3azCfp3nCawiL45gCdNxRMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWcxePZ0+33SD7gCC435v4k1qi8WsU8zJBi/8STAjT7ObtAtrwPg1HL3EMYNNdsFJ
	 +VuGq8tzEVV9Q+RgeIHZSW5XIDgsxORxOeiJyb0nJWeEQSguXcZuDR86rViKqAhj26
	 0PkKOr4TAu20HwZxKtobJzkHJEmc7+gg4rQm2CoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 202/337] i2c: amd-mp2: Unregister callback on adapter add failure
Date: Fri,  7 Aug 2026 16:36:45 +0200
Message-ID: <20260807143422.933426262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


