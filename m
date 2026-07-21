Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9246A5E3;
	Tue, 21 Jul 2026 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648787; cv=none; b=gn3KqWetxkn79cyHWrTdJLSX60cgb0WG7JkWyBcgN+ydIeW4dl4bQSwJfjFNbQcfUBofKqSKEqSBSvzbiEZLfkY/7FDnOu/QPH1JwKCHZYeacZspz+w/zdqm0xv+2ck53QJlUXH+4eoWUrBkQLsexBMZVJpRcdwGMdjxRV8uX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648787; c=relaxed/simple;
	bh=oG89YR8IlbUmogzyGXA5HCyi7e16nvEiAODpeJNzO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBO215qFUDNkr6m4WyJp1lF9RWzrRQyfh/K+g302Hx7sB5SAZIunu3fEzGrtcIGnqN/bfqOKOi9oQWyKrBl07HyUKnH9DkD7uF6od3qeyfY6W5BqrhGubAwskM+wbah2DfQogFG0xSlcMnSJm7B7kZRzCTQJYiwFf7K2CUOqQvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ancDf1+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ancDf1+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19511F000E9;
	Tue, 21 Jul 2026 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648786;
	bh=aTrkG/g+YWx4xgseaZrQpkAanlzYv74BoB3+dsWpjOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ancDf1+WeHaZczUpl0oz5/0qdQ3AjUyudo2ibIAybrdK5xZe+V3WXfHO9KLnOE4VJ
	 7rejftdEhZCG/hoAKsZqiVBznXkhznhPkEPfp0BdP9w+N7vjqmX6epTG82wSZfps9A
	 YCcj36bucC+d6qsPKjYpxYwjuFIag/NVx9WmJhC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0332/2077] nvmet-tcp: check return value of nvmet_tcp_set_queue_sock
Date: Tue, 21 Jul 2026 17:00:05 +0200
Message-ID: <20260721152600.515275028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 7ef789703e2b91775dcb36b2efa46325be31a2a0 ]

The return value of nvmet_tcp_set_queue_sock() is currently ignored in
nvmet_tcp_tls_handshake_done(). If it fails (e.g., due to the socket
not being in TCP_ESTABLISHED state), the socket callbacks will not be
properly set, leading to queue and socket leakage.

Fix this by capturing the return value and calling
nvmet_tcp_schedule_release_queue() on failure to ensure proper cleanup.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 57a6da696fa0b0..15c52f1f95f1b0 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1844,10 +1844,11 @@ static void nvmet_tcp_tls_handshake_done(void *data, int status,
 	if (!status)
 		status = nvmet_tcp_tls_key_lookup(queue, peerid);
 
+	if (!status)
+		status = nvmet_tcp_set_queue_sock(queue);
+
 	if (status)
 		nvmet_tcp_schedule_release_queue(queue);
-	else
-		nvmet_tcp_set_queue_sock(queue);
 	kref_put(&queue->kref, nvmet_tcp_release_queue);
 }
 
-- 
2.53.0



