Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F821DE8AD;
	Mon,  9 Feb 2026 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647524; cv=none; b=mkdBYdB0NS5MHs9p599uv9rdtOpDmFe+yshf6IJsXdaqQpvyepGqoN/CAMxTpBVygbaOynXqOBV9ihiXp09XJ8lPMnikV4LhBph3TJcTugqcaYnc9+UyF5kgJatnHwOLz6SHubKSonQ8rmXHOYPYUor6+f6hxiXA+FekesDU9VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647524; c=relaxed/simple;
	bh=tKW9vAHtfcJ4pSXSPdmPV34xhkGR6OSBYatUmq3DAB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJVnPZxVfgKBjfwYDfb6rvRmD3cYGCIKn+Gyq3dGom7yC8u72AMILYJcltz25t+7xq43DqDTuBihn3w4W7d7Ge1H/oVgEkumKKsxyxdXbWSPKg31u1RiTL/d1eymBV6r21pzbrFXHZTxmLS1Se6tcMIMetliyeiGf4eSyXZvFGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGCU7Cj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGCU7Cj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F7FC116C6;
	Mon,  9 Feb 2026 14:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647524;
	bh=tKW9vAHtfcJ4pSXSPdmPV34xhkGR6OSBYatUmq3DAB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGCU7Cj8ksrIpwUarwQ/3pm8sDBQc9R1e6GdMdCktnyJKN4EW/k5GnNEmHNkORufK
	 ihvZHB3MokoN3GEQ3JUMeQf2TpWksewGPCEWsFGlqxXbyTY/plUMbZAjGDTBv/reDX
	 ZBjy7VGFF4NwPDT0ZeJKEABJf/kVm/F4L1lwaHXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/175] nvmet-tcp: fixup hang in nvmet_tcp_listen_data_ready()
Date: Mon,  9 Feb 2026 15:22:44 +0100
Message-ID: <20260209142323.705112155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 2fa8961d3a6a1c2395d8d560ffed2c782681bade ]

When the socket is closed while in TCP_LISTEN a callback is run to
flush all outstanding packets, which in turns calls
nvmet_tcp_listen_data_ready() with the sk_callback_lock held.
So we need to check if we are in TCP_LISTEN before attempting
to get the sk_callback_lock() to avoid a deadlock.

Link: https://lore.kernel.org/linux-nvme/CAHj4cs-zu7eVB78yUpFjVe2UqMWFkLk8p+DaS3qj+uiGCXBAoA@mail.gmail.com/
Tested-by:  Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index f0572fc0b6598..5c8d17bcc49bd 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2021,14 +2021,13 @@ static void nvmet_tcp_listen_data_ready(struct sock *sk)
 
 	trace_sk_data_ready(sk);
 
+	if (sk->sk_state != TCP_LISTEN)
+		return;
+
 	read_lock_bh(&sk->sk_callback_lock);
 	port = sk->sk_user_data;
-	if (!port)
-		goto out;
-
-	if (sk->sk_state == TCP_LISTEN)
+	if (port)
 		queue_work(nvmet_wq, &port->accept_work);
-out:
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
-- 
2.51.0



