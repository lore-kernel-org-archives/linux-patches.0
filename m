Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48518471268;
	Tue, 21 Jul 2026 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664640; cv=none; b=muaTzpS3nLFEMf12/wckxu4o/4bNVDu2N3gkX8qjmLYz3gsm2Td4xtglo72iv4QEHHR4uFK7tXNttfbI2rTAyS1o8fJvnGCCHLJsE6K1kNdEPeWERrKkU7juuKS8uAh3d2ghxqxd1q0UXK9JzEUMd/BrwUnyEhzxSY5f2KxZdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664640; c=relaxed/simple;
	bh=EkpsK32LIHS9uyuVv7XkFO9zOlD565U7h1avbe6Uj74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exwoSjchJPB/m5JViwy/PPmr+PGU4AqCMHTnrRA+eK1nwNslkigHAnGVHhoFA6Nm56eorhJplDvhwyHuw4YXIzeC/ip+JSdbq+n08kjctl7L8yC13aI50wcBvUKdWVWY3R5ImGmIaKehU5AAn7q0bTsgx4k+acw56UMfrTmBzpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPJi0xP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPJi0xP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ECD1F000E9;
	Tue, 21 Jul 2026 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664638;
	bh=3NTjJO8GPUWeTuSxYL6T0hXvfNTR7uLhRiVL6iqfSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPJi0xP2CohEJDdR6kyEv6i2sMRWBSVpTxuVhMLACrqEKK6Y4Lu7XdLxMMeDLb6ES
	 AFwbR46ZClvbofaqDdxZKdyvFPmGb6mHQE0B5FupIxeI8W8BQPjvwE9914vlP+urvq
	 Fa9Wqy1uuSHk9x/54CpKW2Z0Kb21ZEBtELKaBgy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1275/1276] dpll: fix NULL pointer dereference in dpll_msg_add_pin_ref_sync()
Date: Tue, 21 Jul 2026 17:28:38 +0200
Message-ID: <20260721152514.621051804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit d2e914a4a0d0f753dbae830264850d044026167c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dpll/dpll_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -424,6 +424,9 @@ dpll_msg_add_pin_ref_sync(struct sk_buff
 		if (!dpll_pin_available(ref_sync_pin))
 			continue;
 		ref_sync_pin_priv = dpll_pin_on_dpll_priv(dpll, ref_sync_pin);
+		/* Pin may have been unregistered from this dpll already */
+		if (!ref_sync_pin_priv)
+			continue;
 		if (WARN_ON(!ops->ref_sync_get))
 			return -EOPNOTSUPP;
 		ret = ops->ref_sync_get(pin, pin_priv, ref_sync_pin,


