Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCF72627;
	Tue, 26 Aug 2025 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206999; cv=none; b=FIqVa1YfQ8JMMhNGBqQmboxhsxNGILTdEZGL09hYw718XE+OP+kUKxD2+jAvgbE/pj72VVN2sper1pTs37Tfp93XpeBpLJKJSmmhm4ClwXzsc9f6JP5kJeAUkuE7dtyZEVX+rVHy60eEAmIDkgr3hTZO/w8ohkWMzkeNsymzLb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206999; c=relaxed/simple;
	bh=zCCZcwhGP8v3c2pQkQ40DleJuRqPhiaDmxRWgdntOMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdtFL5DxJoMBZcJ5x4tgZfB5c4pY/7GkFP97t2tkNWlvpAoKVTGCUqaQceAeBFUuyht2YZQZdJYgiWFfC6ZGtHLByF7CGUtI8mp1BHO00ziIgn2OCrQKhenyEs28x8RQ23Cd5jY7R142uw6HuyaaKy7RAtiJOaQU5ix2v+BY/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqLBAEQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqLBAEQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82258C4CEF1;
	Tue, 26 Aug 2025 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206998;
	bh=zCCZcwhGP8v3c2pQkQ40DleJuRqPhiaDmxRWgdntOMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqLBAEQ21zWN/VMBEaHzUEiIzk/siZBfdv4IeRahquUgZWteh0EAkZcWQ+qEDZvL6
	 nA8su8D6gZNLtrvnlPAJ/W9j1rmrLZ3TGvtbjknauNgv+caWt9mpvcXDrfw/rDWUHt
	 jRC/LNKhMCfGr4FM1q4EW6sQfvSsLSEhQOoNfkb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.16 004/457] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:04:48 +0200
Message-ID: <20250826110937.408675512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit e2374953461947eee49f69b3e3204ff080ef31b1 upstream.

The blocking notifier is registered in cros_ec_register(); however, it
isn't unregistered in cros_ec_unregister().

Fix it.

Fixes: 42cd0ab476e2 ("platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250722120513.234031-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -318,6 +318,9 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
+	if (ec_dev->mkbp_event_supported)
+		blocking_notifier_chain_unregister(&ec_dev->event_notifier,
+						   &ec_dev->notifier_ready);
 	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);


