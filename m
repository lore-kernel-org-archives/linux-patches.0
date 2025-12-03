Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFC436C0B5;
	Wed,  3 Dec 2025 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779523; cv=none; b=YjGHT91RoBCaH1+gV14Ac8mdGDcxxW63ejXnMmh2VZPSiVmxbKLaL/Ig3M8SdtBNcwJ11wv/Ln1hR9xOyCHeBMJ9cDwrlcbz6byUIkgfBChY5tae3o73Lz34/5L9cfcR4rLK02TID3vrNgKGrIj/X2vTZ2702ynPr89Y6lqLkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779523; c=relaxed/simple;
	bh=7ZVzNfACwSSY2jLxelk+cHpZ4twRdDjZhpAPh7DIUbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpJjq7gX6q+Kp22VOGy/WKX8wNfPjTjGc1FFd2cOLb50qFymQcGYiDkGGk9gn9JOd1NtmhsRKCnb3jzIqC0Tk2/wcKRwbOIGoTbkKzOr4XBmzSSmruzOViIjrl57pEomsod35/0QQIUsG09FPh0JvrZ0u1aYOrkCDMjk14qLmL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBau4ToT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBau4ToT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C525C4CEF5;
	Wed,  3 Dec 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779523;
	bh=7ZVzNfACwSSY2jLxelk+cHpZ4twRdDjZhpAPh7DIUbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBau4ToTCpzT4DW8STxhIit9iR30CAeQZVzMd6a+sewcGifZoYquFR4SBBdg4JiFM
	 vL56J+AEZCvX9pOfam8bKMuWRFBq115ZEwRDPAfCWgnx+nFqYvwnbTzew6+8Kkrm/a
	 wPzdGsg2tJ0xCM5kL3Rv3CfERVj5m856RKZqLRBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/568] vfio: return -ENOTTY for unsupported device feature
Date: Wed,  3 Dec 2025 16:24:12 +0100
Message-ID: <20251203152449.878104019@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 6e8804fe00953..e191422e99c4c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1501,7 +1501,7 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
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



