Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD6D155C81;
	Mon, 27 May 2024 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837413; cv=none; b=d/J8W9IlHCWU2gwGLZvquQH0lkFLW8QBXWD761nHfD94jIy5spXPiBg8jUvvzhXQA0u7CzQKO+NAORP0exJdkyWiseOmdOcOJP5cS8kjBn6GMHdVRMPAGNLd0xQ1L2+dnQ8dSnhz98/jfrUREpXFXKJ0Lcu84CQuyRH7rlTv2bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837413; c=relaxed/simple;
	bh=8FnljlWA5GfmnGpV0Ap0dLAOfdoxlGja5Q8FFxEBZfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmglWfVacPVWRj7gKWHVJ0eUTcnuB4KMzxGuQNyvD4tV2I6KJqUY+QNtph9Yah5Pm04y87NQUDH45yoRX7Ry8/piiquQTcESqqKWxhaB0x92yNwRiYzorpkXVXp/PkaBZH1ArmnVbt9oi4C70W/OjYJLb4Zb31JYdNS+yT5TAiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpMQBFCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpMQBFCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83D9C2BBFC;
	Mon, 27 May 2024 19:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837413;
	bh=8FnljlWA5GfmnGpV0Ap0dLAOfdoxlGja5Q8FFxEBZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpMQBFCaZgPc1lexl17XQL+Pw7f4iKBsamyXJoe386iQdcDwy0Ejoj4Hes/OrsQlA
	 c0s/6L/8wHWFdcfp8mP+MuGWUnUB9qB0WnszyHqINw0GY2bl2PWA0NF+i4AU4vNCDA
	 oUgHfSd1Ko3te4/O/EGd6jG2orFE9PrzdaVfzSUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 408/427] samples/landlock: Fix incorrect free in populate_ruleset_net
Date: Mon, 27 May 2024 20:57:35 +0200
Message-ID: <20240527185635.339012240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 32e930c853bba..8b8ecd65c28c4 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -153,7 +153,7 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
 				const __u64 allowed_access)
 {
 	int ret = 1;
-	char *env_port_name, *strport;
+	char *env_port_name, *env_port_name_next, *strport;
 	struct landlock_net_port_attr net_port = {
 		.allowed_access = allowed_access,
 		.port = 0,
@@ -165,7 +165,8 @@ static int populate_ruleset_net(const char *const env_var, const int ruleset_fd,
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



