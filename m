Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB0E472762;
	Tue, 16 Jun 2026 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626744; cv=none; b=NY155lpiGQQFUHJMHS0ATXd3dIVpKy4zQPdLqa58zUYiMqC5WyoSeoJo8Xs1L1iDgXDuxT9m2hnuCyMBwkxXYq/Ll8OSjLyGXC3m81MvNvfCQHbpuz9+UFAzRwh6qI8rH/k0ENgEFVTr4AVZW9H69AvTdZpJUTYKVxPDuPXWci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626744; c=relaxed/simple;
	bh=LftoIHJu1UEusYj2qcEZskCON4pbtH3tsr5aCtNwbZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgO2ZJQOppm8GKq1KpJiqgHCZmuFMMmV8fE8Zv9SDwD87zDjEB5Xshvb2XzH4YMD3p/DNsN+KVj/l5eQUSad4UyTB3vE/oyqh7ZHy4FQnv8M5kywR2D7cZZa35RrjJfHI9C4lzTQGeeDyvR0gHcxo3/riKeAdOCZDVEZ+eox1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JM/xztd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JM/xztd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB61F000E9;
	Tue, 16 Jun 2026 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626743;
	bh=cP1M17NZxeLKaIaKkYd/wmoNLQ4+R31eSu2ml+WY7x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JM/xztdLHbtdHLMgjwbw31c7W2Z+uzRD5NmB/f0Pl/OLHIy7NfnQqZ+uLJ4IHhgQ
	 GjxVXY8U0IgFsJlxfuyP9h/LiuDejCnemxHx9MzEiMDJYb8IpPxg7ndd2zjV1a9JHx
	 Pe0724JaK47RbJ3Mxmy6iJQURKW5/yabvlQd7qJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/261] devlink: Release nested relation on devlink free
Date: Tue, 16 Jun 2026 20:27:46 +0530
Message-ID: <20260616145046.363335203@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3522b21fd7e1863d0734537737bd59f1b90d0190 ]

devlink relation state is normally released from devl_unregister(), which
calls devlink_rel_put(). This misses devlink instances that get a nested
relation before registration and then fail probe before devl_register() is
reached.

That flow can happen for SFs. The child devlink gets linked to its
parent before registration, then a later probe error calls devlink_free()
directly. Since the instance was never registered, devl_unregister() is not
called and devlink->rel is leaked.

Release any pending relation from devlink_free() as well. The registered
path is unchanged because devl_unregister() already clears devlink->rel
before devlink_free() runs.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260528191411.3270532-1-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 7203c39532fcc3..5f62fe5d2aa883 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -469,6 +469,8 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
+	devlink_rel_put(devlink);
+
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
-- 
2.53.0



