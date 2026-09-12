Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07545C6E5;
	Sat, 12 Sep 2026 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210081; cv=none; b=jSzzUK85f8csuHXvoZYsMQF983KNEn19d9dz6rhuFzJywUTbLUvpnVq9oxrpCNL6WGfvtxaXCa6GsOK4uYKCP5sxennBWUkOsauA7CU4vgFUaSvZUr9f1HUhUGQX+u3sYb/c+iAA/yedw8Q+fYIaMVJg7CGiq8bhn04h9LFrwBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210081; c=relaxed/simple;
	bh=jM4n8yDwbZQNEfmKJebGD9esWyoIOd2B4sSkcxrdjeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnSDxQgZQtwTXUrzuyz2VYiVfA5WF0dLVjnz97a6nCVgIpeOBVvkmn/jUB2x3Kl0S6jCMr6A1l6XwyuUQR6YpC3mkRwN9hVRjxDs+Lh4sCthmsQ3hggvMUsjhTS/QQmEhwHRpmiqyqBH0pOd5yv74Br7iT2QPuTIG/gCBKO6s70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzAEd0tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzAEd0tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A891F000FF;
	Sat, 12 Sep 2026 10:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210080;
	bh=lVWBfsfiZRp6WQjrguWCbPm+dB8mre/X3RQ8Gve3zcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzAEd0txHnNWa7jlOGI1hOTOUEbXgEOwWP7sn5LjOypAhtAl4e8t/Q4GbQ2FAPPXA
	 2fePqp+Q+5rbKNhIdBE785HenBIj+AmghdSW9FhDOCsMDNpbX2i7vj1QML6VIFJhsU
	 xwYh279y37W0XF3VXtZO1+6gnFCs96y0kBNPKlRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0952/1518] firmware_loader: do not queue completed sysfs fallback requests
Date: Sat, 12 Sep 2026 08:52:01 +0200
Message-ID: <20260912065644.993525947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit b48373c901951fad1a26bd7c33ad91172b3945b5 ]

fw_load_sysfs_fallback() calls device_add() before adding the fw_priv to
pending_fw_head. device_add() publishes the fallback loading interface, so
a userspace helper which discovers the device by scanning sysfs can write 0
to the loading attribute and complete the request before it is queued as
pending.

In that interleaving firmware_loading_store() calls fw_state_done() while
pending_list still points to itself, so it cannot remove an entry from
pending_fw_head. The subsequent unconditional list_add() then queues an
already-completed fw_priv. Once the request is released, pending_fw_head
can retain a pointer to freed memory and the next fallback request can
fault while validating the list.

Only in-flight fallback requests need suspend or reboot abort handling. If
the request is already DONE after device_add(), return success from the
fallback path without sending another uevent, waiting again, or queueing it
as pending. This preserves the invariant that pending_fw_head contains only
active fallback requests.

Fixes: 75d95e2e39b2 ("firmware_loader: fix use-after-free in firmware_fallback_sysfs")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://patch.msgid.link/20260716081601.1674470-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 3ef0b312ae719..00d6b6e594616 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -95,6 +95,16 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs, long timeout)
 		retval = -EINTR;
 		goto out;
 	}
+
+	/*
+	 * device_add() exposes the loading interface before pending_list is
+	 * linked into pending_fw_head, so fw_state_done() may run first.
+	 */
+	if (fw_state_is_done(fw_priv)) {
+		mutex_unlock(&fw_lock);
+		goto out;
+	}
+
 	list_add(&fw_priv->pending_list, &pending_fw_head);
 	mutex_unlock(&fw_lock);
 
-- 
2.53.0



