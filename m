Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA04356A12;
	Tue, 21 Jul 2026 19:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662366; cv=none; b=irvwcNewapzpK/P/KrZ06ucnJOWcDgeHWnybnHzKX9On/PU00FXdUNBjGnwQxZKgI2JlG7QRiMvF+zOJINPJAFA3ulk0q0wq3tTHBHZTuaTSEK+803cWJefG3IqrKzQC/+7SQaYVj3PX3Hec0p+FgRTzU2RqfRtrqYCe1nMC0a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662366; c=relaxed/simple;
	bh=MK4gfkq5lH9fJk1tBNz2q4qHOdKM4m/Yo0eBk5POKZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJsdc6m++Hk5l7Le1/pbgDD5Igo6fr+4l/QrTO6uvRUgKJ5pCSjlRsyYp2szAR3TDw0zmr9hMgZa90FZUT6eRjYGWNJNBwc1mOWYvQl0KNrqzNooz9i660GmLi+JJn2FrcUpC3G/NqtXLQzKZGUBUBU9QEJYiV9O+07VMpk8wUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYulsQ07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYulsQ07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17861F000E9;
	Tue, 21 Jul 2026 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662365;
	bh=UHKMNn8T9xfKWCmN3uDFSCH8zQa5Ezyli9PQHlTWX0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYulsQ07QX4Y1o1MDyxQBUTnKWyaKMdZ+X3Rdvaf5eAOqSHWflnYClKxJ6G4lmJqk
	 XKHFYmErwqj6kfutTZbQq6585Q/H1N4Or296RYKkMD4r6gaQdE3vrK21dtslPZzyEN
	 X31aFjMpUR91mhfut8VOY5aAZBovVmmHsmfxmh70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0373/1276] landlock: Fix unmarked concurrent access to socket family
Date: Tue, 21 Jul 2026 17:13:36 +0200
Message-ID: <20260721152454.454167512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit 0ce4243509d1580349dd0d50624036d6b097e958 ]

Socket family is read (twice) in a context where the socket is not
locked, so another thread can setsockopt(IPV6_ADDRFORM) to write it
concurrently. Add needed READ_ONCE() annotation.

Use the proper macro to access __sk_common.skc_family like everywhere
else.

Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://patch.msgid.link/20260609211511.85630-1-matthieu@buffet.re
Link: https://patch.msgid.link/20260609211511.85630-2-matthieu@buffet.re
[mic: Squash two patches, move variable to ease backport, fix comment
formatting]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/net.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index 53d479893475f8..9c9608924fbdbb 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -48,6 +48,7 @@ static int current_check_access_socket(struct socket *const sock,
 				       const int addrlen,
 				       access_mask_t access_request)
 {
+	unsigned short sock_family;
 	__be16 port;
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
 	const struct landlock_rule *rule;
@@ -70,6 +71,12 @@ static int current_check_access_socket(struct socket *const sock,
 	if (addrlen < offsetofend(typeof(*address), sa_family))
 		return -EINVAL;
 
+	/*
+	 * The socket is not locked, so sk_family can change concurrently due to
+	 * e.g. setsockopt(IPV6_ADDRFORM).
+	 */
+	sock_family = READ_ONCE(sock->sk->sk_family);
+
 	switch (address->sa_family) {
 	case AF_UNSPEC:
 		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP) {
@@ -106,7 +113,7 @@ static int current_check_access_socket(struct socket *const sock,
 			 * these checks, but it is safer to return a proper
 			 * error and test consistency thanks to kselftest.
 			 */
-			if (sock->sk->__sk_common.skc_family == AF_INET) {
+			if (sock_family == AF_INET) {
 				const struct sockaddr_in *const sockaddr =
 					(struct sockaddr_in *)address;
 
@@ -154,7 +161,7 @@ static int current_check_access_socket(struct socket *const sock,
 	 * check, but it is safer to return a proper error and test
 	 * consistency thanks to kselftest.
 	 */
-	if (address->sa_family != sock->sk->__sk_common.skc_family &&
+	if (address->sa_family != sock_family &&
 	    address->sa_family != AF_UNSPEC)
 		return -EINVAL;
 
-- 
2.53.0



