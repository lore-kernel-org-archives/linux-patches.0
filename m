Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879C13790B;
	Tue, 27 May 2025 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366144; cv=none; b=iqz6nQJxl8Kbf1TTJiVXoRdfEnBPHcBa8BoiOSz4t9pIn/Lt8HS/1z4K8jpseButruOcb78PWEqCnp1DdVobi2rbiubMVlxg/MfmlAR61NJ0frQksUFCTuXIZeM1vyWGT7X8PTngW0yK3fP9WtrenVKwvNCLm0grCzQSY8VwZVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366144; c=relaxed/simple;
	bh=albKVfX3+p+1rfLbFZJADBN/SEzkaA30d88xiH5eys0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpbyp/TlfFWev/A2/lu05iNBxxuEJF9s2NqijUuJjjDyA90+IIC+tHDIhxVhiZJzKq5JFWP9HqSKvbLRnqDPOZN1bVxdWmqiXqKibaV8wW7ZpIlifoQQWwqapOQn3P9IFPXszdVKbwWNpWUKrvHj7U/y9rnm/DTeG3lL3yQ767Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk3ktYct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk3ktYct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0F0C4CEE9;
	Tue, 27 May 2025 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366142;
	bh=albKVfX3+p+1rfLbFZJADBN/SEzkaA30d88xiH5eys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk3ktYctVcRRSpVxBqprqB00F34i9D60rSVmVKM0FMlgnj/U8BLLMKS37MwZE5gui
	 XchAKkU8f1WcykAE4DqC2TznVch0tuT9xXCQPrmOT4ZwNWVJRkHhpETItC9QlcshcQ
	 q4XDslkGQ4+lT2Q5a2gbyenz4dl/r3DU+kCsm40Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 604/626] Bluetooth: btmtksdio: Check function enabled before doing close
Date: Tue, 27 May 2025 18:28:17 +0200
Message-ID: <20250527162509.539138205@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


