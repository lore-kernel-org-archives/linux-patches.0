Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6504A22AE68;
	Tue, 29 Apr 2025 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949189; cv=none; b=aP7itflxSUavcfC8jckMB5Ju83H2fScbxIEuYKNFs1wnPMCF4wEBsxDsyikRSBO2ahE3tVRFkwbVvmnx5s77a+JkVFTBoXLvsCAg4uEyexuAZiwRICGH4Uh+6QWyFyKmXNPFN1Q20WEqLRASPpUPkVJJ6ZDe34YTbl79NK0RGI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949189; c=relaxed/simple;
	bh=eSXGIRfYGhtZLKvb8fGmLbdzgUy94gdRR8Oo8A7ty/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUieSKSXEASuY9Tg6wvpAznc2pbBMvFKFxjxmiO15sAeymV6aj/lwxICi2EdRhKP7h0rVuLK1p0IN+AU0lkD64D8f47qrVU54YTw8G9BCz7FzLGB9Tni/fNyeqo42I6JUtq4iTHVvF9U9fZ8r99S10f+zjxXLGLFw9YVAoNU1lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq7LSd9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq7LSd9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F16C4CEE3;
	Tue, 29 Apr 2025 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949188;
	bh=eSXGIRfYGhtZLKvb8fGmLbdzgUy94gdRR8Oo8A7ty/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iq7LSd9mCkbFfpl7dYJQyPrWfrvZzJFFsdd5qsGC1e5Z7AuD/mLcXWuItgZ4AAA05
	 ReLwUYLrtrIt9xFuxti4KvBPOg4ENAkxD6pVHopei/eqIEaKsfTFPjy9XXD9uLvddM
	 rYMVZ8K2fy6EM1yEHYlFALXYfWh4VcbB8lb9gS5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 239/373] scsi: ufs: bsg: Set bsg_queue to NULL after removal
Date: Tue, 29 Apr 2025 18:41:56 +0200
Message-ID: <20250429161132.966192350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

commit 1e95c798d8a7f70965f0f88d4657b682ff0ec75f upstream.

Currently, this does not cause any issues, but I believe it is necessary to
set bsg_queue to NULL after removing it to prevent potential use-after-free
(UAF) access.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-3-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs_bsg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -175,6 +175,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
 		return;
 
 	bsg_remove_queue(hba->bsg_queue);
+	hba->bsg_queue = NULL;
 
 	device_del(bsg_dev);
 	put_device(bsg_dev);


