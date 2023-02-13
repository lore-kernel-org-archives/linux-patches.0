Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234458F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AEFC433D2;
	Mon, 13 Feb 2023 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300277;
	bh=kqsj8GBwo3z2c6F2QSkJYt1xH92vpxSTSaPaCIOJuf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0CzE26e+Bd0jhCiYVa/6/DaorZIz5R2KcfzHHwhZxwzcjpZ7EtVBTQU2SqZE1Eu7
	 KwRD8Ev3QQXC6arN1wx+f3Fm+PUeOBbXG6fH//1WJ/cBvjqB7jSOd8MfcnbTrQm3F/
	 U74aSu/rRhtnyEr/w4ZfjTOVpGbrj1F+8MF6h3FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Dmitry Safonov <dima@arista.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/67] xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
Date: Mon, 13 Feb 2023 15:48:58 +0100
Message-Id: <20230213144733.158652107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

[ Upstream commit b6ee896385380aa621102e8ea402ba12db1cabff ]

  int type = nla_type(nla);

  if (type > XFRMA_MAX) {
            return -EOPNOTSUPP;
  }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

  if (nla_len(nla) < compat_policy[type].len) {

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 12405aa5bce84..8cbf45a8bcdc2 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -5,6 +5,7 @@
  * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
  */
 #include <linux/compat.h>
+#include <linux/nospec.h>
 #include <linux/xfrm.h>
 #include <net/xfrm.h>
 
@@ -437,6 +438,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 		NL_SET_ERR_MSG(extack, "Bad attribute");
 		return -EOPNOTSUPP;
 	}
+	type = array_index_nospec(type, XFRMA_MAX + 1);
 	if (nla_len(nla) < compat_policy[type].len) {
 		NL_SET_ERR_MSG(extack, "Attribute bad length");
 		return -EOPNOTSUPP;
-- 
2.39.0



