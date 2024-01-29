Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865515A48D;
	Mon, 29 Jan 2024 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548134; cv=none; b=AEChiJvmsoNsbvNUfr1JTSTmULOaOj0UOi67ZnuX36uLDPh6fL5nmIsW26Lgu1FFeunKKktWaSPa7J7OuN4HI+XIcArsPFcpJnV6ilXqpi2GpM/seN7I5lWKuANq5EshMlEMEeBeWYzhyJ18cwSQTvM+XC6eBLtFA+YkwA2B7uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548134; c=relaxed/simple;
	bh=1Jcfaqt32XyjvhaIlK8GzRRu6mG5GCzNFI0PDy9+otQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjJsYGxX9s66IawCwS43hp7KUhuVwpIIvW8IIkrTi08/3+iIf8wA4UTkpkcm+hxhD1jZK1PDN3kpFuwylZAaCQFuLBI4EXa8GcllH3WiU+muvYQwkrbfvz7GCEP7iV9ga+pF8hBa+dwBp+73j3viQqhIQBy9Xvk7Scm4ulkjm/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGbZXHKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGbZXHKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01F7C43390;
	Mon, 29 Jan 2024 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548133;
	bh=1Jcfaqt32XyjvhaIlK8GzRRu6mG5GCzNFI0PDy9+otQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGbZXHKiSk0sYsuiQIZW6lj8cDGumhq89ENifoI30wuoQn62z9a4kq7hmT181bxHv
	 joFETg9QMXz02ch5UOd0jL+V4EOGaaa4F0MH9j/bgl96tRzD7DNNseXXfwSIcunftQ
	 bRPsA8Uk8zO+Y6xaMzCRtD7G8ZshmWW6yamhLfY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Glaza <jan.glaza@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 164/346] dpll: fix register pin with unregistered parent pin
Date: Mon, 29 Jan 2024 09:03:15 -0800
Message-ID: <20240129170021.222816429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 7dc5b18ff71bd6f948810ab8a08b6a6ff8b315c5 ]

In case of multiple kernel module instances using the same dpll device:
if only one registers dpll device, then only that one can register
directly connected pins with a dpll device. When unregistered parent is
responsible for determining if the muxed pin can be registered with it
or not, the drivers need to be loaded in serialized order to work
correctly - first the driver instance which registers the direct pins
needs to be loaded, then the other instances could register muxed type
pins.

Allow registration of a pin with a parent even if the parent was not
yet registered, thus allow ability for unserialized driver instance
load order.
Do not WARN_ON notification for unregistered pin, which can be invoked
for described case, instead just return error.

Fixes: 9431063ad323 ("dpll: core: Add DPLL framework base functions")
Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Reviewed-by: Jan Glaza <jan.glaza@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 5e3b9b5679f9..f8fbf0394288 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -28,8 +28,6 @@ static u32 dpll_xa_id;
 	WARN_ON_ONCE(!xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
 #define ASSERT_DPLL_NOT_REGISTERED(d)	\
 	WARN_ON_ONCE(xa_get_mark(&dpll_device_xa, (d)->id, DPLL_REGISTERED))
-#define ASSERT_PIN_REGISTERED(p)	\
-	WARN_ON_ONCE(!xa_get_mark(&dpll_pin_xa, (p)->id, DPLL_REGISTERED))
 
 struct dpll_device_registration {
 	struct list_head list;
@@ -614,8 +612,6 @@ dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 	    WARN_ON(!ops->state_on_dpll_get) ||
 	    WARN_ON(!ops->direction_get))
 		return -EINVAL;
-	if (ASSERT_DPLL_REGISTERED(dpll))
-		return -EINVAL;
 
 	mutex_lock(&dpll_lock);
 	if (WARN_ON(!(dpll->module == pin->module &&
@@ -693,8 +689,6 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 	    WARN_ON(!ops->state_on_pin_get) ||
 	    WARN_ON(!ops->direction_get))
 		return -EINVAL;
-	if (ASSERT_PIN_REGISTERED(parent))
-		return -EINVAL;
 
 	mutex_lock(&dpll_lock);
 	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
-- 
2.43.0



