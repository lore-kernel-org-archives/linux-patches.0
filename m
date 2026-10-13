Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700D71A7264;
	Tue, 13 Oct 2026 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896037; cv=none; b=ZL+5mFTWa1n5znYwvon+zgcKIKsVbntuim/h0MxIPo7aVYSYRLcyi+g9InSdoLe9oPH3Q3jTYASlF25EfiqO1ud4ntPfkr7AIw4RBOgmrW+VF/J1kyUgKm/yd7Iru1DZbziWbxSQyhBmn+zrMeTYLK1OpR3PIppM25dJFGoA3ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896037; c=relaxed/simple;
	bh=JZ0nyJ0KMVCY/HyuqgxkLcuPMmDN6l7BFW81lHBG6U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sViP0as9lY4mtD0LUELEZClsHqN97eZh+Diw24zczyxpGkUVZIm72tHJf9nup3FCQmSiXg5P1t03kT29f1grTOSbpo35KnRrfmQHlDtnSE67Gvsy55+FbykSqoHtnZJCIBiINCPO17neJcUAKTDX1nwGnLlWucq2rKVLsD/8Ehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGU7FRsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGU7FRsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF3D1F000FF;
	Tue, 13 Oct 2026 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896036;
	bh=1Ad8/B1Hn2PS880Jlg5u4il4XPNWkYlXIE0kYjCiqcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGU7FRsumjbSeFsirn4/Rn7bKiKrkaiyVzKtaES6Q+AYkz+9ed3gIMdJN1YLlwoEZ
	 waS+ivcRknKBG3jwdepfmWKDtBg5hA6LDc0D2GX0vWzc+VqnhWp+ILl6CGRa6TVOCW
	 bi/bHJMQDSw3JQNmcNEL4+qF1028SY8HjuVvzhsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/497] devlink: fix devlink_rel reference leak when notify work is pending
Date: Tue, 13 Oct 2026 13:40:44 +0200
Message-ID: <20261013112919.200801850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit c5381ae1cd1481cc431c2bd79460472c6f1d3ce3 ]

devlink_rel_nested_in_notify_work_schedule() takes a reference on the
devlink_rel for the notify work and then queues the work, ignoring the
return value of schedule_delayed_work(). If the work is already pending,
nothing new is queued, the work runs only once and drops only one
reference, so the extra one is leaked together with the devlink_rel and
its index in devlink_rels.

This is easy to hit. devl_register() of a nested instance queues the
work, and if the instance is unregistered before the work has run,
devlink_rel_put() queues it again while it is still pending. The work
also keeps rescheduling itself for as long as the parent devlink lock
cannot be taken, which widens the window. Registering and unregistering
a nested devlink instance 100 times while holding the parent lock leaks
all 100 devlink_rel objects.

The reschedule path in devlink_rel_nested_in_notify_work() has the same
problem: if the work was queued again while it was running, the
reference it holds is never dropped.

Drop the reference in both places when the work was already pending.
The pending work holds its own reference, so this can not be the last
one.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261001042232.222987-1-yanhaishuang@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 5f62fe5d2aa88..de8c2381a2477 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -96,13 +96,19 @@ static void devlink_rel_nested_in_notify_work(struct work_struct *work)
 	return;
 
 reschedule_work:
-	schedule_delayed_work(&rel->nested_in.notify_work, 1);
+	/* The work may have been queued again meanwhile, which took its own
+	 * reference. Drop ours in that case.
+	 */
+	if (!schedule_delayed_work(&rel->nested_in.notify_work, 1))
+		__devlink_rel_put(rel);
 }
 
 static void devlink_rel_nested_in_notify_work_schedule(struct devlink_rel *rel)
 {
 	__devlink_rel_get(rel);
-	schedule_delayed_work(&rel->nested_in.notify_work, 0);
+	/* The pending work holds a reference already, drop the new one. */
+	if (!schedule_delayed_work(&rel->nested_in.notify_work, 0))
+		__devlink_rel_put(rel);
 }
 
 static struct devlink_rel *devlink_rel_alloc(void)
-- 
2.53.0



