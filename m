Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB30B21C187;
	Tue, 12 Aug 2025 19:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025962; cv=none; b=XOXp2pW8Vkcdt2ZelJTs4YiBrjaZAi260ZxNr8q5vEh0maEkvXkl133ea2xxi0OcKmpHqYy0IJ7E/DSab8Vq+7dnAqYrqDetS6zkLwUeVTQ2iy6b+xjziekiGbvDC6Gd0ZpRiKf8Ln0MgfLGNyN9Ku8/B+ZFHGkplaohTVqtQ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025962; c=relaxed/simple;
	bh=2wwZ3bARQ6fkzFb6CuPq1kgf+W3Djc+wg/usKIkrH8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0MERN5U0e2KiWX/hBRsPf2Gt/s5J88DgMYWoqovrYfbE4yUAhp6PbVXOLVjvJsMPsdLCGMHXnSZHY7V0ZY1hwp15O0w2HZSI4Mmel9wxxt6jQ81fPawri/ha4/9Ml5PSXlBhZqhrW0uPSouQh5mA9+DIjMYkOp+dFalR9Izbeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6FhZtsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6FhZtsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C0CC4CEF0;
	Tue, 12 Aug 2025 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025962;
	bh=2wwZ3bARQ6fkzFb6CuPq1kgf+W3Djc+wg/usKIkrH8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6FhZtsCrK7QVA8MexcctxVU7BGpv9FBZxXSDgz4B/mGT+3UFNdHCQiBBesa1tR0f
	 Vgte0h19b4nLLFUDHZQUDMzJrMJIirshbsKTg44ktn7smo9iXO2yY66UgoUzHSGdNN
	 fUlgSfwxonArnxUH/108wooQbQHGwL/6LuKEX1jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 197/480] selftests: drv-net: Fix remote command checking in require_cmd()
Date: Tue, 12 Aug 2025 19:46:45 +0200
Message-ID: <20250812174405.614011406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad5ff645183a..98bfc1e9e9ca 100644
--- a/tools/testing/selftests/drivers/net/lib/py/env.py
+++ b/tools/testing/selftests/drivers/net/lib/py/env.py
@@ -259,7 +259,7 @@ class NetDrvEpEnv(NetDrvEnvBase):
             if not self._require_cmd(comm, "local"):
                 raise KsftSkipEx("Test requires command: " + comm)
         if remote:
-            if not self._require_cmd(comm, "remote"):
+            if not self._require_cmd(comm, "remote", host=self.remote):
                 raise KsftSkipEx("Test requires (remote) command: " + comm)
 
     def wait_hw_stats_settle(self):
-- 
2.39.5



