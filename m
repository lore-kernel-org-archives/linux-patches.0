Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022076;
	b=Lf4ZYmfYTmUoRrSeGRqR1djb0jAnzJppmJpzmZymfEU0sckuId20o7rticXiV7dYYhOZ
	 YXZa1xkQBP/U08qsvju9ZzcThC2ccaChsXTUxwafI2p+ovW/2iQ/I9ZXEUeglIPf4png5
	 RyGH5iZAHpidH6di6UjFhquJD2s1EpVqFaK0TEvwECO4Z5dOFmobcu23n6GoqJwyetI67
	 M6AswNDve8nyo9hMoDdfQnoboLgxPHR3sKTmVvJd2ppYzEK0D/JA7LcDF5fdodKBjnjKy
	 j/yw99y99NrFOPE3kWg8aQ6L6wtJxk5KDPTP2eqwXmRAYm/090Hgl6j/KC9j+/6zC6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YK9WAdRX4Z7HXSMoAGnO5B7wId2Koi0aN0c0HG3TNes=;
	b=lmLOCFmvYQA50IBI0u5AjldXkQA/lp7NRBexs3M3mE6WpGk5cPdZmx+eUF+PYRq9D+hK
	 gQd8HFEu4Zsi3bhGGuic2R+4Dpybf9SOBI9U3q21iKj9ydUlw5Q7jdMhFWdtaIRJO0+fF
	 SqlqXqAgAztaeg1ItNq1IC+qns470TV9gL49t1Y9+G/cIo0s1zKdFh+PgbW1QCxBecF79
	 aFQoVGfcUf9XMmKJ7hIBWIUj+kl1WP7Cpzwmo+R2qt3pxwI30vFg87IX75cLz05A2++J7
	 Pw63yJvtf06OGr+m2IdGwYvtEkxz/Y4eWgRnslE+Jw8Z4G/7d6OY9BbTuSuS1No7kpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sz9s4zcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A0D606A32A;
	Wed, 18 Nov 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sz9s4zcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B984D1F000C4;
	Wed, 18 Nov 2026 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022076;
	bh=YK9WAdRX4Z7HXSMoAGnO5B7wId2Koi0aN0c0HG3TNes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz9s4zcPyDNeqiOfBZct/nW5Ty1gRt+soZoWYOB7ghgBg6wfvzzhpmozOXJ4e1BfM
	 IfFvYcj/DJ2xuh4HYeFmjWzmBOwSZnZsz8v7OKeGN99RwalQjxlVRWFDlRMDDF6RWo
	 O97C6iY4MMPBBu8SFbSVs4kugv3/BaKYXHYAZJzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2531/2651] nvme-tcp: refactor I/O queue setup path
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150415.738206531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surabhi Gogte <sgogte@purestorage.com>

[ Upstream commit c58465c1e3d6f6fa720c922781cad4330a573cfb ]

Split the I/O queue setup helpers apart so that the individual steps can
be called directly from nvme_tcp_configure_io_queues():

- Queue count negotiation moves out of nvme_tcp_alloc_io_queues() into a
  new nvme_tcp_set_io_queue_count(), leaving the allocator with just the
  per-queue allocation loop.
- TLS PSK validation moves out of __nvme_tcp_alloc_io_queues() into a
  new nvme_tcp_tls_check_psk().
- nvme_tcp_configure_io_queues() now calls the three steps directly in
  the same order as before.

Signed-off-by: Surabhi Gogte <sgogte@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 12c20e290356 ("nvme-tcp: skip TLS control records while waiting for the ICResp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index edb41cb3a7a15..6204943ea404c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2335,10 +2335,8 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
-static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_tls_check_psk(struct nvme_ctrl *ctrl)
 {
-	int i, ret;
-
 	if (nvme_tcp_tls_configured(ctrl)) {
 		if (ctrl->opts->concat) {
 			/*
@@ -2360,6 +2358,13 @@ static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 		}
 	}
 
+	return 0;
+}
+
+static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
+{
+	int i, ret;
+
 	for (i = 1; i < ctrl->queue_count; i++) {
 		ret = nvme_tcp_alloc_queue(ctrl, i,
 				ctrl->tls_pskid);
@@ -2376,7 +2381,7 @@ static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
-static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_set_io_queue_count(struct nvme_ctrl *ctrl)
 {
 	unsigned int nr_io_queues;
 	int ret;
@@ -2398,14 +2403,22 @@ static int nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 
 	nvmf_set_io_queues(ctrl->opts, nr_io_queues,
 			   to_tcp_ctrl(ctrl)->io_queues);
-	return __nvme_tcp_alloc_io_queues(ctrl);
+	return 0;
 }
 
 static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 {
 	int ret, nr_queues;
 
-	ret = nvme_tcp_alloc_io_queues(ctrl);
+	ret = nvme_tcp_set_io_queue_count(ctrl);
+	if (ret)
+		return ret;
+
+	ret = nvme_tcp_tls_check_psk(ctrl);
+	if (ret)
+		return ret;
+
+	ret = __nvme_tcp_alloc_io_queues(ctrl);
 	if (ret)
 		return ret;
 
-- 
2.53.0



