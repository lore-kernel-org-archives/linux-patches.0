Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC05335BBF;
	Mon, 18 Aug 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525021; cv=none; b=UouOe4fI5n/Dsv6PGWTb4riqKk6BayXEsRUOqUFyP7/RtTP2QLHLe5qtbs/guOImGLIP22uodWEA0lOumiD3ZUVqsV8qALyosSyb6zVZux5UgwA0TWQeWCRVx1iG+8OrWs/uyy/EJKZ9qaBr4hsZn9Ic8cJigGxHrQt/ANvUVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525021; c=relaxed/simple;
	bh=8ChRynjqmwz66UI6rPsfK/J86BG9ekSznx4ftjSu7y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGOFzrFJ2TBH+IvvvQq5MTUVb8PE5SU8xIGUlYerZBPcmOqv9HIOkVCefXZvXWps6hObKgYfiBZOM8tt/fPFPhTu3GRvVNhviFZHxhhVMa1MQlaJqJ2Qu+OHIoeq+5ult6r9tvs0YAI3qUyBLBXkPuHj6PaBbBp9SwyFrXzOMT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/hStNJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/hStNJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69DDC4CEEB;
	Mon, 18 Aug 2025 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525021;
	bh=8ChRynjqmwz66UI6rPsfK/J86BG9ekSznx4ftjSu7y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/hStNJGor1VKSZRXwWkorQ4kyjWZL+kkEUCT78LLNQRQF4kGD85i6YQf7Olnt5ff
	 9tkIQJjOS+PeodiQQzDjp7fMBdjGTbccHniGgLyhgMf4A+B1kufv/exhB3/IedRhMf
	 GbhNmsyoIiUTUKzKmFHt5q0ldaBYVhhQPxgztnmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 103/570] nvme-tcp: log TLS handshake failures at error level
Date: Mon, 18 Aug 2025 14:41:30 +0200
Message-ID: <20250818124509.778785123@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 5a58ac9bfc412a58c3cf26c6a7e54d4308e9d109 ]

Update the nvme_tcp_start_tls() function to use dev_err() instead of
dev_dbg() when a TLS error is detected. This ensures that handshake
failures are visible by default, aiding in debugging.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d924008c3949..9233f088fac8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1745,9 +1745,14 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
 			qid, ret);
 		tls_handshake_cancel(queue->sock->sk);
 	} else {
-		dev_dbg(nctrl->device,
-			"queue %d: TLS handshake complete, error %d\n",
-			qid, queue->tls_err);
+		if (queue->tls_err) {
+			dev_err(nctrl->device,
+				"queue %d: TLS handshake complete, error %d\n",
+				qid, queue->tls_err);
+		} else {
+			dev_dbg(nctrl->device,
+				"queue %d: TLS handshake complete\n", qid);
+		}
 		ret = queue->tls_err;
 	}
 	return ret;
-- 
2.39.5



