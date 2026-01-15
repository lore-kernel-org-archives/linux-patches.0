Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA418AFD;
	Thu, 15 Jan 2026 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497456; cv=none; b=Lu4RnccfE8HIvFajGa9yENLg/sd18IBhIx3HO+YZV+mgFs/Qfm0Slre7rkr7h2pBg3QsNArmOeeX+8MljncxnSEYVZ7WilcbhPv6OsshOq0CLuhcNwPOCdRNxb2vAASm2b5E16yOyI4STK9YejikP0ZSYxrYNBaikc8EfYDX+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497456; c=relaxed/simple;
	bh=yZw6xrS0Hh1EY4ATO3cmnmjeJcKFrpVfBcnWSNBS4fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGDiwoPRSmXh2OZKgAWcyY0dZ2eskkFG4LZEqDT3U6R6XcirCUyjiul7cHYPeoKTYXt58iy3T8dsFIz843nUHQ4XvHh9rJ/nvtweoOjnbLMsC0O38O3cb/ktpfhiDA5atewSeWiWGcj+ZHTFEiG5QjSmSM1W29MVYSt6LvCufK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDsgdJ/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDsgdJ/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4690CC116D0;
	Thu, 15 Jan 2026 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497455;
	bh=yZw6xrS0Hh1EY4ATO3cmnmjeJcKFrpVfBcnWSNBS4fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDsgdJ/Kdb5N1apB+ZqtVJHzz/VpLSlMzgmJN6OnOIrFfxkdfqlIjJxWR32w7H1ox
	 6PEBv5CSCbotyAekkv5yoCeIhiL0B5QVQm9oWJDB52dKXL/MoNpK1eSQknzZeR9bue
	 GijA2JBJALJYOdZG7Pwxh6Py0GSkH4PVQl6piyls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/554] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Thu, 15 Jan 2026 17:42:33 +0100
Message-ID: <20260115164249.397694287@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 96fe7c97bc713..ec3ab8df32f7d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1453,7 +1453,7 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	kfree(srv->chunks);
 
 err_free_srv:
-	kfree(srv);
+	put_device(&srv->dev);
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.51.0



