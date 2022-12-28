Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAC01863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CBCC433D2;
	Wed, 28 Dec 2022 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240329;
	bh=3Q9Ed8auQaTghL45ipcy5dENrm8ZkV7jbGeGcTsb89s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgTLIKimK+QkV7cRmG4V9bdMlXuSCZT+8MQzV6WphK+TJv2q1/TB84mVALllMuq4R
	 lm7OH5xOvF5icDT6BsH4jjrwOmRydnQFXgbXYnXsIIsMbCf4d19yI7u+alk+pfsys6
	 vffbUsBfJmTDU+cZWJQiE/4fzkfwtzHa1dVhyEkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/731] af_unix: call proto_unregister() in the error path in af_unix_init()
Date: Wed, 28 Dec 2022 15:37:24 +0100
Message-Id: <20221228144306.337118308@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 73e341e0281a35274629e9be27eae2f9b1b492bf ]

If register unix_stream_proto returns error, unix_dgram_proto needs
be unregistered.

Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a579e28bd213..545823c1d5ed 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3401,6 +3401,7 @@ static int __init af_unix_init(void)
 	rc = proto_register(&unix_stream_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
+		proto_unregister(&unix_dgram_proto);
 		goto out;
 	}
 
-- 
2.35.1



