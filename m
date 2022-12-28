Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A8C433D2;
	Wed, 28 Dec 2022 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239380;
	bh=1eHlPWMDGp4DS94jcIO3DsXlxma9F18wDChrhdcoaqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dojtuuNzc93sbGa4FiPVh0G7oH94yG064+LhWT2bRF4u4KmWYgJqbcebL05UkRhql
	 LBLAB3V33EWIUWRQKnqscDef9kS0epALXJ5rKfzlqD+uiJHHlsxjF+Cn6qSIBGe8XQ
	 ma0S8vWnin5T9ojTe13iW7JuwpFZD4ot+eDt/K+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/731] inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
Date: Wed, 28 Dec 2022 15:35:22 +0100
Message-Id: <20221228144302.788793372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index a53f9bf7886f..8039097546de 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -155,10 +155,14 @@ static int inet_csk_bind_conflict(const struct sock *sk,
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



