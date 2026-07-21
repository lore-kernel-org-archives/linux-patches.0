Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DE474AF0;
	Tue, 21 Jul 2026 17:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656796; cv=none; b=eDydShWZu1P3Mzn5IS1epx1DzsmLzG2KnkpRWsxHk8zhf7X9fUPsA3AEfymhQGS/aKZZcBdOmqnRrPtXyMdM4N5vkVPAPaVmP32cETFvbHPtX4RRW8e5W6lB+70DoC5yFhxJ4hq6fDlQ30X7ZM/IsC4c0Q4N9DcPAFSIsy6+G5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656796; c=relaxed/simple;
	bh=S8b/XRN73IM1ezlJC473dh9LWe7OW17+n0CgRddZVXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+g7nng1HW7KZHMIH1/ouEtKRkSrV6d8Ifjj9nvXyb6qF3oDj3CUHwXpkacMFCMxA8XYnc3wuvGShwtSt8syY6fttmx5bTBFt+pRUpiAJYhqnnUPZDeZ4jsDqh8jE2rhJkRTnWkx7Qiq1nQY5HGy7bpSjzVovPuKoo/kUVVpaj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6ZeIhFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6ZeIhFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AD51F000E9;
	Tue, 21 Jul 2026 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656795;
	bh=LuhBp/bahKBOYh0ockPTjW8rC7c49caEn3fhKUHeLuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6ZeIhFabCNuvnD8JzvBvaCyTMiJul7nUrgJNkt7Jv5lMrkjvqHhP7gJHvmdZreFY
	 KbEN8MqZ/5fxjV/C7FkUpaCAKml3niCuJMQiHXzDF0VaavMruqykC2Ew/93hXB1ykm
	 DqHQycAiQf+iVCPiLm7arZ3xLumpQUWeUhp6l/ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0523/1611] dpll: emit per-dpll delete notifications in dpll_pin_on_pin_unregister()
Date: Tue, 21 Jul 2026 17:10:39 +0200
Message-ID: <20260721152527.111804294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit df0ba51ccf873e533669578104981109217d8201 ]

dpll_pin_on_pin_register() emits a creation notification for every
parent->dpll_refs entry, but dpll_pin_on_pin_unregister() emitted only
one deletion notification outside the loop. When a pin is registered
against multiple parent dplls, userspace sees N creates but a single
delete and leaks per-dpll state.

Move dpll_pin_delete_ntf() into the loop and call it before
__dpll_pin_unregister() so the DPLL_REGISTERED mark is still set when
dpll_pin_available() is consulted.

Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-6-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 9fdfb7617126c7..08b5055ee09cf5 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -966,14 +966,14 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
 	unsigned long i;
 
 	mutex_lock(&dpll_lock);
-	dpll_pin_delete_ntf(pin);
-	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 	xa_for_each(&pin->dpll_refs, i, ref) {
 		reg = dpll_pin_registration_find(ref, ops, priv, parent);
 		if (!reg)
 			continue;
+		dpll_pin_delete_ntf(pin);
 		__dpll_pin_unregister(ref->dpll, pin, ops, priv, parent);
 	}
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
-- 
2.53.0



