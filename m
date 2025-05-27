Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD9B185E7F;
	Tue, 27 May 2025 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366596; cv=none; b=qENuQI0hRMiXV4VlJdIYda94yTbUqHfpim1FJrUm7Sml7h34SIK87sPL+R0u15rhFR8BiKx/FmC0nubboqXHoUPh5C8qEuMPe292FvR+k/45RaFyhx0H0FoaO7HqN+y/z61KcLUi2/ALmX/h4LSStdh2jp59jTuQ0meDXGF9Www=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366596; c=relaxed/simple;
	bh=oWxsBJUkocnx13CozOlZMKFrTvDHJUMI3hDlmTGtM5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rowpUVXCu/lOaYSTnMUaWasRkL5oG5YgFvkNM3gQKVnf5WTIAupO7CcMpnjQZ4qjZtq0oMt1YqNu42w7UUKofzouPc6VIyqhV+Gc1XEJtZXZ7/z4NC8LaguUP5IIyDhIqVksPWNaZ8w0zfVzRz1YxLXJCeBjsxDgo4ArmXCn4m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyHFA9ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyHFA9ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26E4C4CEE9;
	Tue, 27 May 2025 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366596;
	bh=oWxsBJUkocnx13CozOlZMKFrTvDHJUMI3hDlmTGtM5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyHFA9nsmL6KBFqFKEa7HKGw78D+azu1lPrfpgohmgOXbQVPftg5X7om7mZKf009P
	 MjGx/blIpfJon7CTkJtIadXdgFMuGouhjHC5LiPw0rhfP9gq3jwBbRS9y4SCoElgSN
	 QduXKeD4o3OlGG69Iv9MPKRXaZH3kjRSvRlH3ZfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Su <jingsusu@didiglobal.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 089/783] dql: Fix dql->limit value when reset.
Date: Tue, 27 May 2025 18:18:06 +0200
Message-ID: <20250527162516.762924493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Su <jingsusu@didiglobal.com>

[ Upstream commit 3a17f23f7c36bac3a3584aaf97d3e3e0b2790396 ]

Executing dql_reset after setting a non-zero value for limit_min can
lead to an unreasonable situation where dql->limit is less than
dql->limit_min.

For instance, after setting
/sys/class/net/eth*/queues/tx-0/byte_queue_limits/limit_min,
an ifconfig down/up operation might cause the ethernet driver to call
netdev_tx_reset_queue, which in turn invokes dql_reset.

In this case, dql->limit is reset to 0 while dql->limit_min remains
non-zero value, which is unexpected. The limit should always be
greater than or equal to limit_min.

Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Link: https://patch.msgid.link/Z9qHD1s/NEuQBdgH@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_queue_limits.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index c1b7638a594ac..f97a752e900a0 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -190,7 +190,7 @@ EXPORT_SYMBOL(dql_completed);
 void dql_reset(struct dql *dql)
 {
 	/* Reset all dynamic values */
-	dql->limit = 0;
+	dql->limit = dql->min_limit;
 	dql->num_queued = 0;
 	dql->num_completed = 0;
 	dql->last_obj_cnt = 0;
-- 
2.39.5



