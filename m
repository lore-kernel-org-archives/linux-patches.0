Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5D826B94E;
	Tue,  8 Apr 2025 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116497; cv=none; b=ORGQ0MLQ0fiEWAGBymNKRlrH4/QYUq73wKhkZE3HADhzbA0YtpHA8oKdkZpFGXSih8eSDKkcCXci9MOZO4zgn1rxgo2mxeZcybXvF1APlcEtL/1jM4VMjIF24trSOXE0SmFuEQ/d+hrgUkJhjVnCK8Ar+uEPRBy0Yi9FeSbpO1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116497; c=relaxed/simple;
	bh=pzpqRieyeepJW/Nd+1aJxG6XzlMM/2JMX/C8A/mbEJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpOgy2iu8+gOTdsTG29AjLY1+3958g3FhwGaNKB45U5Smg+g4SCayDzS6KMlYwTBNKorEWkxuC3kNkj6uV42UrZZRgrN4xi0UkeQKkNxJcaWB0eWJ+FhB8/5NXRw31lpDlKAb8jrwNAXNMOk6aMvFxnXxauYaVujrnYc22Pk2kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbYQinKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbYQinKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03EFC4CEE5;
	Tue,  8 Apr 2025 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116497;
	bh=pzpqRieyeepJW/Nd+1aJxG6XzlMM/2JMX/C8A/mbEJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbYQinKfdu8GjTX74Vr/7rOs7ZNMF0tRkhBbrIZnFjw5TxFfS3qtTh7xMZ2f4IlpY
	 X7kb3EVKSeNBhbuCdeC9XAo/8wCt4+yU1VZ/jlKojYfCUh0s4ADHTWYuVSee4a9RBz
	 5BKfko8nIEsbPW9VDrLClh17oK9k5NG8s2V3kz4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/423] RDMA/erdma: Prevent use-after-free in erdma_accept_newconn()
Date: Tue,  8 Apr 2025 12:47:40 +0200
Message-ID: <20250408104848.849211987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 83437689249e6a17b25e27712fbee292e42e7855 ]

After the erdma_cep_put(new_cep) being called, new_cep will be freed,
and the following dereference will cause a UAF problem. Fix this issue.

Fixes: 920d93eac8b9 ("RDMA/erdma: Add connection management (CM) support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
index 771059a8eb7d7..e349e8d2fb50a 100644
--- a/drivers/infiniband/hw/erdma/erdma_cm.c
+++ b/drivers/infiniband/hw/erdma/erdma_cm.c
@@ -705,7 +705,6 @@ static void erdma_accept_newconn(struct erdma_cep *cep)
 		erdma_cancel_mpatimer(new_cep);
 
 		erdma_cep_put(new_cep);
-		new_cep->sock = NULL;
 	}
 
 	if (new_s) {
-- 
2.39.5



