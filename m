Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C9626FDBF;
	Tue, 26 Aug 2025 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215064; cv=none; b=AOZAATTQJSaYh49RYGgldpyUILAzE/47LPJYoi9/0t33D5MoIKb4Z0vS7j2/0pFuupyk1tyFv1zx76zUSRFgzU/k83YlVA2UIYclxAgAFrwpUCSIKU1ihK3SlkbsEVGUUc0IGD6QLrJK4YreYXDi5GwlkrHHp0v94QEXGxzc+N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215064; c=relaxed/simple;
	bh=fL/YotxKjVovk4b4b4ce2fbxqJZgEEnxGxqL6IvdTb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVnbr7sWyPDkXkIiRWsEXOuz4OK+YkQJra4Jo1/FiO5UjEQzLgwSCZmFWLzg/+eWWOtf5/+5sc7BFKqmV13DoaADBLVcYAY3VPoqlOmzngF8dEZ+ZAtVk/NIDgbR12CG/yLjiWVAX0MDigXwC+d281J8oj8jBYOVy1vtAOQTDzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJnAjWJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJnAjWJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFD1C4CEF1;
	Tue, 26 Aug 2025 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215063;
	bh=fL/YotxKjVovk4b4b4ce2fbxqJZgEEnxGxqL6IvdTb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJnAjWJWwL4el0LRP0Ry4wJl7C6kcye7YMeGZQExBIacGB2XQe79F4XQ0Imh2Yapv
	 4Rb+cPVVEajHOxzORPWNvYeGwRD7J98t8kHcFKtKUTUbbtjSjb+T03VUx4a1ql0aHC
	 SXVNPGzC2rHys01UE0XAWytgx+iPBc8vgj0bQq8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/482] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:10:26 +0200
Message-ID: <20250826110940.047982546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -311,6 +311,9 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
+	if (ec_dev->mkbp_event_supported)
+		blocking_notifier_chain_unregister(&ec_dev->event_notifier,
+						   &ec_dev->notifier_ready);
 	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);


