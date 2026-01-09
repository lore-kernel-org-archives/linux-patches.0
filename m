Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD9835C18D;
	Fri,  9 Jan 2026 12:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962485; cv=none; b=XCnLm11Alc7lfk41/aIVio9tgKOsnqkXj7/Doyq+8VG7zWw0ur5EyaEIC5VNAOsvBlAmcIg0WnWwNC6fL3RaZPFvMN8AWTUsXZnb/JaC1m1jiFl4j4cpnr+we6H5ngeSeiFOAX7feBQ7wznmwT5afFKMfKRdzQKoPqIrXe8kTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962485; c=relaxed/simple;
	bh=6BetIjwRBbBcjyM+zx2yLND1SfVz0bDGtzUskWb7A8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kle5XRAq3uYqobv8IWUZ1BFTnfaqwdgST9cpI5+aF/inGAZsicF02ZAbi2ZSwrPsYZgZG415792HVOa0hwjaTzMhjLge5xNNJ2MffK2zRlsfXlSmJ2/fM59Y4Hpu+AbtEF3emlfpHlgFBVR7V512oRkDhHh2LniF39CijhzTtJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE2Ym3qg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE2Ym3qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E34C19422;
	Fri,  9 Jan 2026 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962485;
	bh=6BetIjwRBbBcjyM+zx2yLND1SfVz0bDGtzUskWb7A8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FE2Ym3qgVc+Ts35+2s030yDe/K3S4gh6Zxhzzafiw8VYKi03omqRgcqy8i/Mrq13U
	 ZjEb0J0iYA1P6+t5TtLS+mLx9jbLWfpomUhXlPdtzdd8cpqvHNC0QJOOMI8of/ubi1
	 yyXfNBMrIofNdmSjMK64XJfPBtpriO86fsje99UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 380/634] soc: qcom: ocmem: fix device leak on lookup
Date: Fri,  9 Jan 2026 12:40:58 +0100
Message-ID: <20260109112131.828900869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b5c16ea57b030b8e9428ec726e26219dfe05c3d9 upstream.

Make sure to drop the reference taken to the ocmem platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Also note that commit 0ff027027e05 ("soc: qcom: ocmem: Fix missing
put_device() call in of_get_ocmem") fixed the leak in a lookup error
path, but the reference is still leaking on success.

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Cc: stable@vger.kernel.org	# 5.5: 0ff027027e05
Cc: Brian Masney <bmasney@redhat.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250926143511.6715-2-johan@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/ocmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -211,9 +211,9 @@ struct ocmem *of_get_ocmem(struct device
 	of_node_put(devnode);
 
 	ocmem = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ocmem) {
 		dev_err(dev, "Cannot get ocmem\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-ENODEV);
 	}
 	return ocmem;


