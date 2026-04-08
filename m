Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C038347517;
	Wed,  8 Apr 2026 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671972; cv=none; b=IC9m7VR9X2j2LbSeuNel9XWOq9zNaYqFqGUsSwmE8EaCS/TTu5ahei4uEiWM6V0dAyBoMdCZl+IH3G9lW5mRX93hhonkS+tKqIf7TRkSdN6RcCbnGFoEhN7GCYPGrKR0Q7u0GSafCY7cUQP5fYLvvkNAhSExz1lBpP7175BAasU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671972; c=relaxed/simple;
	bh=prQJhOYsxsRs7XcCksPt9GfR6G3F8ibrIOGNezed8Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDMg+0Ma93KDwfbUN0oq1KAYGP8ioGWgMq5iAr6XWwlEX37M0q8poppISX/dNK4F9hQnYXHQoncXoxb6vB0b6uxWynqv1ZEe83YzHhbyGbUdgolgCsdDkrNY0RUAbZQxdPfVS1CQU3rKA5rvJPOEPb4OrIgRObvvsZwivVUmxz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYoxmqI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYoxmqI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEE3C19421;
	Wed,  8 Apr 2026 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671972;
	bh=prQJhOYsxsRs7XcCksPt9GfR6G3F8ibrIOGNezed8Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYoxmqI3Rozn03eIjRi6If4JMpgjnxyExYbiFyF9dA5op697r9BKJOz5ogk5C+Dxk
	 LSCrbn+u1WQTqww/IQVcSTRcdDaNoFU6ORypYVrP6ZC6grZrE9lqz6imdy603qkfbp
	 N5Mw0g9JufNKFefK5PRpr1/SoG16Emf41NcK4HTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/312] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Wed,  8 Apr 2026 20:00:39 +0200
Message-ID: <20260408175938.324962243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
index 0689464c4816a..ea222e1654ab9 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1663,6 +1663,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
-- 
2.53.0



