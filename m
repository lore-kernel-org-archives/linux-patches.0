Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DCD518;
	Mon, 27 May 2024 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836638; cv=none; b=NL15e8kmVCzEb4c32p7fhjzdLg67vzmR1DiscOrn59UPVSD6xRCkL/mQmtdGag1xQnaxOJpuMRJ0RvtIxjOOO8TsOt2kjuUzQNwcAIbeI94bWdtMCsgnq8ImEuwmmduHNpvXsaQv8gfcsovbtWhRc5tqGCqUWfj+JgJ81zoGdbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836638; c=relaxed/simple;
	bh=Er7U3JXgebqaAU9bz7LRLWz+55LHDANYXTE8ErVZAgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuuc/xsUC3F6Ko/6zLTosdHYrv2ZQGn5XEsMu4ptAKn/IJUgUVJku6b3lCkzpM4Z/lRr7rL6GkkXwtmt0AK7H4SZj0zhsNyDIAXy3PK1X/RdL4dAwzNzpkHboOBJPb5pqF3fAeWOK5ciqPenJB9otu/dZCD8vN0IPkhpvCWawWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8z4dErz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8z4dErz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15005C2BBFC;
	Mon, 27 May 2024 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836638;
	bh=Er7U3JXgebqaAU9bz7LRLWz+55LHDANYXTE8ErVZAgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8z4dErz5ck6YUQNZVplt29+6DPNk3NrMHmCR3H1DBwkHMiamgyWdsgIc0XkmkyVw
	 SWxtaUwM+MkatW1pvvz3wkXTMCzDqwYGLzc4UMfbggxGYj2gt4FH0xzzLXYjIhw/sG
	 oPvHlvri7Lx/yR98NEr7WB+TMMVAhOMc4ARR0ifc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/427] scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
Date: Mon, 27 May 2024 20:52:57 +0200
Message-ID: <20240527185614.057611595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit b715c55daf598aac8fa339048e4ca8a0916b332e ]

Currently, HCLKDIV is written to and then completed with an mb().

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: d90996dae8e4 ("scsi: ufs: Add UFS platform driver for Cadence UFS")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-6-181252004586@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/cdns-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index bb30267da4711..66811d8d1929c 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -136,7 +136,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 	 * Make sure the register was updated,
 	 * UniPro layer will not work with an incorrect value.
 	 */
-	mb();
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);
 
 	return 0;
 }
-- 
2.43.0



