Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09271C6FF6;
	Wed,  5 Mar 2025 18:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198044; cv=none; b=S4vc4Uab8M76muXvBZsR/C8D2xzFD2kmmzVr5qAziIjMndmPfgHmKXTF0zrBAE51MHrpT9SVtb6GOF+9E3GDVFabgKs9HxJ+iaMtpKibgWhRUzkZj+lKHYApcaV/KL83BhIizw2P8xhld3r+qaBoDwDK6Axxf+MwePv63fdODSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198044; c=relaxed/simple;
	bh=lh8mVYMUKs03vJP0OeBQcJEPNhzh1cqbJMEMc8oje7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haDUCpaxkxFyTKy406rNXAA2/8ZtWPaxAyf6mkWh3tsvSinGqlHbw2TYEZVW1rXZqUDpXMalq1sshciFjoZVIJLv6ZG1k+5kQDnb42Zc1vHsd5JhEvwcwGBFZG75ecwOdTrBqYJCd5b9NyP8mzewUa6g3Or0OWttkKi7bYcNA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVqf7v49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVqf7v49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40923C4CED1;
	Wed,  5 Mar 2025 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198044;
	bh=lh8mVYMUKs03vJP0OeBQcJEPNhzh1cqbJMEMc8oje7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVqf7v49e5bNXOuMafIYajTE05e1HXG3q8DGn2Q48Q//uksBwq4IfFHJcBvmxgEor
	 ndjSO/syLDRWrsPUevxt8kCscmXTdJJYbDi4E4OnxH1VnVCycT7JT1Bd87FIBizyUy
	 1HEzZwp3vkyt18YLYfP9GUatu7iR0lHZv60xx8Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/150] landlock: Fix non-TCP sockets restriction
Date: Wed,  5 Mar 2025 18:47:22 +0100
Message-ID: <20250305174504.340334667@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>

[ Upstream commit 854277e2cc8c75dc3c216c82e72523258fcf65b9 ]

Use sk_is_tcp() to check if socket is TCP in bind(2) and connect(2)
hooks.

SMC, MPTCP, SCTP protocols are currently restricted by TCP access
rights.  The purpose of TCP access rights is to provide control over
ports that can be used by userland to establish a TCP connection.
Therefore, it is incorrect to deny bind(2) and connect(2) requests for a
socket of another protocol.

However, SMC, MPTCP and RDS implementations use TCP internal sockets to
establish communication or even to exchange packets over a TCP
connection [1]. Landlock rules that configure bind(2) and connect(2)
usage for TCP sockets should not cover requests for sockets of such
protocols. These protocols have different set of security issues and
security properties, therefore, it is necessary to provide the userland
with the ability to distinguish between them (eg. [2]).

Control over TCP connection used by other protocols can be achieved with
upcoming support of socket creation control [3].

[1] https://lore.kernel.org/all/62336067-18c2-3493-d0ec-6dd6a6d3a1b5@huawei-partners.com/
[2] https://lore.kernel.org/all/20241204.fahVio7eicim@digikod.net/
[3] https://lore.kernel.org/all/20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com/

Closes: https://github.com/landlock-lsm/linux/issues/40
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Link: https://lore.kernel.org/r/20250205093651.1424339-2-ivanov.mikhail1@huawei-partners.com
[mic: Format commit message to 72 columns]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index d5dcc4407a197..104b6c01fe503 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -63,8 +63,7 @@ static int current_check_access_socket(struct socket *const sock,
 	if (WARN_ON_ONCE(dom->num_layers < 1))
 		return -EACCES;
 
-	/* Checks if it's a (potential) TCP socket. */
-	if (sock->type != SOCK_STREAM)
+	if (!sk_is_tcp(sock->sk))
 		return 0;
 
 	/* Checks for minimal header length to safely read sa_family. */
-- 
2.39.5



