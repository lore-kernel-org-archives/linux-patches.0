Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165192F25EF;
	Wed, 28 Jan 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615902; cv=none; b=NkOGsKNkxfiut8YSewfVZWHyluMUoGp6czirNe84CTuUK9Mv3kBzRAS9WaxejDxFzRKrbQj7HqOU230k6iwNhuvyh0FfZe2UgWyXknwCM6M2LJBi0OUPeCXe1JHsLjK4aAC3pH3T7bDRbrZLYF8Ev8rzY+vCCHcit04Ec95u2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615902; c=relaxed/simple;
	bh=jcLFlCmQswCHJQeSdohlRJlhDDhS1AIgOtuHgDAgSe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxiGMHAfHgbZ7MsftsIIW+6Tc2gaFI/nnDgSDPGv3N3qG7McN4ZXAf9kS4R7kOC0WzjSnEpVg2ISJTRvuQy342MDNdhy/HcBuIOot+Hagig+kmxzGZ6nkWUpYIS28qowFP8Dar4IJ5ZhanG0sWKMow2NqhLj3RHk/5QNy2AX50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtrrPeFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtrrPeFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503BDC4CEF1;
	Wed, 28 Jan 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615901;
	bh=jcLFlCmQswCHJQeSdohlRJlhDDhS1AIgOtuHgDAgSe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtrrPeFshl1erXVX4AV13TCG7RrJiGPjhkr62f42Mno73w21G5sawy4YdB7yAXlTW
	 LcbiBYSZpVng3wx3+kXJqDFFPi6gIM5yenCXvtcU2/t3KbFs6uU8HC9454rrbmhKwx
	 xINVzk+xh8JPJpomlztDWTzDwQMxXmzwcgVycbME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/227] dpll: Prevent duplicate registrations
Date: Wed, 28 Jan 2026 16:23:13 +0100
Message-ID: <20260128145349.782687869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

[ Upstream commit f3ddbaaaaf4d0633b40482f471753f9c71294a4a ]

Modify the internal registration helpers dpll_xa_ref_{dpll,pin}_add()
to reject duplicate registration attempts.

Previously, if a caller attempted to register the same pin multiple
times (with the same ops, priv, and cookie) on the same device, the core
silently increments the reference count and return success. This behavior
is incorrect because if the caller makes these duplicate registrations
then for the first one dpll_pin_registration is allocated and for others
the associated dpll_pin_ref.refcount is incremented. During the first
unregistration the associated dpll_pin_registration is freed and for
others WARN is fired.

Fix this by updating the logic to return `-EEXIST` if a matching
registration is found to enforce a strict "register once" policy.

Fixes: 9431063ad323 ("dpll: core: Add DPLL framework base functions")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260121130012.112606-1-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index a461095efd8ac..8879a72351561 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -83,10 +83,8 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 		if (ref->pin != pin)
 			continue;
 		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
-		if (reg) {
-			refcount_inc(&ref->refcount);
-			return 0;
-		}
+		if (reg)
+			return -EEXIST;
 		ref_exists = true;
 		break;
 	}
@@ -164,10 +162,8 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 		if (ref->dpll != dpll)
 			continue;
 		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
-		if (reg) {
-			refcount_inc(&ref->refcount);
-			return 0;
-		}
+		if (reg)
+			return -EEXIST;
 		ref_exists = true;
 		break;
 	}
-- 
2.51.0



