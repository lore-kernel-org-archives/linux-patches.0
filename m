Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09146198A3B;
	Thu,  6 Jun 2024 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683405; cv=none; b=FyAdGaZDhnXu2ZhrUdUEzmr2lHDTUqYhuBLtfe25YhDdvLDKUMdgrJCDHZjgTJKBgcDxTLnaFWPC/JkpwSQWUtoqDJFDItg9AMd6Jq70Px071bbfXw9C9kj3w40cVrGwbPSJDk1yU7DuFjBqmkzEg3u4SA0FwbP3QFIdjURF43Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683405; c=relaxed/simple;
	bh=3QEjwKVryvGvCWPBhQUSOnDmKiOpmACo13qDvrhZEB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flY9pnJxSo1+rCKv6WhMUob9IuvJu4e0QWxenV+lg/pK6eQ75swHOHxijfIVdIbicj4WcekN8Wgj+oMwOE+SeDsxTwC5gvXpJQ51vs7jQmvXcfMQhG7h+sPc85BpGuho2ex8TU9E7DawKyIhwv6/iJlnWZZbBNDG+X4dGSLiOwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqeWBf55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqeWBf55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D935BC2BD10;
	Thu,  6 Jun 2024 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683404;
	bh=3QEjwKVryvGvCWPBhQUSOnDmKiOpmACo13qDvrhZEB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqeWBf55ho8S+9AAGEPiWizqZ++0UyCr1LwQcLxyiGpgIZObYbRqtMLDBrjgUvRj9
	 uCs3YJSiZmGkNJ5iqopbeRoqKRA6D7XBnyhz2vmNk8/4wHnK8wi02ssJlfPVIH7kuf
	 x9pNZu7Z4KBYJuhBY8ivJ+K1xW2rhHmkuRG/MO+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/473] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu,  6 Jun 2024 16:03:37 +0200
Message-ID: <20240606131709.409980577@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index af8777a1ec2e3..89e4a3e1d5198 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -594,7 +594,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



