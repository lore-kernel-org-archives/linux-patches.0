Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3112B176;
	Tue, 30 Apr 2024 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474293; cv=none; b=itipt1Kw0q4AgPJH8WaIxJvYbNqHPnbqCITpCxomUy99j+CsnrGeMeINsEUV7gx4BwZImwh9PlzrhuqH6jnUmBBG1r8MpvMSI7KiH+1sQheQpBsDtBcA0RbQUzoj4bObzj5aIIF8NhC7x2qYT0BLGfPrt6YkdvY9u123XGjTNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474293; c=relaxed/simple;
	bh=rzYsLSJduh+nEkn8UkuFwGvrZsUJXSiVdh89UB0aN9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7CE1Ux+4i4/7y7y0opHrMkSsK/ClzmMUkxo0EqiaofdLqi2SgN2Bo1mjLqWlcgdR2+phw7fam88VR5PDM1X/cUnzPJG+rb3ggaCbOqqE/76xmq6NUJqV3n4g0jkKaS8PWPtkevCN29v5+XbSZOSed2Nc5F2XeYWtHNaNeGsqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESXbZQYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESXbZQYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC459C2BBFC;
	Tue, 30 Apr 2024 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474293;
	bh=rzYsLSJduh+nEkn8UkuFwGvrZsUJXSiVdh89UB0aN9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESXbZQYiGQx4Neml+Rgp0OT5BoDfOAv25dnhm85MzKIA2s3FnZgXoKkV5xd/PRBcM
	 z1wyCVLatTjR4xqt6fDC6JlXbIn/FTWWAlvjwbCuvVGZJ3BxJesAVrwOxxbM1ANcF+
	 H4eCA+FvEcPv6zkuzcIl5dv2vYeEhm2bYt88X4BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 115/228] dpll: check that pin is registered in __dpll_pin_unregister()
Date: Tue, 30 Apr 2024 12:38:13 +0200
Message-ID: <20240430103107.128134573@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 9736c648370d237f61065a7e45e668e2db4374e9 ]

Similar to what is done in dpll_device_unregister(), add assertion to
__dpll_pin_unregister() to make sure driver does not try to unregister
non-registered pin.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://lore.kernel.org/r/20240206074853.345744-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 38d7b94e81d0 ("dpll: fix dpll_pin_on_pin_register() for multiple parent pins")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index c751a87c7a8e6..3e6282937e35c 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -29,6 +29,8 @@ static u32 dpll_pin_xa_id;
 	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
 #define ASSERT_DPLL_NOT_REGISTERED(d)	\
 	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
+#define ASSERT_DPLL_PIN_REGISTERED(p) \
+	WARN_ON_ONCE(!xa_get_mark(&dpll_pin_xa, (p)->id, DPLL_REGISTERED))
 
 struct dpll_device_registration {
 	struct list_head list;
@@ -651,6 +653,7 @@ static void
 __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		      const struct dpll_pin_ops *ops, void *priv)
 {
+	ASSERT_DPLL_PIN_REGISTERED(pin);
 	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
 	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv);
 	if (xa_empty(&pin->dpll_refs))
-- 
2.43.0



