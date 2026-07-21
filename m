Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8005646EC63;
	Tue, 21 Jul 2026 18:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659874; cv=none; b=k12kEY0SgseVvYuo7JwPIVQl3Gk3shNOeOE7WdjVhzfwdVnls1AwH64tA+pr+1OKAgbUuJj3UC3oTqXEKLzpeVJKoBeCjPHjOBZTJ3JeBYgeX6L67MY5LG/iATlgEq9eUGBv2vQ2VT9JHRFRCajAfiUuzY2lds58XNepyKmtasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659874; c=relaxed/simple;
	bh=gPwa1giDDd4PUqwPYCDj+sLl3hizAgYlWQzWhNIM0+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRzz3gTG+Fm4CJe3I1RsVuZwYbHvgLZB/cM1f5BT3tguTPx+i4gbtkr7op2hqz/YE6SB3JBmNeRiGkSfIEgFmhHRrCvj5IC4uVseDKVoIQnZ09GYw71ty1cPBYwSBDBesQpRugSwSKTpfCi4giBnKaQzohVOds3q1CNcPLeRzRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eonYumXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eonYumXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581151F00A3A;
	Tue, 21 Jul 2026 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659870;
	bh=FXI3vbLKg8Rb9PycrKpmhE4lOil2dA970ARZTCBEnvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eonYumXNgC5s7IbBUgyvbnWd8biWVpGQt4BI6+7Uurc4+7ZdGNP2acSXEee7g7v4J
	 msm0meEuwcrVSZkR3xkR925TFdJzBjhG1FwKv29ctytGg7WhU+7RUZ3voW1Vl6hC1i
	 ETML7DbocEAOFRWOFzLfKi8BUZFT0fyGu8VHgY7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0764/2077] landlock: Fix unmarked concurrent access to socket family
Date: Tue, 21 Jul 2026 17:07:17 +0200
Message-ID: <20260721152610.816725951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a38bdfcffc22a3..4ee4002a8f5676 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -46,6 +46,7 @@ static int current_check_access_socket(struct socket *const sock,
 				       const int addrlen,
 				       access_mask_t access_request)
 {
+	unsigned short sock_family;
 	__be16 port;
 	struct layer_access_masks layer_masks = {};
 	const struct landlock_rule *rule;
@@ -66,6 +67,12 @@ static int current_check_access_socket(struct socket *const sock,
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
@@ -102,7 +109,7 @@ static int current_check_access_socket(struct socket *const sock,
 			 * these checks, but it is safer to return a proper
 			 * error and test consistency thanks to kselftest.
 			 */
-			if (sock->sk->__sk_common.skc_family == AF_INET) {
+			if (sock_family == AF_INET) {
 				const struct sockaddr_in *const sockaddr =
 					(struct sockaddr_in *)address;
 
@@ -180,7 +187,7 @@ static int current_check_access_socket(struct socket *const sock,
 	 * check, but it is safer to return a proper error and test
 	 * consistency thanks to kselftest.
 	 */
-	if (address->sa_family != sock->sk->__sk_common.skc_family &&
+	if (address->sa_family != sock_family &&
 	    address->sa_family != AF_UNSPEC)
 		return -EINVAL;
 
-- 
2.53.0



