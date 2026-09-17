Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B55C3E9F9E;
	Thu, 17 Sep 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667941; cv=none; b=PDrGhNEm1ArgVGaThPH2XAU3L8pBtXyv+wBzbAAdSDKEuE5h0SH0Ves6ldn8b8tHGw5/F6pA+O+EOQkM5L4twNucUKeVMAB8zM5dZp7tkK7jcDntAE4SnnwajA5wyVSlzBLm6OBBTwLPkpct5WPGGuDelfiJieN0oStmY4kMsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667941; c=relaxed/simple;
	bh=3tJxYkeOIg8aAkCa13GzSr3iLGi3xQqR4WWpAGKu7LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQWC465VLkeMAn4DD/eGQm2ClPQvs3AYBfvpTf+yFZEkoEbq87DPPt4TGRj+CRvt+1/XAzs4ruqNqSPRYmUMESnkQkhej0WbkMeqptZ5XhZinjOli7MTrApyKs4zUtwZ22xM/PoRZRgQjIz+QXzkoxI47TVenTccLlcDGqeWUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPSmni+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPSmni+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E791F000FF;
	Thu, 17 Sep 2026 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667940;
	bh=0nQOs0quxnbcnWm3bmZHyDB2bi6w4GdiV1wuzUgHjRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPSmni+DJZgK74ZkEDdYy9DHshZBYdp5OeBsvYyKx+t8zl3ACsMXRQAJsJOeK2DBY
	 Xo8YzMF7kqV5VqvxP8UtRvFFVWERkePr5RVvjOfBvBxzBod7jFHDwABXYvcKEylQ9x
	 0JB2oDNwSKhoaTRVHdYnO8LAo8cejiQsLMd6xYCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0261/1102] netconsole: take target_cleanup_list_lock in drop_netconsole_target()
Date: Thu, 17 Sep 2026 16:03:24 +0100
Message-ID: <20260917151546.151363795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 91aeb87f052367a5a2743cc93777dfb4386f2f14 ]

drop_netconsole_target() unlinks the target while only holding
target_list_lock. However, when the underlying interface has been
unregistered, netconsole_netdev_event() moves the target from
target_list to target_cleanup_list, and netconsole_process_cleanups_core()
walks that list under target_cleanup_list_lock only.

If a user removes the configfs target at the same time the cleanup
worker is iterating target_cleanup_list, list_del() can corrupt the list
because the two paths take disjoint locks while operating on the same
list node.

Acquire target_cleanup_list_lock around the list_del() so the unlink is
serialised against netconsole_process_cleanups_core() regardless of
which list the target currently belongs to. The state transition that
downgrades STATE_DEACTIVATED to STATE_DISABLED is left intact and is
performed under the same combined locking, preserving the existing
ordering with resume_target().

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260604-netcons_fix_before_move-v3-3-ab055b3a6aa5@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 3b76ec3cd49b8..0c47713b6adbc 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -955,9 +955,11 @@ static void drop_netconsole_target(struct config_group *group,
 	unsigned long flags;
 	struct netconsole_target *nt = to_target(item);
 
+	mutex_lock(&target_cleanup_list_lock);
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_del(&nt->list);
 	spin_unlock_irqrestore(&target_list_lock, flags);
+	mutex_unlock(&target_cleanup_list_lock);
 
 	/*
 	 * The target may have never been enabled, or was manually disabled
-- 
2.53.0



