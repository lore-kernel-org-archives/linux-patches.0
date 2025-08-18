Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648F731A068;
	Mon, 18 Aug 2025 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521771; cv=none; b=DFpvnV2QiFRMj0dsTMxcN4k8yge7SBSpKQwhtxXz4xo+TF8bCD6rKr/Zt3LhfnmLiGjGxrkLzC/IHsOP2kJwte2rJ1Wp2STCVirZCXToGoOzFVZa2XwhrGxhOq9qSvF9Nxxq4VOYGpkNpJNrR2g/sM9TVEAvUcInIhfjqa6JwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521771; c=relaxed/simple;
	bh=stkdx/eShTkSPisV+ra+AajdEhCDAOSgXXrHN+e1vUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gvlg5iB07Mzq+VYrvEMRfaFBGrJVjzZP7MR72VWuD5ANApXov8J0n8q6mWoQw71zj9TqVkjGrH5+1LIIRWDvO1e2EZSpUoIRtsZpKx6cTrg/i7IN+MrcZRMV+EImQy2FS5KHiZlG006vwLVidUlDkRFOJgcneSToOLkRxdgSvmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3C3H6c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3C3H6c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17D8C4CEEB;
	Mon, 18 Aug 2025 12:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521771;
	bh=stkdx/eShTkSPisV+ra+AajdEhCDAOSgXXrHN+e1vUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3C3H6c0iprnje/I4MMQ6iMZZ0z9htZicrcv9xpQNyKtLBM9VjAmMqy6aIa5LfWT+
	 aklPEHAigu2WPtIs+WedaCtV6XN7/G+PmXqCQunyge74Ut7mnUB9h0z7ubRdGeh+si
	 OjzOo5byGKtDrszecpyPDotBRU79ONxVzx7SbaVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/444] nvme-tcp: log TLS handshake failures at error level
Date: Mon, 18 Aug 2025 14:41:41 +0200
Message-ID: <20250818124451.767171654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 25e486e6e805..83a6b18b01ad 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1777,9 +1777,14 @@ static int nvme_tcp_start_tls(struct nvme_ctrl *nctrl,
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



