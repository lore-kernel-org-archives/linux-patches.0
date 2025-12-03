Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F82F0699;
	Wed,  3 Dec 2025 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778023; cv=none; b=kQqlPyLc7EuMm1LGvtRgCEqnlS5CoH7D87hti+Y7GBVO2uQ5e24ZG7S5cf4qukPxl13nWVcCXzAhYEAoNWE1uuCWP5313SsFYe3F44ovNkj7PTUXSv4rDBMmOIxRHbx+puG/7JKNmfPpS3qQteaDLZKdMeV+Z8pMnACXkP3lneU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778023; c=relaxed/simple;
	bh=oTMljmk8E7C6yjGk+Glq6su4wktt/zHVPVZiR1SC1IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0XPxDjpVmjvPpwq/IJVp0Yrhvmdp4E/AMbZoEEXHxQRJBxNNqhsjzjA3UUu7yK97Xjhiq1rT8s6V0nPy1G2IxzJL2yBlpBpiZs1sHO1eWqt28wGOtI+NDMiYlT6stB+oM2vnVbIl6dT455Ar7fIlkQYlqn/GRrPWBGqaEUz07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhzORMS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhzORMS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6304C4CEF5;
	Wed,  3 Dec 2025 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778023;
	bh=oTMljmk8E7C6yjGk+Glq6su4wktt/zHVPVZiR1SC1IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhzORMS8hCTCVve24sH61bGXDaNMudtxRrYbw/QY5Rtka6cvJRIoGyzIKIiTcAwJN
	 N5TqvXI0KzlFDaRmk8+dPOQ8+APqC3uQ7I+OE66BS7e+lmZZR0LhpggI9rlOk7i1Q0
	 ETAjNIcryRqWkEnYcjzj6JPbGpoBA6oz8yIOALuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/392] sctp: Prevent TOCTOU out-of-bounds write
Date: Wed,  3 Dec 2025 16:26:10 +0100
Message-ID: <20251203152422.280760280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 95aef86ab231f047bb8085c70666059b58f53c09 ]

For the following path not holding the sock lock,

  sctp_diag_dump() -> sctp_for_each_endpoint() -> sctp_ep_dump()

make sure not to exceed bounds in case the address list has grown
between buffer allocation (time-of-check) and write (time-of-use).

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-3-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 31cf52026202b..3631a32d96b07 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -88,6 +88,9 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 		memcpy(info, &laddr->a, sizeof(laddr->a));
 		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
 		info += addrlen;
+
+		if (!--addrcnt)
+			break;
 	}
 	rcu_read_unlock();
 
-- 
2.51.0



