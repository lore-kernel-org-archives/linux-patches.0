Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61CBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E351C433EF;
	Tue,  7 Mar 2023 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215974;
	bh=kdtPLffp0suWmww4+ZPOFlY086JqNVxevVOpX3FHGYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZ4h/Da0W9kTRzJHU2dsbxrLcGZMBQfPLtDidV8LnVPkZi1FbuBSSII1Tg3d0AD5C
	 3Vu+9Z2ulcgltPo4yPEX1MhGqQDhLAHB8c3uj850ewcOgNl+po2952EYPz5oWCIc9T
	 iPFtHofCBBs3IBQWrpLU9zLAj2fVkUJsEz6egbvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/567] scm: add user copy checks to put_cmsg()
Date: Tue,  7 Mar 2023 18:02:18 +0100
Message-Id: <20230307165923.252868231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 5f1eb1ff58ea122e24adf0bc940f268ed2227462 ]

This is a followup of commit 2558b8039d05 ("net: use a bounce
buffer for copying skb->mark")

x86 and powerpc define user_access_begin, meaning
that they are not able to perform user copy checks
when using user_write_access_begin() / unsafe_copy_to_user()
and friends [1]

Instead of waiting bugs to trigger on other arches,
add a check_object_size() in put_cmsg() to make sure
that new code tested on x86 with CONFIG_HARDENED_USERCOPY=y
will perform more security checks.

[1] We can not generically call check_object_size() from
unsafe_copy_to_user() because UACCESS is enabled at this point.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/scm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/scm.c b/net/core/scm.c
index 5c356f0dee30c..acb7d776fa6ec 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -229,6 +229,8 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	if (msg->msg_control_is_user) {
 		struct cmsghdr __user *cm = msg->msg_control_user;
 
+		check_object_size(data, cmlen - sizeof(*cm), true);
+
 		if (!user_write_access_begin(cm, cmlen))
 			goto efault;
 
-- 
2.39.2



