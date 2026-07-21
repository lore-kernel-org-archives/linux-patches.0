Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C6436344;
	Tue, 21 Jul 2026 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659861; cv=none; b=bR7JpmRJ1NADbZsKqKnyz0Ui91OX3tzthnRPtqkK5xChAE6iQOXGklF4vFPVg0oskZSbjOzi9IfaVzCvjAlwvEFYZO+UNGwG7jcVQ9zu8Xy/VJjLPRDmTe6tYmbwPUYXUqdLhleDHMjXp36jFlqJPKq7yZbr0lxFM4YcCOWVa18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659861; c=relaxed/simple;
	bh=03Eg0z2n2dnRaw/LFj0X/Y5Vl0JNowv8h1IZFbXy8Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAa+H9Y41PMRQ5odWyRnVD3OqRvopU0hSEKHi6aAdVYLMWo+FtnqmggHErvbivTY5FyrMixO77WCmrcCyLZp+/5GriFMf3FnV+ysiQX1y/hnmaygEd3MGPTsHgHw6vCS/gtNCGC1O50JluDn+zraIuTsNcx1+qLhVZBGARUJZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ra+h99Q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ra+h99Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F9B1F000E9;
	Tue, 21 Jul 2026 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659860;
	bh=s/vaK6He/RRQUw3fZ5V72CfMPS+GgyVzyD20lpz2M3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ra+h99Q4zNlHWk+JZY+fDPIbwTkRGFlMD8HeV86gUsWegEL5Akdq7jFAu/FP3AtgS
	 RSBZGmxn5WcNH4tpppxSFDRD3CNlFDaORHv9TNBy5NuYT9YRD3zqazSWb5ZqaFwNf3
	 0QrDDsJ77tdrB3LmNo0c8ystICm4j6wkkiaBjnE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0761/2077] dpll: emit per-dpll delete notifications in dpll_pin_on_pin_unregister()
Date: Tue, 21 Jul 2026 17:07:14 +0200
Message-ID: <20260721152610.744226193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index a58977c87de193..ac9654b42b77ca 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -1023,14 +1023,14 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
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



