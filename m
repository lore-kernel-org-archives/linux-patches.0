Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A832D94A7;
	Thu, 15 Jan 2026 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498975; cv=none; b=Rj8M19CgzBNwJ6fP5n0RkrSr7/bV7umVc6ciiAP2y6hwmgeWjpqdniokB8Hpv/KGeLnXEk4mD9aB7dl1jZsbs/2WoihulIhQcCO+7oPtINQXjHBo+DIog3vzk+UgmcCZldQdI23bA1KM0ir5tEBQspxs9AMfjwezfubmM4BR1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498975; c=relaxed/simple;
	bh=XogE0jzh3mtjQ6jjpqVeRhaLBXYlWLoee7l2EdMY6Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhVrDN07hIemvwiVNTJfP4CPVgdEmE2bLQB6pbxqEw/nzzR2TGUiVdd84docdTWBvBITUff3z9hbnbcuKxftLqxJqhdEi0o23MHsmnn6eDWXuWv53SYFbYntldaRnnCKJtlAn3870BK7fscxKvaLBlnOput3BEsq0C/c09lA59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np+4/S/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np+4/S/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31244C116D0;
	Thu, 15 Jan 2026 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498975;
	bh=XogE0jzh3mtjQ6jjpqVeRhaLBXYlWLoee7l2EdMY6Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=np+4/S/kXJJJJDgVhj52bng75EdPAbUyhlley2FGYfTh4lRkXka2cqTbyR0/jXUsp
	 8gfTx8GZGX6/McTOpzBjgimlArnJU1Keuh5uncROtudHbRRyxGrl2bMYLzi4s/j8KF
	 SCgzscnG0G1gc3Tg64YWq47xGQxQzwRkoUh4z1fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/451] RDMA/rtrs: server: Fix error handling in get_or_create_srv
Date: Thu, 15 Jan 2026 17:44:26 +0100
Message-ID: <20260115164233.250028944@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2b315974f4789..3e6f12f98a890 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1405,7 +1405,7 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	kfree(srv->chunks);
 
 err_free_srv:
-	kfree(srv);
+	put_device(&srv->dev);
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
2.51.0



