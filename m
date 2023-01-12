Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D0C749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC0C433EF;
	Thu, 12 Jan 2023 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532888;
	bh=gF1lkcYF29gg8fx72uf5rO5vAAc3m1MmbkLcp5tEfjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKNHER6bnOyfqUOMHB9HjhK8JHPvnXal3ucbguuAX4t2O6OsK6TjAGmrfFJ4sEDRO
	 EQNy6hL7kPDwdWOciZuaCq6QBHYsPkQkd0KEZnOst2YPb7dKDlgOwk6Prrve2G+5/d
	 34X6H+GPHmJW1gl11JlpetUAfsa8G9MS0sGv/TKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/783] apparmor: fix a memleak in multi_transaction_new()
Date: Thu, 12 Jan 2023 14:49:53 +0100
Message-Id: <20230112135537.237662469@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit c73275cf6834787ca090317f1d20dbfa3b7f05aa ]

In multi_transaction_new(), the variable t is not freed or passed out
on the failure of copy_from_user(t->data, buf, size), which could lead
to a memleak.

Fix this bug by adding a put_multi_transaction(t) in the error path.

Fixes: 1dea3b41e84c5 ("apparmor: speed up transactional queries")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index c173f6fd7aee..49d97b331abc 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -867,8 +867,10 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&t->count);
-	if (copy_from_user(t->data, buf, size))
+	if (copy_from_user(t->data, buf, size)) {
+		put_multi_transaction(t);
 		return ERR_PTR(-EFAULT);
+	}
 
 	return t;
 }
-- 
2.35.1



