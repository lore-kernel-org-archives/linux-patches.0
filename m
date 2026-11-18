Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029506;
	b=nnCLI4V7lpOSKceAkK5awi/GjQi92pakLiZ78WbMi21riuBN9vX0lP0qdnhQp8xSbQ+B
	 mArNmj9DPPgt9MUSBfdbbwJ1UcPwK3X8WaulkaNZ6rXjQmfJqY6R+KFsIntq6EP8VoAyj
	 Zwv4eUUih+TqUSTt4B1+BwVat5DjOpZogKsqGuSa7S94DNi9/yeSYTFA6ADzGvZDYbCBl
	 07spE9ShNZe7pAtxi6ZPynSz/iPrlAMMvBCNk69XpHoPVtyGz7YhGXopaeQbVTOWelZ4P
	 R7cWn2UK2otWamWi7tURPG9hm+7ogbc2UCg9Y/fjU6RE1sbWy++rS/khAwLzGvs8f1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XS7QtfyPmU1aqrOqd5PZU9rCUdo9R20KWMZ2X1QeWpQ=;
	b=uD/E+yn/9KH5MUMUHwrjW5/sUpF/XrFyjblVRSGLA5d08UvRxIshQLCSupN18z8+RyXO
	 duvNfSce41DgD3tdHtPTtqCTL1/QUQzIzbL/GKz9cmQIPRRsn5Ln8fOg+F92l4C/XiQTO
	 JsqXNfEKNX+r9ZdaZn83hSVN4FboW+1uIpcnEygskMUbSS8NAqsTBnLgM9BGN7osUoXQs
	 OjhQDiQBgLXNT30c+SXpcal6R5gBjuxLW5+x0OwrJ6jiAEdAmINgYPFTkOn7H65EJGsvM
	 U00tmijads2nNlmeVNDfc7a5+WbwVRzOe1zd+1Dp9QJozpXUPIU7GmRe81kjzaQ8nTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzKFU99O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0F606A31C;
	Wed, 18 Nov 2026 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzKFU99O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A21A1F000C5;
	Wed, 18 Nov 2026 19:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029506;
	bh=XS7QtfyPmU1aqrOqd5PZU9rCUdo9R20KWMZ2X1QeWpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzKFU99OWMzJAvVSpo4e7PdrNuMi4Etq9oBRvh03gccpHr8qWe0nTWp2Naezri6Ju
	 R6W5/v4PtBjo/IEFe0m4HA1xYO3S46ef5RY7EasAPgjL1wfMJORdRbBem/32JC5xRA
	 Kf4a0mZnXDa4XU8o/S6fFJhoB3z2ki6JTpVM6B8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0371/1756] PM: runtime: Only queue an idle check for RPM-linked suppliers
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150023.241361958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit be5755f023e7e02ec90bbd1d4ca63a0abe594733 ]

When a device RPM-suspends, it queues up an idle check for all of its
suppliers, in case that device was the last consumer, and those
suppliers are now able to suspend. Today, we do this for all suppliers,
and not only for those suppliers that are marked for use by runtime PM.
This isn't directly harmful, but it is a bit wasteful, and also may
induce unexpected suspend attempts (e.g., if a device was purposely last
touched with pm_runtime_put_noidle()).

To avoid excess idle checks, only call pm_request_idle() on linked
suppliers that opted into runtime PM.

Noticed by inspection of trace logs.

This is not expected to have a functional impact on systems that are
using device links properly, and should only be considered an
optimization.

Fixes: 5244f5e2d801 ("PM: runtime: Defer suspending suppliers")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20260901013341.1417232-1-briannorris@chromium.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index b0b72fa2a1202..4261f0b90f245 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -349,7 +349,8 @@ static void rpm_suspend_suppliers(struct device *dev)
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held())
-		pm_request_idle(link->supplier);
+		if (device_link_test(link, DL_FLAG_PM_RUNTIME))
+			pm_request_idle(link->supplier);
 
 	device_links_read_unlock(idx);
 }
-- 
2.53.0



