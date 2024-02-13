Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C037A93C;
	Tue, 13 Feb 2024 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845885; cv=none; b=dO0tvksYt2tqjFZN5HES9ovpSBQyhHgXWPHvnSwf7ip80yCpyliRJAQPYRvqsOHvK8lGQyiq2Am6edU+ML4wB8nsfczBsIBlYdzXGIAwgFFCgZqM8SVyVT640t0elVQxvGPqUoNTUYzmXEBLjrpnhertnqCbgfjet1l4v/uXteU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845885; c=relaxed/simple;
	bh=VQInYca/90D1tz1h8NDOEf7JG09O3ZAQzXy/LWAIsA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcF8JiK2sLdUNyRd5Xip9qT0+Ex2qfN6W9KuBkBNpib2aZXCIoCPLi+ct8NueAqKqURzPJecu+t6SLGmWtt7cU9Luaa+qTMoCzC15WISTr5Msuu06ETN4gPFqlA2353quC2L1ae4bZ+hCihiafVwEquVJClW4yuZW677jx6Jc6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdH7F6sC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdH7F6sC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A270C433F1;
	Tue, 13 Feb 2024 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845885;
	bh=VQInYca/90D1tz1h8NDOEf7JG09O3ZAQzXy/LWAIsA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdH7F6sCZq7N9VWgbFgg0852emaqqlIeM2QROu8gpZGZfgMUMRu+COTxEsq4f6NjN
	 tOn1cEOh9a3/LeHoyjo4pD2TRprNGbBcpVhRfjvbEZ9ucAa2SmKcmCEez/ppHXS7gX
	 6AzylsaxOwG/MRCvzrlt9hIQX3TQYvuc6eW4HiVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 056/124] devlink: avoid potential loop in devlink_rel_nested_in_notify_work()
Date: Tue, 13 Feb 2024 18:21:18 +0100
Message-ID: <20240213171855.376184376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 58086721b7781c3e35b19c9b78c8f5a791070ba3 ]

In case devlink_rel_nested_in_notify_work() can not take the devlink
lock mutex. Convert the work to delayed work and in case of reschedule
do it jiffie later and avoid potential looping.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240205171114.338679-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 6984877e9f10..cbf8560c9375 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -46,7 +46,7 @@ struct devlink_rel {
 		u32 obj_index;
 		devlink_rel_notify_cb_t *notify_cb;
 		devlink_rel_cleanup_cb_t *cleanup_cb;
-		struct work_struct notify_work;
+		struct delayed_work notify_work;
 	} nested_in;
 };
 
@@ -70,7 +70,7 @@ static void __devlink_rel_put(struct devlink_rel *rel)
 static void devlink_rel_nested_in_notify_work(struct work_struct *work)
 {
 	struct devlink_rel *rel = container_of(work, struct devlink_rel,
-					       nested_in.notify_work);
+					       nested_in.notify_work.work);
 	struct devlink *devlink;
 
 	devlink = devlinks_xa_get(rel->nested_in.devlink_index);
@@ -96,13 +96,13 @@ static void devlink_rel_nested_in_notify_work(struct work_struct *work)
 	return;
 
 reschedule_work:
-	schedule_work(&rel->nested_in.notify_work);
+	schedule_delayed_work(&rel->nested_in.notify_work, 1);
 }
 
 static void devlink_rel_nested_in_notify_work_schedule(struct devlink_rel *rel)
 {
 	__devlink_rel_get(rel);
-	schedule_work(&rel->nested_in.notify_work);
+	schedule_delayed_work(&rel->nested_in.notify_work, 0);
 }
 
 static struct devlink_rel *devlink_rel_alloc(void)
@@ -123,8 +123,8 @@ static struct devlink_rel *devlink_rel_alloc(void)
 	}
 
 	refcount_set(&rel->refcount, 1);
-	INIT_WORK(&rel->nested_in.notify_work,
-		  &devlink_rel_nested_in_notify_work);
+	INIT_DELAYED_WORK(&rel->nested_in.notify_work,
+			  &devlink_rel_nested_in_notify_work);
 	return rel;
 }
 
-- 
2.43.0



