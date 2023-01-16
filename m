Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFB16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DC4C433D2;
	Mon, 16 Jan 2023 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887518;
	bh=Lf8qMhnUxKWnP6DZWKj4Y5AGY0614juHF47mQ2i5WhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReYeI4OCYJ/CTUsx9D0VcKafC53W0lTeGbMkmXT8Fs4cAV0Qq4ybgmKS8CzhCM5bt
	 ONBGRMvsVxU89b+C1HvlS5YpwnKuRllux0ZPhqBY9DvjUTnhW6lpYMGN9Rc/UxX2y1
	 QLaYSAdLNT3RE+L9I1tZ1fzVd+xw2MSiTzf1M7/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/521] apparmor: fix a memleak in multi_transaction_new()
Date: Mon, 16 Jan 2023 16:47:22 +0100
Message-Id: <20230116154855.128037516@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 8868c475205f..80012d21f038 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -869,8 +869,10 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
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



