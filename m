Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613AB1519BF;
	Wed,  5 Feb 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767934; cv=none; b=gYjiPVbEyu0ymbfal4whX+uROzlzMCx0fpzR4txaQFKUTGaNE4ytRqkJMq6e55LM2vBnyS4Q/cNrE9ih9LoPC8wO4VgUZsZnePCZ757kk7JZJJmrkCWK5NsldtdXCLjrZebwSfRVQJvBBlC4KJWyriWSQ6dwm7epPQGcFW9cV+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767934; c=relaxed/simple;
	bh=HmPcAUieQ0/w4zcxs1tFQgewLkE7PLPV5dZ1bzxkhKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObMxyTznD8iKx8o6SHIaqiNroe9gFE+pCZBbMFqof3OfzQsINa/CBhJdh9Gxd8OyeEDivcYs2d4m34yvadfL7wNTQUcrLEsZs676L518hjlnacrICZu4W4VoozsBx4My0mq/5W4+wA2yTYxA7JxmmiJrAAyO9h4oOoUVWOkRLy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWANiKLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWANiKLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98E3C4CED1;
	Wed,  5 Feb 2025 15:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767934;
	bh=HmPcAUieQ0/w4zcxs1tFQgewLkE7PLPV5dZ1bzxkhKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWANiKLrPlDTmAX0f3NR9mIoJXUW3YRBqmWAJxbd5dQUUrDkFQ9Pz8Ltuv073vzHy
	 gMXTAsn9XEMd0Wj9Aseo+j68psSDDdKhAVaWvUfl1baT9A8xJ6tgbALpDMLfkGCVSi
	 PAYx2S+gF3JXkecxkLRizr2o7JIxq17AHV+SzUIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 474/623] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Wed,  5 Feb 2025 14:43:36 +0100
Message-ID: <20250205134514.351690732@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit fcf247deb3c3e1c6be5774e3fa03bbd018eff1a9 ]

We should remove the bsg device when bsg_setup_queue() fails to release the
resources.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-2-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 6c09d97ae0065..58023f735c195 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -257,6 +257,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 			NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



