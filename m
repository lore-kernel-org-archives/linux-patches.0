Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3129ACCD;
	Fri, 21 Nov 2025 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732848; cv=none; b=isYFmH/2xh79tfofT6g5wmor5vwcbw3sZdEr9yyhgw7y0I8QOnqUcugNgJZAWNZAGrdp6Sk6HiJxMgS4u395wMa+ovbSm56+8YLeH2zpj0O/mENzgCle6YGbWAZkT0DZfs0xbkMmAiV/niHZSVMQuvYWngUhonJQW6Uz85iJm6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732848; c=relaxed/simple;
	bh=NstdPmovMAXSUcFuAXhA9wujvgxid+pkF7lrXw/qSa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMQnWRbxrGyg6kwTeqsUO/p+lAZcmEEQCgK1u0VK40R+/H8vYTW0AsL76p1goowwZJuwL1hzEqcgd7HrUkHg/oyR4fW2V4RAAqi8fsKOdLkEgOXphROLrQZxcHilqZzlQ8eouIvUSLbDCJ6d3ZVn3vo8p4zvRjABsulhGEK0P18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRevj8In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRevj8In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1435BC4CEF1;
	Fri, 21 Nov 2025 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732848;
	bh=NstdPmovMAXSUcFuAXhA9wujvgxid+pkF7lrXw/qSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRevj8InKk3Oc9lHwGQ/g3tYMsfyeDa1/LQ9Q4nQvqF/VAedMdJdIOCRN4CJQxaAO
	 q1fWFCeX0JGjefrKyAaGvmp2iY9v4wJOAF6bnp9h1gFrnfW5vsq9aXoJsPuzeK2RO0
	 ZiW2n3iOhXp7N8w/v3XBq088cZX/V0oQgi9Nq/2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/529] vfio: return -ENOTTY for unsupported device feature
Date: Fri, 21 Nov 2025 14:09:23 +0100
Message-ID: <20251121130240.417620692@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Mastro <amastro@fb.com>

[ Upstream commit 16df67f2189a71a8310bcebddb87ed569e8352be ]

The two implementers of vfio_device_ops.device_feature,
vfio_cdx_ioctl_feature and vfio_pci_core_ioctl_feature, return
-ENOTTY in the fallthrough case when the feature is unsupported. For
consistency, the base case, vfio_ioctl_device_feature, should do the
same when device_feature == NULL, indicating an implementation has no
feature extensions.

Signed-off-by: Alex Mastro <amastro@fb.com>
Link: https://lore.kernel.org/r/20250908-vfio-enotty-v1-1-4428e1539e2e@fb.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index edb631e5e7ec9..6dfb290c339f9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1195,7 +1195,7 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
-			return -EINVAL;
+			return -ENOTTY;
 		return device->ops->device_feature(device, feature.flags,
 						   arg->data,
 						   feature.argsz - minsz);
-- 
2.51.0



