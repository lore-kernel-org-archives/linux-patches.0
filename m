Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A5B41B8CA;
	Thu, 30 Jul 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423696; cv=none; b=PG3iw+vjR3ZSY4VzDgXS2sr6uxYBALqDFw49/e7hqaiwMCWDNqE6uXi+PXtn2Dfq3aMmwjdsjpaWFxkP2G9FJtbpIXbI9KO4txujwuwZAWiHbntiHxXQ3043zzhaLk4G3t2/pkgdstIA3eRe7qGYeupuYNkGF1eRfF4jYXNfENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423696; c=relaxed/simple;
	bh=UzClH3+TGiDHNDa614fR2VmMX49OYagMschUIqe/q94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abc1bVywM83NJ57h7nbMeKpbdYJ+d43+1i+ShEgCdgfCe5RdyA1CACpB9BEyLexESyKj2ZNTxfgZWmGxN2G428DVluzyiX6k3+ZwXoQJAJlyhNgbOizGw67AFWmEeZDs5BzlykUbg++8tHdGcLYLr1Tqw9+ndkjHjkFtKezNyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px68dOrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px68dOrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3046C1F00A3A;
	Thu, 30 Jul 2026 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423694;
	bh=NIOhRy8nM+l9yi+IaxsSJFdniHiteV+N+g2C3l20Feg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Px68dOrY2wXQLTvMv+LMggqgsAAnu7IfcEwnJNi7dMUZxFUHuqWutCybsV3c6aHby
	 1B23fzDHyX3I8qHVLEtuHimHnuTbhtBs0k5Qa/jZVcjcNjgXEIBgsW9BPpN2mhQ671
	 BFaJWPytzecWDA3z7ciO7BxQyCYFl8Wfx/smJQsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/675] dpll: fix NULL pointer dereference in dpll_msg_add_pin_ref_sync()
Date: Thu, 30 Jul 2026 16:07:45 +0200
Message-ID: <20260730141448.009544380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index de8b065280d15d..eb23ee401aaef8 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -486,6 +486,9 @@ dpll_msg_add_pin_ref_sync(struct sk_buff *msg, struct dpll_pin *pin,
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



