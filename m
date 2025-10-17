Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4AC337110;
	Fri, 17 Oct 2025 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715130; cv=none; b=P8sHyUASSXnwVnUQ9BePXYSMOsSzGWQQh0DP2iHY/sknzWOnmxW3yQNloYA+ttAUoSoO2Ux+9vL2IEYZyQmysbtKWhKLQnJ0k3bUi141LVhD3UFngOtvrq6wCP9bMlV6Fw0esu3zjPujKAeZ36vV0hnrHCHQGrS/dEJ+2CMlGsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715130; c=relaxed/simple;
	bh=I6UdUe3hAhWw+v5Z40zd7X3tRWAuz49JUc+tIxr6nB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGKpniNzG7FuO+BWNAt7rSp6ZvXO/udWkD7I5SIAIHAk7xiIM1hENJ6kU21Qgamf8g/ilhLBkGk71EaWcw2usenR+kC9Zg4LKA1PJhtoVB5RUYEwM1o/qXXtakvAa96DWb+/SA6r0Ewmaw1hD0laXQKjO5r1sZSpZftOcmKJ2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDz7N9uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDz7N9uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2DBC4CEE7;
	Fri, 17 Oct 2025 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715130;
	bh=I6UdUe3hAhWw+v5Z40zd7X3tRWAuz49JUc+tIxr6nB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDz7N9uyMR+/zlCDcTU5em9qwKljGRmcKwxbbtBvDVKngFtHhDqA/B5uIjXj33mMs
	 IqcheiUbpYV4TSsfxZ2Lptc21kEzFu301cC6+2hsefdDYTii8OYJHP10D7WTpYCK7I
	 /ry9b05LaYkVupyhMqacaOvUj9ce1GcC8vFW1d5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidharth Seela <sidharthseela@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/371] selftest: net: ovpn: Fix uninit return values
Date: Fri, 17 Oct 2025 16:51:06 +0200
Message-ID: <20251017145205.231379238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 7fc25c5a5ae6230d14b4c088fc94dbd58b2a9f3a ]

Fix functions that return undefined values. These issues were caught by
running clang using LLVM=1 option.

Clang warnings are as follows:
ovpn-cli.c:1587:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
 1587 |         if (!sock) {
      |             ^~~~~
ovpn-cli.c:1635:9: note: uninitialized use occurs here
 1635 |         return ret;
      |                ^~~
ovpn-cli.c:1587:2: note: remove the 'if' if its condition is always false
 1587 |         if (!sock) {
      |         ^~~~~~~~~~~~
 1588 |                 fprintf(stderr, "cannot allocate netlink socket\n");
      |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 1589 |                 goto err_free;
      |                 ~~~~~~~~~~~~~~
 1590 |         }
      |         ~
ovpn-cli.c:1584:15: note: initialize the variable 'ret' to silence this warning
 1584 |         int mcid, ret;
      |                      ^
      |                       = 0
ovpn-cli.c:2107:7: warning: variable 'ret' is used uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
 2107 |         case CMD_INVALID:
      |              ^~~~~~~~~~~
ovpn-cli.c:2111:9: note: uninitialized use occurs here
 2111 |         return ret;
      |                ^~~
ovpn-cli.c:1939:12: note: initialize the variable 'ret' to silence this warning
 1939 |         int n, ret;
      |                   ^
      |

Fixes: 959bc330a439 ("testing/selftests: add test tool and scripts for ovpn module")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Link: https://patch.msgid.link/20251001123107.96244-2-sidharthseela@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ovpn/ovpn-cli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/ovpn/ovpn-cli.c b/tools/testing/selftests/net/ovpn/ovpn-cli.c
index 9201f2905f2ce..8d0f2f61923c9 100644
--- a/tools/testing/selftests/net/ovpn/ovpn-cli.c
+++ b/tools/testing/selftests/net/ovpn/ovpn-cli.c
@@ -1586,6 +1586,7 @@ static int ovpn_listen_mcast(void)
 	sock = nl_socket_alloc();
 	if (!sock) {
 		fprintf(stderr, "cannot allocate netlink socket\n");
+		ret = -ENOMEM;
 		goto err_free;
 	}
 
@@ -2105,6 +2106,7 @@ static int ovpn_run_cmd(struct ovpn_ctx *ovpn)
 		ret = ovpn_listen_mcast();
 		break;
 	case CMD_INVALID:
+		ret = -EINVAL;
 		break;
 	}
 
-- 
2.51.0



