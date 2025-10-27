Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9631D381;
	Mon, 27 Oct 2025 18:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590577; cv=none; b=sZMWEt77zXLkz7J4iWDTUD6c461RhMOblSM8s/eKo19586NKiWoeFhMqAt1FtsIiIo2xbmlSB4d2PKHBSkkjI7KEeCbgHmC7I/mILGd0rBhfhysaCz0i/6+DUbq3IjCzgLA6pNwU7nwN2XBCzPYFh5XuLUgYIBrNOmUVgCzS4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590577; c=relaxed/simple;
	bh=CP8rRaXsQmvIzVwrMP7P7PITJexVZ7Xk+ds0+0icPKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcS6MTR1Hq4gcSQ/0gDjS0E0CbeWh0w2ZsKH0UROTrFLV4B9MvOTuQNGdd6tzVoZsKMivL/op7kfKhUiRwE9TsJJ3C5UjmeutmytfNdeeKRrqtZeuBh0iqpoUUCjvnGz6L/L9pxU/Y9DSZFJ/aMCjhat1th5oIsqYquGYRbMu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZEN7A6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZEN7A6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC2FC113D0;
	Mon, 27 Oct 2025 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590576;
	bh=CP8rRaXsQmvIzVwrMP7P7PITJexVZ7Xk+ds0+0icPKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZEN7A6jKH0ZfNs44Bol0mA/EDgNuH8CJlB9bYgdz41/ldhQNkGuohItQswmETA9R
	 IpqOelD2wR7N8mFlXobaj1zaTFACgL/lqPlzI/NGxFyC/ds5eixcF97igU0ApFOjP8
	 iGDIX4FQDayJjBpoGlhKLpOt5zajawS+o0GMPeQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/224] mailbox: zynqmp-ipi: Remove dev.parent check in zynqmp_ipi_free_mboxes
Date: Mon, 27 Oct 2025 19:34:02 +0100
Message-ID: <20251027183511.559077890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8395f4013b111..dcabf38859ec5 100644
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



