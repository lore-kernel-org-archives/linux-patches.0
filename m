Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15795269CF5;
	Tue,  8 Apr 2025 11:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111510; cv=none; b=UuTcm9VBQFDd8aCE01q4QVwkonSM3agjMSgpemCSj7bMOQbanNg990CoWx7tiexj5BXI7nd+4IW1pMGIZVkjvXVXnZpe+PPipPjmIs0z/UCvf2C+WZtHDXYIAGaRpJouRD2+b8X64pDMc6qX0SgbiGfjAYFg6np6QIPG6Kq6JUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111510; c=relaxed/simple;
	bh=MhT8pzAXNGb2WZrqL6FfL3MvN2sB67UL40vOvue7XHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfUQ2wPPnVrQO7rT/XVLnQWq/8w57VMsqQv1pAzU3OHGQXAzv46DYkeDR5r02mcGaKXOCDtVkadIeHGdolq0JiSwX5xS+XR6Mkt3fR6C+D2/Q5/fmiVZzXwJx50f17W2AfnXTL8OUxTbOaCd4U+cLTD72LD1lgloerfy3sstgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFyPwyBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFyPwyBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BE7C4CEEB;
	Tue,  8 Apr 2025 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111509;
	bh=MhT8pzAXNGb2WZrqL6FfL3MvN2sB67UL40vOvue7XHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFyPwyBq52hmJxawFXa4Jq8dqKFSIMEW+f8RnYn4uxxCTF3bg1UpfvSU6WmARu/c0
	 tx7RmSf6W7vN6P6gOPAPaSjr1LzGZJk1v7XOYm3mqy6MkAPSAtYx4iWb/FvVfezCqQ
	 CSPdK/DjPC1BXxhZk193EvzdgFphTbLRVOzuPt+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 456/731] soundwire: slave: fix an OF node reference leak in soundwire slave device
Date: Tue,  8 Apr 2025 12:45:53 +0200
Message-ID: <20250408104924.885607378@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit aac2f8363f773ae1f65aab140e06e2084ac6b787 ]

When initializing a soundwire slave device, an OF node is stored to the
device with refcount incremented. However, the refcount is not
decremented in .release(), thus call of_node_put() in
sdw_slave_release().

Fixes: a2e484585ad3 ("soundwire: core: add device tree support for slave devices")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241205034844.2784964-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index 4869b073b11c2..d2d99555ec5a5 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -13,6 +13,7 @@ static void sdw_slave_release(struct device *dev)
 {
 	struct sdw_slave *slave = dev_to_sdw_dev(dev);
 
+	of_node_put(slave->dev.of_node);
 	mutex_destroy(&slave->sdw_dev_lock);
 	kfree(slave);
 }
-- 
2.39.5



