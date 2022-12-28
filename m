Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F2C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5901C433D2;
	Wed, 28 Dec 2022 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243726;
	bh=ePLCemy2YIiZAvrzGA93uok9W6nFdUjaEHU7U60Ldvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYCBNaCghzy+vX0rwUzcA7H/Q0KR5qAZ8VWdRrzn18Up5dJQ5kxIkZ4rCd8lX68JG
	 RlguLdFMCx7jWKbEkC1eK4MIMfuvWpoZTW3VDe2gPo1A5AVNUSZcsVfr5qmlRPm30A
	 Br2JiALNTxeJfGmoYlYo17gfhKQjvlJDOk0qPGv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Simon Horman <simon.horman@corigine.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0545/1146] af_unix: call proto_unregister() in the error path in af_unix_init()
Date: Wed, 28 Dec 2022 15:34:44 +0100
Message-Id: <20221228144344.976002022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index b3545fc68097..ede2b2a140a4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3738,6 +3738,7 @@ static int __init af_unix_init(void)
 	rc = proto_register(&unix_stream_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
+		proto_unregister(&unix_dgram_proto);
 		goto out;
 	}
 
-- 
2.35.1



