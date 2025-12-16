Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B9136C5BE;
	Tue, 16 Dec 2025 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887458; cv=none; b=OgiCE6VjojcQlbGZol5QLm7n+sxpWzs01BWBcldd7Bgi8uYMnbK9IBxmKrjElkhCUZVA6vHeAoT0FW9+cHloBwWt8iR5Imvsl7j2an3uuNdi+4Mj+6Ho10CQTgk8pw1WhD2VQqwwCSu4uH+IkCXbhO7Ycmrs+kUrOu59p3faGwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887458; c=relaxed/simple;
	bh=7S8JDw5CeS20vwzOjhwQuTqCGY8KwiJilGCnJ/Bnqz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9NsmHFAttrZzJayMLVt5fMCd/1ccrjsTHzNfkeyecnQA15mrejGB12v4el791oJLwG6mmxWh4LvcKgz5rBkWlZ7sbtCMqoWsdONsqIcN5uks6AyIFsxjQ9HuuO1g+qBj5I/9KxfaQVXKkgPi9bf9/NfT2EwrKusjC3Z4AF7coo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrkzaYJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrkzaYJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C26C4CEF1;
	Tue, 16 Dec 2025 12:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887458;
	bh=7S8JDw5CeS20vwzOjhwQuTqCGY8KwiJilGCnJ/Bnqz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrkzaYJoGNzF2FlS0OVAR1smdB8dtC8TMikXd8TeTLrwtWFL4O9XXBzA8QLJDQAKb
	 27k1QeqkWLLjaq3B9pQUTUn7Qe7LVPSwKzxMH2kNwdE66Xg228YsL8vMk3ryDZaXh6
	 NOFuhPdv50Q1vqudjs9EV1p0p895gEAFjcpcayCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/614] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Tue, 16 Dec 2025 12:10:02 +0100
Message-ID: <20251216111409.883353348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit a338d6e849ab31f32c08b4fcac11c0c72afbb150 ]

After device_initialize() is called, use put_device() to release the
device according to kernel device management rules. While direct
kfree() work in this case, using put_device() is more correct.

Found by code review.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251110005158.13394-1-make24@iscas.ac.cn
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index ef4abdea3c2d2..9ecc6343455d6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1450,7 +1450,7 @@ static struct rtrs_srv_sess *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	kfree(srv->chunks);
 
 err_free_srv:
-	kfree(srv);
+	put_device(&srv->dev);
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.51.0



