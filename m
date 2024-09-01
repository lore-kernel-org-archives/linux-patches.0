Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6AA17CA1F;
	Sun,  1 Sep 2024 16:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208867; cv=none; b=S8pzVDVyptYIrjrZGpMWjY5tf4Dsf/IRGnMfZ3EQEaD1SBYB9zKY3IJzRrXox4lnxibJoC3ujixrxFWU7a76Y+TfkSYA9SJc79T0LuX5sJ275tS06p6wHAfB6RfnwKoYcnGZRsq6ldnNsDryNSroMlXonlwpOwnfCTAsTKbRhTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208867; c=relaxed/simple;
	bh=wYiKBCmR/TI2wJcccArIh6l9yefFl06tMXqEjXAPVz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYRmHu7BxBKKNnclKY08pP7zFdN4ySxKYz47bBiW68w4n/UKG7GCdc4/Qs0XaRkTOWT40S6ccJoH7wlMo3b+3kLpODAos53ycYYrKVCyrhDiH+xv421dIsHmAdzMFMnzmpIkFGzS+GNr3349JAz+p1QBgdAjRUqAEF7En1ydQr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYkIsQOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYkIsQOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921BFC4CEC3;
	Sun,  1 Sep 2024 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208867;
	bh=wYiKBCmR/TI2wJcccArIh6l9yefFl06tMXqEjXAPVz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYkIsQOgOxLk9P/NJk5mzvFD9a+hQnt0nw1tqcMgMgCnc6/EggoPnAYo4tcbl/0Hu
	 LSfnP00ES7nkdh4KjISC/jYXsLv7H0Y4FPkH6nZ7c+EOfm+bknYpD+1k1546yX56S2
	 LfRC3EOHD7sKI8IQu+RK13GG17SukfflvBeVw24I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/134] nvmet-tcp: do not continue for invalid icreq
Date: Sun,  1 Sep 2024 18:16:50 +0200
Message-ID: <20240901160812.510562967@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0889d13b9e1cbef49e802ae09f3b516911ad82a1 ]

When the length check for an icreq sqe fails we should not
continue processing but rather return immediately as all
other contents of that sqe cannot be relied on.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index d40bd57537ba1..fa6e7fbf356e7 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -792,6 +792,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 		pr_err("bad nvme-tcp pdu length (%d)\n",
 			le32_to_cpu(icreq->hdr.plen));
 		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
 	}
 
 	if (icreq->pfv != NVME_TCP_PFV_1_0) {
-- 
2.43.0



