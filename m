Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66C52FAC1C;
	Tue, 26 Aug 2025 11:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208205; cv=none; b=lq/w4gS7s/Tt9E0+v8SHD+/Cy/Ib8RMlLL+n5cK8BCnRxa7pE61/LJ3WZZEBO1SpQDuWxbYjgmNpmbZLv5QPNm1okmqq8NwF07R29RpSZe6tS8Nzv8r8Ijck1m6RHvQ7w9Wb9OuaITb5KVgIM4HILPNQRXEoICXZf41UYMZeP4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208205; c=relaxed/simple;
	bh=G/jWzNjHDxs3dPUyyEo+TIwNjBX8uK5vSYx+7mNWuxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLpQ6HRiOTM5smkFoknUcqvcqUFISz/Rhl23BIp4Zd6yRrsEAt49dwOhsfd1H6XKn8l8TQJGzxiMlwT3W2sM3I1PIyuWfB+rlYmT8AesBrAdaaibpB87ZxQaZ9ObdWfpVanEwAu9d3MHapxkJr1atPaywe3sVYMdZYBdKsLFgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4AW2EhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4AW2EhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3711BC4CEF1;
	Tue, 26 Aug 2025 11:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208205;
	bh=G/jWzNjHDxs3dPUyyEo+TIwNjBX8uK5vSYx+7mNWuxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4AW2EhEp6RXFv/QVCcfiHMi5VBBDaBMoCBLe8xsu2C9QtKHnGhYUU4IEB0su2ygq
	 bZW2zWzWgWldz4zPNrsWRzLrYM7tbDrhR8rjdFNcu+KLQL92VLbIAvd+vRmMTX0zm2
	 Kga6hhrKPMyjnaqfSQju6AzRie5onCtpJYO3Fml4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.12 004/322] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:06:59 +0200
Message-ID: <20250826110915.303181560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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


