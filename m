Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7D615FCF0;
	Mon, 27 May 2024 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838641; cv=none; b=XoRXQ1ojCJDwxp+sLfZ7x+8ETuY6gw3LWTPc9053Ka3ESrm0D756mooOsVG7RbGstP0AC/sCeeJ08TEMnAX4DBACQjcJ5bDiP9pmJk/sK9X5Sl4svEMUjPhXGmDF9mReuqo24rX76wZapbBhSew1Kl63zzXMRcpAllgH4tXTdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838641; c=relaxed/simple;
	bh=naJ7JPCwL5yRPVojOzk5/Ep4zve9tSj6GQoajNwd7Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgRj5wUHthP/X4029XY31M9/tFDnGmPz2VaXR+H8/MMEJQdkQFdCaUQbtvUufUhet+Xnve3L7UTGbYp6eNLzjQy8nwGZdrgicbTtDl6wQWEsBMzcy9VFnzlzajR/J5gsfNo4jnwAq/c/cPhiy1KICKqD1IftbV8r1BJ6S8Nyy5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLIgKNzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLIgKNzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC167C2BBFC;
	Mon, 27 May 2024 19:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838641;
	bh=naJ7JPCwL5yRPVojOzk5/Ep4zve9tSj6GQoajNwd7Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLIgKNzM2yFOfIoxPchKEdanVAb98R8xmj1AebxRs6LIxEcOrBc53jAT4FbMAuYZ5
	 3MwB5Ana1+OvoVdZ1DQqXzWnnPK/8UhJslD93Zd7E6DY1dwgD6oIuuDRHKEXKiGPou
	 Kuvwp2hBY9LSzvAwoQPI8Di0V5IPiQu+3Qx+ZaCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 470/493] samples/landlock: Fix incorrect free in populate_ruleset_net
Date: Mon, 27 May 2024 20:57:52 +0200
Message-ID: <20240527185645.542082699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>

[ Upstream commit 42212936d9d811c7cf6efc4804747a6c417aafd4 ]

Pointer env_port_name changes after strsep(). Memory allocated via
strdup() will not be freed if landlock_add_rule() returns non-zero value.

Fixes: 5e990dcef12e ("samples/landlock: Support TCP restrictions")
Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Link: https://lore.kernel.org/r/20240326095625.3576164-1-ivanov.mikhail1@huawei-partners.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/landlock/sandboxer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 08596c0ef0707..e6c59f688573a 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -151,7 +151,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 				const __u64 allowed_access)
 {
 	int ret = 1;
-	char *env_port_name, *strport;
+	char *env_port_name, *env_port_name_next, *strport;
 	struct landlock_net_port_attr net_port = {
 		.allowed_access = allowed_access,
 		.port = 0,
@@ -163,7 +163,8 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 	env_port_name = strdup(env_port_name);
 	unsetenv(env_var);
 
-	while ((strport = strsep(&env_port_name, ENV_DELIMITER))) {
+	env_port_name_next = env_port_name;
+	while ((strport = strsep(&env_port_name_next, ENV_DELIMITER))) {
 		net_port.port = atoi(strport);
 		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
 				      &net_port, 0)) {
-- 
2.43.0



