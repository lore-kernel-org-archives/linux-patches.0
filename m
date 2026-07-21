Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50A46D0B9;
	Tue, 21 Jul 2026 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656113; cv=none; b=QH3apBt4a8yqbmy5qDCjvB+nc0CXt/vceAuIcdiUxAyIexwXXojoZ3f0H9gbaVy5ZPjfUARKxTAnslF/+mFPIfJmz4juisJ7jRNhmkCod4Pea4meRpHNShwoC60W2vqvNn0Djm8vxxWEMsjlbEVpGtCl73s0rwnsqvGqf7HrZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656113; c=relaxed/simple;
	bh=yjfeDTlWyfwLFUncnqO4m/7wPyFJmRYyxnjEqJaHENg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P25JuX2OsTo/YkI2f+gds1xTBUpe+rIlfFxKpsrRMKa/ubzwgUQG0iQIsQzrdNntpfbwYiI4EBv5jO+QExDJGTtBTPyYJO2M1FYY54PyHF9oX3aPBKWaZrNPrwchpvnMuaJ2uEl/QvQiW3L20VUjgVjEqWivLoRzYktn1tXh8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWQUPWXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWQUPWXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748041F00A3A;
	Tue, 21 Jul 2026 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656112;
	bh=QB0iZiuaxrCBop5N8FhW7JRNYb60bUkZnh5CNYamZ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWQUPWXSZ3zn8xsOO3gN0kQAXFh1Ly8BqBZ5PnnDk67XLbltj7Lck8IUZJN1bvJ61
	 RPz1AlG6nhrk4z1gW6Pt/0TaFztfP8USk6gx9JeAhGdMrCSl91AF1mxUi6Zn5SAnYy
	 MhY+hwwj0hCSguUznpaSQHiIFubq/qsvhNiRjucY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0237/1611] nvmet-tcp: check return value of nvmet_tcp_set_queue_sock
Date: Tue, 21 Jul 2026 17:05:53 +0200
Message-ID: <20260721152520.344953691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index f5cb2dd0def332..0b8cfa3dbab12f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1868,10 +1868,11 @@ static void nvmet_tcp_tls_handshake_done(void *data, int status,
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



