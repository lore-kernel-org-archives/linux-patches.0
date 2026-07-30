Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBA83C1D6D;
	Thu, 30 Jul 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421651; cv=none; b=aQyf9j3FLhrznMea8HfImM5Ylwq7AZjpPcakJhLvF3QSrehmYazUvaAAFmT2VkJ6098KUCnJ68YBNfly48z8yxTC6ce4Y/3gr9Uuk33FbjDTVSOYdP+G/16uTjq6hAvIPUYFmlhGzS43UGDsHwL+puJM+E9KYU5eekZpPqFVp1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421651; c=relaxed/simple;
	bh=CsiLHLjmG3/B7p/YV00RuoyRqD2i1HK/6B1IKsvnGb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojNX0TUw24hH5v69N7w/ItLTm6Pc1yZ/o0eK+29PDT/lHgwC1Po/4i1GFNLEuk2wnMXP2mL7vZKPfVNoLZ1zVpgCWnNBl/rezSUmD1cXH9YCfmOTiBf3xZnNepPKFDUsLg8rjnuagzCezVIQ5VbxVdWPPkp64BVUbABx/VIuqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0XWoh1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0XWoh1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D80C1F000E9;
	Thu, 30 Jul 2026 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421649;
	bh=GgMYcG9j+UAqPf9HSlGqBd+uKkblcnLFR44dM6p0784=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0XWoh1NxSV/86ZCVeJPh+1qdZoMMLB4z93P6I0NSkzCEFLUso/x8wtx52eThnE8F
	 4CZT6OTmw6Acksks2sJww3FtULisyYBWF/2rhNDuf2UJvo8yOxYue+jNasLZvcuZEF
	 1BzNK4XdCnbaU+N8/Tz9FOUR9MXIzyDrmmm4SPmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 131/744] dpll: fix NULL pointer dereference in dpll_msg_add_pin_ref_sync()
Date: Thu, 30 Jul 2026 16:06:44 +0200
Message-ID: <20260730141447.064954019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit d2e914a4a0d0f753dbae830264850d044026167c ]

When a dpll_pin is shared across multiple dpll_device instances and
those devices are being unregistered (e.g. during driver module removal),
a NULL pointer dereference can occur in dpll_msg_add_pin_ref_sync().

This happens under the following conditions:
 - A pin is registered with two or more dpll devices (dpll_A, dpll_B)
 - The pin has ref_sync pairs with other pins
 - During unregistration of dpll_A's pins, a ref_sync partner pin is
   unregistered first, removing it from dpll_A->pin_refs
 - But since the partner pin is still registered with dpll_B, its
   dpll_refs is not empty, so dpll_pin_ref_sync_pair_del() does NOT
   run and the partner stays in the pin's ref_sync_pins xarray
 - When the pin itself is then unregistered from dpll_A, the delete
   notification calls dpll_msg_add_pin_ref_sync() which finds the
   partner in ref_sync_pins, passes dpll_pin_available() (partner is
   still registered with dpll_B), but dpll_pin_on_dpll_priv(dpll_A,
   partner) returns NULL because partner was already removed from
   dpll_A->pin_refs
 - The NULL priv pointer is passed to the driver's ref_sync_get
   callback, which dereferences it

 BUG: kernel NULL pointer dereference, address: 0000000000000034
 Oops: Oops: 0000 [#1] SMP NOPTI
 RIP: 0010:zl3073x_dpll_input_pin_ref_sync_get+0x73/0x80 [zl3073x]
 Call Trace:
  dpll_msg_add_pin_ref_sync+0xb8/0x200
  dpll_cmd_pin_get_one+0x3b6/0x4b0
  dpll_pin_event_send+0x72/0x140
  __dpll_pin_unregister+0x5a/0x2b0
  dpll_pin_unregister+0x49/0x70

Fix this by skipping ref_sync pins whose priv pointer cannot be resolved
for the current dpll device.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260710193625.1378822-1-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 75e3ae0c16d077..8163521188c06c 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -557,6 +557,9 @@ dpll_msg_add_pin_ref_sync(struct sk_buff *msg, struct dpll_pin *pin,
 		if (!dpll_pin_available(ref_sync_pin))
 			continue;
 		ref_sync_pin_priv = dpll_pin_on_dpll_priv(dpll, ref_sync_pin);
+		/* Pin may have been unregistered from this dpll already */
+		if (!ref_sync_pin_priv)
+			continue;
 		if (WARN_ON(!ops->ref_sync_get))
 			return -EOPNOTSUPP;
 		ret = ops->ref_sync_get(pin, pin_priv, ref_sync_pin,
-- 
2.53.0



