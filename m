Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9523BCE7;
	Mon, 13 Oct 2025 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369301; cv=none; b=OPGEU4gQ95t2uuhBazQCCGTV4n+1GmeGZrSk8gkiw0k/zaa+k1ySg5TGOIAnnihB2Nt3M/q8zKN0bhHeTFJyiDt4sA4H2Ook49CFOrEsB/7/u3NU6dBHe3U29qQRH8ZlaNZPUuRgCXXHNG3MwkfJ3z60peT3jaUY2nWXzFou754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369301; c=relaxed/simple;
	bh=G3JZc6nb7/lzCUyTPYtVcqJwd5/rrPOFl9DjNuRaxbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Alwo635ixzJaYvK4dMzuCn2vMGWjMty8Lkt14ZEqBOVbEVM6UKw5cHnZXe/JLY5WIEkNZv9AnhiHxgEzX9pJ0TjNf73hZEsEEeAR4EuYaPJFEG6+IzxIu6XLXR77niFHXRJ6PRXbuxjE3qXV92Vbix0INh97UEcMUNXFjlzsWDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeduCtMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeduCtMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3009DC116C6;
	Mon, 13 Oct 2025 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369301;
	bh=G3JZc6nb7/lzCUyTPYtVcqJwd5/rrPOFl9DjNuRaxbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeduCtMQO7ndnOJjJkTVm/FMp7wSgUAwNltuxgOb4CBOvBPLIZYJYtdxovBpzutp/
	 W54ic9JBNEDwgipnsoWu7N/FCgxJN3xkqPqhj8AlgvS+TZ+FDdgCklx9kqc4b+rWuT
	 9dESMgZGhvwGPyma0d8366ICu8vUOTi10FbRuOTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin George <marting@netapp.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 165/563] nvme-tcp: send only permitted commands for secure concat
Date: Mon, 13 Oct 2025 16:40:26 +0200
Message-ID: <20251013144417.267281157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin George <martinus.gpy@gmail.com>

[ Upstream commit df4666a4908a6d883f628f93a3e6c80981332035 ]

In addition to sending permitted commands such as connect/auth
over the initial unencrypted admin connection as part of secure
channel concatenation, the host also sends commands such as
Property Get and Identify on the same. This is a spec violation
leading to secure concat failures. Fix this by ensuring these
additional commands are avoided on this connection.

Fixes: 104d0e2f6222 ("nvme-fabrics: reset admin connection for secure concatenation")
Signed-off-by: Martin George <marting@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index c0fe8cfb7229e..1413788ca7d52 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2250,6 +2250,9 @@ static int nvme_tcp_configure_admin_queue(struct nvme_ctrl *ctrl, bool new)
 	if (error)
 		goto out_cleanup_tagset;
 
+	if (ctrl->opts->concat && !ctrl->tls_pskid)
+		return 0;
+
 	error = nvme_enable_ctrl(ctrl);
 	if (error)
 		goto out_stop_queue;
-- 
2.51.0



