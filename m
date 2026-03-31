Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEAA3E4C6C;
	Tue, 31 Mar 2026 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976143; cv=none; b=mY73OlVf9OQyQuBZ81eU+5TXXACsP0vBH641aEQNJDYqDoVVVB6a3KLG/tisR9bof/8eFAXGv35Ht5XmEHEgkQH7FMaQUnAv9Px9IvZKJGx+Sq2KNEBz4rSwbvk0kkMQMzT/2hCn1nsgx4kmDX5lrbTZBZtjynXylzJVM5dss3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976143; c=relaxed/simple;
	bh=zAKVBslYnk+6xGnWMpYCqsIIAtegi/085PqscHNoN8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2ZSXIQE5r5u3/nMcCSmewsIFx0EGi8LUHuZ+tCH0eoahsZbtjNBSunyyUHBQVvtckjlft2Pmewtvpur0OD5dMHRlmbSRcmvLTQ2drqv9gAHUF5Cca+uYvXwQ+BGEfdtz5JwGdnyey3F/b/RPHgSr+4QzOTMp6em9MQMLofBZUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1hjMn3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1hjMn3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B5C19423;
	Tue, 31 Mar 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976142;
	bh=zAKVBslYnk+6xGnWMpYCqsIIAtegi/085PqscHNoN8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1hjMn3Pdzk5SqlXR13zQPMqkB18hTWSglFhbxBcV5PCByMlgAI74W/Oewn+8uJf5
	 Sk1IRC/KRfTwPzGRF8qxaSIMErlkqf9mhaa17qIaPoE8IvV8Pvh4IHE4acn6J1kbUk
	 rzJoWTLEarsLMtAMSEr8n8hDTYfr4L5V1XuxUERs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/244] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Tue, 31 Mar 2026 18:22:54 +0200
Message-ID: <20260331161750.041403973@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 3d33de353b1ff9023d5ec73b9becf80ea87af695 ]

The workqueue associated with an DSA/IAA device is not released when
the object is freed.

Fixes: 47c16ac27d4c ("dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-7-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index f706eae0e76b1..154d754db339c 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1810,6 +1810,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
-- 
2.53.0



