Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A971863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD723C433D2;
	Wed, 28 Dec 2022 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240481;
	bh=aESX1RkqR/B4Ju34SwjqAbfw43L/SAs3WrSSqs6wchw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEQkT57l+yvTTLDrIUck7E1bF5Plp16d2xeUyyhOMtu+4NsKstHgZ6IwdR717BNAj
	 E3jhS9xSjvKQOxXWka1YEkeBqhMnewX0iUsJMryMBlKD4idGxA+4Csk6a/mWWmwSVe
	 xk4wsLsAmC/C0u45VSRKqY5b4XS1AWTzG1v5tDx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 358/731] apparmor: fix a memleak in multi_transaction_new()
Date: Wed, 28 Dec 2022 15:37:45 +0100
Message-Id: <20221228144306.938681222@linuxfoundation.org>
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
index a891705b1d57..8c7719108d7f 100644
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



