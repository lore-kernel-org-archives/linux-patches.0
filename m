Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8D8330B20;
	Fri, 17 Oct 2025 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716330; cv=none; b=FbS6DN4o/smYqxJAK9q0LzmhRXhDDYoBA+Fu5stp1INIMOwRmlIdBi7fJLqBi67x108qbbCI+cMFHInKI7zFwFVD1YeTzXxkhJadIdzZtSO3AwNFtcLQ/UpOKwzNTEo2KFQ5LAtnA1UWM4gmvpPkwR5eFzIKxAh4RJ2I0f3MD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716330; c=relaxed/simple;
	bh=VwL8OmYJW/m9krcT/HJbB/M5Xin7kctI5vXPyh3NuHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMEayLagIpGq5u4UXuQYH8e+dwlRh+LUtLSj2BzJlJzJ0wbyQ5zsoq4iHTwo3b8EVyKkqOO2+f/Wvkm/wOwUlGHOvWYBi6ImTDr/qqyZdoiCxSfkZbxEbzVDz++5tkUqWAeODE7WH9Hvg3voUN83gAfAUMC5ua2aCt0jzz+wzJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLfocC8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLfocC8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453D0C4CEFE;
	Fri, 17 Oct 2025 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716330;
	bh=VwL8OmYJW/m9krcT/HJbB/M5Xin7kctI5vXPyh3NuHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLfocC8m2I0+Ct4Fdw1bTlk/mjao9V0kn2nOOoNHdyrv8WEPIe2J8WNhzytTKb1hK
	 wwuKgmOOQnq+62rbjR7aiqbiE93al7QcVxO+nlRlX2TjpLtF+MZhbkPaJudySsrOIs
	 qCkRQiT5SxJT4asHrtT9DLghWJQBzGt9qGMIwhyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/276] mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes
Date: Fri, 17 Oct 2025 16:54:07 +0200
Message-ID: <20251017145148.100077445@linuxfoundation.org>
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

[ Upstream commit 019e3f4550fc7d319a7fd03eff487255f8e8aecd ]

The ipi_mbox->dev.parent check is unreliable proxy for registration
status as it fails to protect against probe failures that occur after
the parent is assigned but before device_register() completes.

device_is_registered() is the canonical and robust method to verify the
registration status.

Remove ipi_mbox->dev.parent check in zynqmp_ipi_free_mboxes().

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 136c1f67dd223..e64f7157f065f 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -618,10 +618,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	i = pdata->num_mboxes;
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
-		if (ipi_mbox->dev.parent) {
-			if (device_is_registered(&ipi_mbox->dev))
-				device_unregister(&ipi_mbox->dev);
-		}
+		if (device_is_registered(&ipi_mbox->dev))
+			device_unregister(&ipi_mbox->dev);
 	}
 }
 
-- 
2.51.0



