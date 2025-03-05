Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4111946C3;
	Wed,  5 Mar 2025 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198384; cv=none; b=CL5ppLQyNMGsU6VCAD0mpUN6EXG0JmAyWcHi91TmB/YO2J7d7bPWdB4IdcRTDU1YN/bNi+9gWYcf/AtCmHUvX72djmFdqEdgjZC01QYTkx9gxKQWiVED1O0A8z/qbNIWLMfk9QOK+0Hi8wMGSo8deHA20XwYoununexCK2eFJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198384; c=relaxed/simple;
	bh=SEQBmrVol4mjfuNIURg8R3kahcMK00UUm8ClHem+lW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2YQPCgReFzrPSPeoNrl6huotXgqac7sBrN9AYEn5+xoX6YSISbHGDRwwqYCiind+zc8V2a1xCvVWKdG8hbm1W9SnfqMtP2IPkDzr03h7ULioBAZjDyh0Egm9cNFQloPCqPIIdZCUdPO5HS041LXNn2lSi4mnkpbs5LgwCdG58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaLUbnnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaLUbnnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68D5C4CED1;
	Wed,  5 Mar 2025 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198384;
	bh=SEQBmrVol4mjfuNIURg8R3kahcMK00UUm8ClHem+lW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaLUbnnp4mpkVlqjRZ4YQbrvyh/42AGDbMCCbliTmvMDfAs7rJRm5eIptZsfWeByK
	 iJo+tWvyvmoFbWstmqIwPb4P6RnrepKx7jl7jDp0seFM1vovG0BK0zs/WJDAOuaQqr
	 NFY7Ui6b5ujacC4EmNnMKfHHp50ZCjOt7Eyw90/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 010/157] landlock: Fix non-TCP sockets restriction
Date: Wed,  5 Mar 2025 18:47:26 +0100
Message-ID: <20250305174505.692333961@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



