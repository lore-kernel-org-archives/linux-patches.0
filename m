Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C602F12A0;
	Fri, 17 Oct 2025 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716328; cv=none; b=RW+HEDbDgGHDtZCMdG1YYCpfikLF59Tjr21yk55929De3jvkB1MqbD4U3e8ycU4WnvlXS/JFHHsqH4mQtUV35hOqA8dU5h6hx8wsKSfpgj0rr5WCqy1oPVpldYFl2geEgbkIRlkg5sCY5pnJYy0vcSpYLXOqPuAka2hSSwc1fjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716328; c=relaxed/simple;
	bh=I+qpzgJbEqRldba4dslKapE+c03P5Qv4LiqKWerw3Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIMN7ruvjDF/MLP8b9oWU67V9HZSqsQ/GzFnoku6lkSFLy/k3HC9PXl6uSGrzJPHBZn3Z7bHzJqOLpYZc0lCPwIEFGmEzebPSgdcDJRMTz6qRHGGb5j+Qtp7sx5HMuKt5heEbwhavohOdMhzX6gYW0pHkq1UKrKaLaYNPXyHPtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzYH2VbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzYH2VbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAF1C4CEFE;
	Fri, 17 Oct 2025 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716327;
	bh=I+qpzgJbEqRldba4dslKapE+c03P5Qv4LiqKWerw3Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzYH2VbQevaM9BZDk4YhDTQ0GdFB0FcLHBH5QfWTKhjr083muosmEcxuSU1FdyzrR
	 cVT/4ATRmDQAJRUhmvCMNUj+zLaYiVYrntggQ245mNmR9el5UThKokwKXZ8QZKcCao
	 LPvVH5R9txvje7uTMCmFR1vhTL6zHrPZ5Tfh8hDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/276] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Fri, 17 Oct 2025 16:54:06 +0200
Message-ID: <20251017145148.064375743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 341867f730d3d3bb54491ee64e8b1a0c446656e7 ]

The controller is registered using the device-managed function
'devm_mbox_controller_register()'. As documented in mailbox.c, this
ensures the devres framework automatically calls
mbox_controller_unregister() when device_unregister() is invoked, making
the explicit call unnecessary.

Remove redundant mbox_controller_unregister() call as
device_unregister() handles controller cleanup.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index be06de791c544..136c1f67dd223 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -619,7 +619,6 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
-			mbox_controller_unregister(&ipi_mbox->mbox);
 			if (device_is_registered(&ipi_mbox->dev))
 				device_unregister(&ipi_mbox->dev);
 		}
-- 
2.51.0



