Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640334F470;
	Tue, 16 Dec 2025 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885642; cv=none; b=cAmTDVUVWl88ywLKixzKsJBpq0QBjU/gp1W5bjBf3KqF/KBwClxrGxBjo/SBiSD0GS4wsTWxNT9Q5WM3hUDoHhr58BmrRqUM/AY+F4L2HgWzR4XZdfcK8cWhZZv6NSfaC2vuHKmFE9TrFMcQktK3S0QxRpjtf/NaQ9vxrW5HUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885642; c=relaxed/simple;
	bh=4EO4NJT0bjDUXVM8SWizht92enNYlOzPB5SgIAo3VGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYiVdgViA3d1L1w5Q8gzDkG7cN7r/a2zUpVbNb07W4tDR5UZ0cW6G5SrtANYyB3m1Bsuzz20nrgu0czElYbb63fZtYpyJk1Df90jTij2yFuUr3OHXQHSA39Yug9sQP4ma43gwz3/vKsej2QPuoDLuwdQ0l7r3xe8ANWgAj3KPSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7bOG6zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7bOG6zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87C1C4CEF1;
	Tue, 16 Dec 2025 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885642;
	bh=4EO4NJT0bjDUXVM8SWizht92enNYlOzPB5SgIAo3VGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7bOG6zxgeG7lOcyUiw0iQf5gGaHYELe1758HuSlpsvEZL0Vttth57IarX7lC3hcr
	 RBny5Y1YlYWr5LPWFsqsE7aihWzPr26fC+WieaPtXse8qAa1BLLfGAJbqYTZSkNKpD
	 m6lqpONsHJ2GMIjlzvCBINUEuerqBS2pPaZuY2hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 199/507] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Tue, 16 Dec 2025 12:10:40 +0100
Message-ID: <20251216111352.718007390@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



