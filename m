Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B6749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D5CC433D2;
	Thu, 12 Jan 2023 14:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532439;
	bh=tBOFhDwL4CP+q4Dr2F1cDRNb1jZkG+QPt7Yi4djoQYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pThfAVQCcI3NUJH3Tyxk2jPRJeJuxS8aoohQMIhpzTVGne3ZIZtoeTYkPTTPJVvNv
	 yv8qenf/fjXjZF/9Lnt/L4AXO+dA1IrHK4XF4hGMm6X4UzLixQQ5577W++Ea46UUd4
	 Sr54+SmknwbPbNROe8ZMMhAfZsrWWSeQrW0dwZeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/783] inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
Date: Thu, 12 Jan 2023 14:47:58 +0100
Message-Id: <20230112135531.842482821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d2c135619cb89d1d5693df81ab408c5e8e97e898 ]

inet_csk_bind_conflict() can access sk->sk_bound_dev_if for
unlocked sockets.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 4d9713324003..e54abccdffd0 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -147,10 +147,14 @@ static int inet_csk_bind_conflict(const struct sock *sk,
 	 */
 
 	sk_for_each_bound(sk2, &tb->owners) {
-		if (sk != sk2 &&
-		    (!sk->sk_bound_dev_if ||
-		     !sk2->sk_bound_dev_if ||
-		     sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
+		int bound_dev_if2;
+
+		if (sk == sk2)
+			continue;
+		bound_dev_if2 = READ_ONCE(sk2->sk_bound_dev_if);
+		if ((!sk->sk_bound_dev_if ||
+		     !bound_dev_if2 ||
+		     sk->sk_bound_dev_if == bound_dev_if2)) {
 			if (reuse && sk2->sk_reuse &&
 			    sk2->sk_state != TCP_LISTEN) {
 				if ((!relax ||
-- 
2.35.1



