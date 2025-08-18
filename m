Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EE322764;
	Mon, 18 Aug 2025 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523166; cv=none; b=gAwhLaxOMwbXRpSKHL+TuFhD2f06SJjSRQ1z9jyArZSwrfFzpCqh76vPWEHcEsUpcx+caXDu8SWmSjpSEWfODkRw4Oi1zGSLzgLw1O1Zk3SrS12w9GUh6ypaV4gidnn3Dg/o+CBGux+lxgJlUVu/AI+Coyt3+G3yfFYgIpK+A2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523166; c=relaxed/simple;
	bh=UVBz/5zbfsdZbGUaORDTLekfgersHTrJMSzJuUIkAFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLD7d4iJy35mZfUaqA64gouQcacGBAqHwSLPwTw4qtFFrz43YRSKkAJLDOzBH7Cp9T6pPG7vY+YIbwSnn2y0GvrN2YiTFD9+2ZT/2Nnj9ckr2plxXoA+ZlhJkP5I0ykUdwC/nYw+qhcGsbmlaUVYly7UA9MYuAypnu2UXtSctdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9FFOqx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9FFOqx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7135C4CEEB;
	Mon, 18 Aug 2025 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523166;
	bh=UVBz/5zbfsdZbGUaORDTLekfgersHTrJMSzJuUIkAFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9FFOqx7iobQWhlRxlR3yZKaLeZb0sJCfs66lP70cBxV6P/T8UiMct5hpKlSBFTbS
	 AhrBkGCE3/9bVIcPXFk8T6UI3w43WhjfH2bRzwJvcgwSpDfAv/H/8zc191PqlQxcQw
	 yHlRT34YPvGE6Aj/fzC4DqkQPZzxXcKsxxEjW1rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 091/515] nvme-tcp: log TLS handshake failures at error level
Date: Mon, 18 Aug 2025 14:41:17 +0200
Message-ID: <20250818124501.877476947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b882ee6ef40f..d0ee9e2a3294 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1776,9 +1776,14 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
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



