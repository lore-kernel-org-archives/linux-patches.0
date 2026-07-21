Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1037D3E9C26;
	Tue, 21 Jul 2026 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656805; cv=none; b=SbAGa/CUHtKJ0gpb2ncj1OgscW7wpWJXIhGqhOmFEJEOvqPhImInT9N9Ki9+uDDgj9uT3QRpHxcQb4kyAMtfkTUr952GzYZjkOISlYFZu3of0LnFDpBFEsMAVM3ZhQojINimtZhSP3DZAoN5HkM7c0hB7e6Bq3d5DA5FrywXpU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656805; c=relaxed/simple;
	bh=Jrx5AThhtRZdKd7X+DN58RlDbqDqUQLoNhLI6mbMZUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hJx7tOmgkdMiafv90Ou4Dzvt3iG/tEsHTy2nUcSaJyBQtn5CyPxroY0fgu9aZbbHAbYHokjU+4qffxug0fU9V1JBCaQMO2HlYIM5PaLabLx1wDY2sLkWvVCaGPb/EjrXQgsGs4kf6Cbwwuyn+K1LNPcyzlNAUIupHooFPpExz3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mybopxDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mybopxDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765391F000E9;
	Tue, 21 Jul 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656804;
	bh=+HVYo0MHqoIm3hsWN8Zq6rK/SqWcoe/NBft4A+GPiGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mybopxDOxzvdETRg9dTdoaUVNujL9ZhoTk7T7TQAh5p+f/QUcabuvjAUxsBTJEc7H
	 CBbWv4BmqJUACZmNKl1Ecz8b2+kSl7eMdwLVQAQKk5VQbnO4jailUsOIgxb/FMnZI4
	 qkwlp9/gpv9CFhCaC2r7yrYoVHD5zPKMOJWREYPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0526/1611] landlock: Fix unmarked concurrent access to socket family
Date: Tue, 21 Jul 2026 17:10:42 +0200
Message-ID: <20260721152527.181063912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f309ee2def32af..8bce78cf3d6d04 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -46,6 +46,7 @@ static int current_check_access_socket(struct socket *const sock,
 				       const int addrlen,
 				       access_mask_t access_request)
 {
+	unsigned short sock_family;
 	__be16 port;
 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
 	const struct landlock_rule *rule;
@@ -69,6 +70,12 @@ static int current_check_access_socket(struct socket *const sock,
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
@@ -105,7 +112,7 @@ static int current_check_access_socket(struct socket *const sock,
 			 * these checks, but it is safer to return a proper
 			 * error and test consistency thanks to kselftest.
 			 */
-			if (sock->sk->__sk_common.skc_family == AF_INET) {
+			if (sock_family == AF_INET) {
 				const struct sockaddr_in *const sockaddr =
 					(struct sockaddr_in *)address;
 
@@ -183,7 +190,7 @@ static int current_check_access_socket(struct socket *const sock,
 	 * check, but it is safer to return a proper error and test
 	 * consistency thanks to kselftest.
 	 */
-	if (address->sa_family != sock->sk->__sk_common.skc_family &&
+	if (address->sa_family != sock_family &&
 	    address->sa_family != AF_UNSPEC)
 		return -EINVAL;
 
-- 
2.53.0



