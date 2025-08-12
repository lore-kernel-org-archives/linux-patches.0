Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC93C2F5E;
	Tue, 12 Aug 2025 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022373; cv=none; b=R5md+nDj8Iv+BjVKvUJlYF+fbSG0a7cH036lI2uuAhpGKGGn67cQ25Gc/ppokPM8bwGHYO6x1pEvNOniBkFspuOo8jVIqcygp3bCtgheb4Fb5KB0hLKInMubZ48hoxbIo7/EM0/4WGB0I3TaLV6qHWvQhwWjob2jYB90u2zZwW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022373; c=relaxed/simple;
	bh=2sYpUym9xdXu5yr4NAZeaU1Db7Rn+d5ecZOP7ivHzUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+UMQb4AFOEhBeX/QiS4jKYAf997YcCdFE/cYvX6CtkT9Cgyt6cxTGTJ9oVGNCRy9Fr1l7WPh20lqYlj/jATdsOHx6/gnwn0ECOqpXhA5PIL57ib53raVJwPNgoosxGgQmyDHGm7pNo6MJSI0sC2V1/MvuQ7dRi8ydfUUBACb00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4933rIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4933rIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393A6C4CEF0;
	Tue, 12 Aug 2025 18:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022373;
	bh=2sYpUym9xdXu5yr4NAZeaU1Db7Rn+d5ecZOP7ivHzUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4933rIFnDDDwOc/8c5Ic0XP5/JufdMQo9Um2LWSc8yjr1iFj0yGGUP88i/qNnUbs
	 vPS1Y4BaDCQ93Cj22ybd5eV8jmA1SZZK9Jy4HisGQqZJaeC26mQHQQGp1I9Nk65hhS
	 wQdZ35Bm5lXij20liwxGSYEn9aHb3wuAjnwMT/CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/369] selftests: drv-net: Fix remote command checking in require_cmd()
Date: Tue, 12 Aug 2025 19:27:12 +0200
Message-ID: <20250812173019.846463227@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit b4d52c698210ae1a3ceb487b189701bc70551a48 ]

The require_cmd() method was checking for command availability locally
even when remote=True was specified, due to a missing host parameter.

Fix by passing host=self.remote when checking remote command
availability, ensuring commands are verified on the correct host.

Fixes: f1e68a1a4a40 ("selftests: drv-net: add require_XYZ() helpers for validating env")
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20250723135454.649342-2-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/lib/py/env.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/lib/py/env.py b/tools/testing/selftests/drivers/net/lib/py/env.py
index 1ea9bb695e94..3f35faca6559 100644
--- a/tools/testing/selftests/drivers/net/lib/py/env.py
+++ b/tools/testing/selftests/drivers/net/lib/py/env.py
@@ -224,7 +224,7 @@ class NetDrvEpEnv:
             if not self._require_cmd(comm, "local"):
                 raise KsftSkipEx("Test requires command: " + comm)
         if remote:
-            if not self._require_cmd(comm, "remote"):
+            if not self._require_cmd(comm, "remote", host=self.remote):
                 raise KsftSkipEx("Test requires (remote) command: " + comm)
 
     def wait_hw_stats_settle(self):
-- 
2.39.5



