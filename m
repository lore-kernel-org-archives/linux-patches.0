Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADA415F14;
	Tue, 21 Jul 2026 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661719; cv=none; b=iZUQqhdtrLsHPDmkX6Yn5M6A9WTOJILizBQQE75w8xg4gqCwQMFfFSezqZVSB9Lycsg+UYAisvcKu71EzvC+u2B/SyU6sqINe5PJMK1PeEmOprOAa1axRxMq8KjZtPGJhvq/sJ8XIG0WEsUhK8HldBKvaok+n1IJLopE5+X0i/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661719; c=relaxed/simple;
	bh=Dn/nFXZJ2+L4RUYq5ctugCj4HGUCwixDpW0NtuQ4OVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBBtSawLOekpXyKUCYZubyVKDZrFyHClLEP+s6D35+FZputXAkNSnEz+t+8m7oMyrDuZjRsSqBDWbAiqw6Oh05qAEgb6PURUL+fL4H3/CaaHtqN/OUvuAMHMiTc5RsFiI7iGwMnH43IemPf+NK69pKxiLmtwtc/SkXEWragiFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBzGDmjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBzGDmjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594931F000E9;
	Tue, 21 Jul 2026 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661717;
	bh=anh6a1CdjlvMKQCCtKbaDN1J9x6EbjHAbPzptkiWCoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBzGDmjE02u3fMtIU9eIG5JGlT373BVakkTW78Ez0c5nR3+uTuotej2OLQIdLH3dj
	 hV/EKiiUpC+dfNfQFyNYKeh5SVMa1ov80152gHbj3urTyM3bnLOyeFX+r7+hldEFWt
	 XkTRtOEGqjqVPDbLmD6E5MrreCv0WD/JYgi5TfNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0171/1276] nvmet-tcp: fix page fragment cache leak in error path
Date: Tue, 21 Jul 2026 17:10:14 +0200
Message-ID: <20260721152449.924782080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22894902f40ecd..dbb6230b4b7f8f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2035,6 +2035,12 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



