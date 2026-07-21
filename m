Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34A42DFEC;
	Tue, 21 Jul 2026 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662310; cv=none; b=Hgm1bcMRtbNiCRyXXFB5PEajPGSNjusdBzS9n7j7P54jKejKwMfdKVk2FUsV1JVc2zGn1S2F2DjLM8Pw56fVOrRRasEhPAZSvZuWTdnqkDIxPyYK1CrYe4HGLC31YKTYcIOffEmhQb1Vbef99cRAAmhL/qHEaPeG/KV8G9OQmqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662310; c=relaxed/simple;
	bh=olsS+tNkxD32FRje5UDdhjduqH2IatLOfk6BqB+qjIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGMXrNqluCDawlD8Iri0nC/3pHzvbuNPJL5jQIRQ882+w9EAuaTTSiJCbdCEDhAKhoVgL7dhN9Nz1SGdPlsZg87s7HvdKlP/+Fhn7MXWDldYPFef/C+Os7HY8zzh/66l38qt4qGS/y7MpFB1Yq/Or3z8350cU+S/zvOFCMH7NLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMANdL+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMANdL+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316331F00A3A;
	Tue, 21 Jul 2026 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662309;
	bh=uisYmv1NQVdDy/klIFbZq9xYNPJYBP9/TVZlPRY/f+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMANdL+2T1MczmCcN23+wM4ftxqOz1IpGPx6Xe91hyxAvkVK3rLYz21iQuezQlSQI
	 LgcXVKrWVFXN25pK47ClYIKgiFu/ZXd/ABt8Dzug21ETmvtCUYa5+vWNAmILQbTM0k
	 n+pp7TQsYRPRuL5rIFfqb/lnTWvD909ZE4iF2Odw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0369/1276] dpll: send delete notification before unregister in on-pin rollback
Date: Tue, 21 Jul 2026 17:13:32 +0200
Message-ID: <20260721152454.365835797@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit e83b403eb142be18d223fc599c0ac45519053671 ]

The rollback path in dpll_pin_on_pin_register() called
__dpll_pin_unregister() before dpll_pin_delete_ntf(). When the
unregister dropped the pin's last DPLL reference it cleared the
DPLL_REGISTERED mark in dpll_pin_xa, so the subsequent
dpll_pin_event_send() failed dpll_pin_available() and aborted with
-ENODEV. As a result userspace was never notified of the rollback
deletion and remained out of sync with the kernel.

Send the delete notification first, matching the order used by
dpll_pin_unregister() and dpll_pin_on_pin_unregister().

Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-5-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 241d0e906a6e81..9fdfb7617126c7 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -937,9 +937,9 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 dpll_unregister:
 	xa_for_each(&parent->dpll_refs, i, ref)
 		if (i < stop) {
+			dpll_pin_delete_ntf(pin);
 			__dpll_pin_unregister(ref->dpll, pin, ops, priv,
 					      parent);
-			dpll_pin_delete_ntf(pin);
 		}
 	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 unlock:
-- 
2.53.0



