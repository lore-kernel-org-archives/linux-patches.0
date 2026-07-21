Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1524446D56B;
	Tue, 21 Jul 2026 17:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656088; cv=none; b=DUTayGPVSZrPa38feUUba3S5/TuZOkFaeFU9bUpLSuL7laBB5uY8MS8B2dhXKWF19B6o94r9O/+SrNdrYAfSLSsKetbdwfMKFbqlMQhuGoGjwcJYsa+zY8ASo+b5XVO747/bRy2b+ugqe+UEPX7VGW4Ffr8t/5eFi7IybQIFlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656088; c=relaxed/simple;
	bh=R+EcHK1KCJ+TzPaPZiWOvRqN6YRaVYoP23RNr+ue/+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5DQgeTH2VSfZuh8obtOkmrYLt1D7e5RpQTC8ZVROpEiRQQExNfc27Fuvu+Su1tKgshQQcGdPgTh0RLACKMadIc1mjoRFwFqldvi6pBizO5cM2ESBbjOYZKb7i0fk5RQLv9TMnjE+g8+U6kiDlAmbAHrqK/0ggWKDHlEu15dhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZy9TJb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZy9TJb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F581F00AC4;
	Tue, 21 Jul 2026 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656083;
	bh=fCrrK7MrVXLb5NAGJ/sKlJhm/cUPhD32agpaPRGENCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZy9TJb6cP7zMcRX3IYft3ePxOoA+7tLSxGe5d/BPHuEWM+q9OIcbjJfYFQxGLMzR
	 AKIruVb0ShW76xJ7OWn1qQMgY9zgWqDAue7IcLWSFxHtzIO3pWjOuW7R43w09vu0f3
	 WtcaQGnR2EI399Uiqw6PDnlpI6/06ZcQWqwu9EYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0236/1611] nvmet-tcp: fix page fragment cache leak in error path
Date: Tue, 21 Jul 2026 17:05:52 +0200
Message-ID: <20260721152520.321521673@linuxfoundation.org>
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

[ Upstream commit 4dae393956093c807212918fd91a8fc70df15338 ]

In nvmet_tcp_alloc_queue(), when a connection is closed during the
allocation process (e.g., nvmet_tcp_set_queue_sock() returns -ENOTCONN),
the error handling jumps to out_destroy_sq and then to out_ida_remove
without draining the page fragment cache.

Although nvmet_tcp_free_cmd() is called in some error paths to release
individual page fragments, the underlying page cache reference held by
queue->pf_cache is never released. The first allocation using pf_cache
is the call to nvmet_tcp_alloc_cmd() for queue->connect, which happens
after ida_alloc() returns successfully. This results in a page leak each
time a connection fails during allocation, which could lead to memory
exhaustion over time if connections are repeatedly opened and closed.

Fix this by calling page_frag_cache_drain() before freeing the queue
structure in the out_ida_remove label.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 0bc66644a3e665..f5cb2dd0def332 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2023,6 +2023,12 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	nvmet_tcp_free_cmd(&queue->connect);
 out_ida_remove:
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
+	/*
+	 * Drain the page fragment cache if any allocations were done.
+	 * The first allocation using pf_cache is nvmet_tcp_alloc_cmd()
+	 * for queue->connect after ida_alloc().
+	 */
+	page_frag_cache_drain(&queue->pf_cache);
 out_sock:
 	fput(queue->sock->file);
 out_free_queue:
-- 
2.53.0



