Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE3E19DF44;
	Tue, 10 Sep 2024 10:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962684; cv=none; b=gCpEErPqEGynEvkQr6st+6RNE4URblLaHyEE7aTeInb0c93RpGcqZ/8mZebE1eR7yzltc5l7ErkhGKzWU5R+Q5Ar30Bd0if4cClLERC0QW6HXpdK+SEJKkZZScaafzHYMpbbMnaSwWPR/ak6S297t2cmO0CJwI27u2fWCecfiL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962684; c=relaxed/simple;
	bh=fNu5J9oT4NvD8TH9s+8Z1s7xu+k73yEO9Osbk9+NnhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaeOo/mF5NeJb9nesPyYQvOSj5jLi5J0piqQpCHnH4XOQ67ajKwzpqlJUDfDnhT6xZGPqXo1qiwk4a6rzYPG+j3nCtQI77iRwknkxU2iz1FvmNXnaik4jiPd9vY6qpojRgsq1JvENiXnaILL3nGb5Yh5WCTjNN0QpHr2T9JnHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQNzAgpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQNzAgpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FADC4CEC3;
	Tue, 10 Sep 2024 10:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962684;
	bh=fNu5J9oT4NvD8TH9s+8Z1s7xu+k73yEO9Osbk9+NnhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQNzAgpLY9IKMQkX8pi0ZEDusycdga4Vut0LpZNcFiLSda7muSKlQEUHuV5pqI+LD
	 +bgDA7/dZj2Gx5poIJlrI3d/DoW7pKaLpwb1sOTnzeQ2YB3UAs8kQHlNgnGX0ReABI
	 o5rVSKKdHblInGdTyDz6alHagPRuOCF/5gz7do44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/121] nvmet-tcp: fix kernel crash if commands allocation fails
Date: Tue, 10 Sep 2024 11:33:11 +0200
Message-ID: <20240910092551.307928586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 5572a55a6f830ee3f3a994b6b962a5c327d28cb3 ]

If the commands allocation fails in nvmet_tcp_alloc_cmds()
the kernel crashes in nvmet_tcp_release_queue_work() because of
a NULL pointer dereference.

  nvmet: failed to install queue 0 cntlid 1 ret 6
  Unable to handle kernel NULL pointer dereference at
         virtual address 0000000000000008

Fix the bug by setting queue->nr_cmds to zero in case
nvmet_tcp_alloc_cmd() fails.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index fa6e7fbf356e..11c8506e04ca 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1751,8 +1751,10 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq *sq)
 	}
 
 	queue->nr_cmds = sq->size * 2;
-	if (nvmet_tcp_alloc_cmds(queue))
+	if (nvmet_tcp_alloc_cmds(queue)) {
+		queue->nr_cmds = 0;
 		return NVME_SC_INTERNAL;
+	}
 	return 0;
 }
 
-- 
2.43.0



