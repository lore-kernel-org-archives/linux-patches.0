Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9DE27E7EA;
	Tue, 27 May 2025 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368624; cv=none; b=hNvVR6rR46V8bnpq4BENoTLNWBzLITug6pFVCnHjhhOS6GGlCqwOIf/Puk07KIuuUHfhq0IyjBKQ1AYIC6WloQ48UVoIGsxghUpHn8ACW4cKzeFSu90xlQmLSy8tWuGcKsmkGDeNRQTOD5bHKZXFN7+04dgznh/AClW/PaLxpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368624; c=relaxed/simple;
	bh=PjDdg4vk8FhfExbaA4m3+W8loObvJwulsCUM6O+a2oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4veHqfzk33LeCVL+InnUHfCSa1LOfWv4iZDiPujjEMtaYFyTUNepoEX28C0Ik5t8987hFkkZn/1MVVcdhu8peFlqP+w7QeNFpVtiBtbQ/yXuYUXWmHYqJS3VhQZEPro1zKeRv3K6Ouiy4/hg4Si6kHl1Gzs3XjqDSwY58tO1AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xf9xVfkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xf9xVfkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5965C4CEE9;
	Tue, 27 May 2025 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368624;
	bh=PjDdg4vk8FhfExbaA4m3+W8loObvJwulsCUM6O+a2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xf9xVfkM0EEMWnYxBXWOipRvp7BY5WjqLt80WalINjhVyPPPVltg05In23b44wtI2
	 +U9u0obmTnWXa9c9bz06LvNTGM4RJ/mqFaljFeerVUfDoKTjn2+p4+M8mpPMcVZNZy
	 RvkHrkJZ889kFWLwqIQ2M+gd4YMqb/sSYH2K47f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.14 766/783] Bluetooth: btmtksdio: Check function enabled before doing close
Date: Tue, 27 May 2025 18:29:23 +0200
Message-ID: <20250527162544.331470856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

commit 07e90048e356a29079fbc011cfc2e1fa1d1c5ac9 upstream.

Check BTMTKSDIO_FUNC_ENABLED flag before doing close to prevent
btmtksdio_close been called twice.

Fixes: 6ac4233afb9a ("Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtksdio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -723,6 +723,10 @@ static int btmtksdio_close(struct hci_de
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
 
+	/* Skip btmtksdio_close if BTMTKSDIO_FUNC_ENABLED isn't set */
+	if (!test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
+		return 0;
+
 	sdio_claim_host(bdev->func);
 
 	/* Disable interrupt */


