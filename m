Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E031DE8BE;
	Tue, 26 Aug 2025 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216865; cv=none; b=skIEYJTexSbh1H1NS2RLWQcn+c+e9g2jLBurSmpuft8zBDEVbI832BsTxvknWiF7A13aU4BZuZrkVv9ONizkFDqZO9xPRipWMgS6/H4uxD3x4EQzGajuA2BaeOlaFCIdk2sFEGKHsxwEwS1d2LC+7rt3vkErtj4W+nLnoND/Nzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216865; c=relaxed/simple;
	bh=UxN8ETDZMknVOfCWssRjmkRvLBGojHQ8EVbbtitdO7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGkXilNQG8cMDDB63BV98ajfYvbPKKU7PmGh/aP50GyZuM+p9lpZ8zVAvM8Ayth00Kd9dtShrysHvsBorPJIGWXNkaeMf4XhsqQjOJT1nhZHJkry//1yhqJTIBLxYhcLul9I46OznBggpd58dBOjQnT+t7HhykIDZg8l3JG0vXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaJSuH5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaJSuH5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A760C4CEF1;
	Tue, 26 Aug 2025 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216864;
	bh=UxN8ETDZMknVOfCWssRjmkRvLBGojHQ8EVbbtitdO7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaJSuH5EimDBDNMXOAFm92R2Z+hAA/k2gdtJqnWXel6a8PN8bRip7FabI/AH5+go2
	 Ms3Ev55CnQlAOAUug+BxpUmbxMiiBKiN5Cgc7XkbUKrbNpZb6IlRkD6MPW+EtS+MmS
	 /LjDuKvncKMkGzrxtU8sAwdr/juoVsNmnT+rNm2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 540/644] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:10:31 +0200
Message-ID: <20250826110959.897687764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit e2374953461947eee49f69b3e3204ff080ef31b1 ]

The blocking notifier is registered in cros_ec_register(); however, it
isn't unregistered in cros_ec_unregister().

Fix it.

Fixes: 42cd0ab476e2 ("platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250722120513.234031-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -313,6 +313,9 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
+	if (ec_dev->mkbp_event_supported)
+		blocking_notifier_chain_unregister(&ec_dev->event_notifier,
+						   &ec_dev->notifier_ready);
 	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);


