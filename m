Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77289168C4;
	Mon, 27 May 2024 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837932; cv=none; b=ZEKPguh89V4QXDEfqlha27ghGGrcZXcxrYgdTT1jCHqrGaIVRp2swFIfAYEWfwyLuGVdOLrV8zGsc41+uy8jqQWBAq83tgZrJlB7EmkV1OMAND0ZTlK2l9kIvgSskWgyydb3ImjdTw5EXKV4uMmOA1Y4YhAqiBEntlXeaVLme0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837932; c=relaxed/simple;
	bh=+gzN+LnLgtwV5pOykCC2X3CZh7kHEeSXPeXHlyXViEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnp5izkOn5qcmO1kJ4N9lIJQEMUCVLo8uD669o3KNn5p7UY1t0JqRkRjmi0LppYBKcRIzGc5zSNr55GWOdSdPqJxEcGUwkSWKFHnxvZj979GPW5NOeJtPIC59WpApDhzxETBrdCbltVfjToitz+o6jjCa2voIgRY1uOdwRvCrps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs1d3LpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs1d3LpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F475C2BBFC;
	Mon, 27 May 2024 19:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837932;
	bh=+gzN+LnLgtwV5pOykCC2X3CZh7kHEeSXPeXHlyXViEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs1d3LpEhn2RrHKr+gxcKBnM56J1JVHEsoNBF4N5IbCEq2T/LqZvT+CZGXXC6AIAi
	 1Ma1wW2t4eEA83KgUCOBroDw+tDZ+iMqn3R+/5VhW70xXqsnUYFba4gdQir1WhlHED
	 f6ZEalddbDkrROrVCmnxDIr7V3tfnL5nzJnineIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 200/493] scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H
Date: Mon, 27 May 2024 20:53:22 +0200
Message-ID: <20240527185636.877352630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 408e28086f1c7a6423efc79926a43d7001902fae ]

Currently, the UTP_TASK_REQ_LIST_BASE_L/UTP_TASK_REQ_LIST_BASE_H regs are
written to and then completed with an mb().

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring these
bits have taken effect on the device is to perform a read back to force it
to make it all the way to the device. This is documented in device-io.rst
and a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bits hit the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: 88441a8d355d ("scsi: ufs: core: Add hibernation callbacks")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-7-181252004586@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4a07a18cf835d..16dc63632e720 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10353,7 +10353,7 @@ int ufshcd_system_restore(struct device *dev)
 	 * are updated with the latest queue addresses. Only after
 	 * updating these addresses, we can queue the new commands.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/* Resuming from hibernate, assume that link was OFF */
 	ufshcd_set_link_off(hba);
-- 
2.43.0



