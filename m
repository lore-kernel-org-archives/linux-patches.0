Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F8528312F;
	Mon,  9 Feb 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648748; cv=none; b=J9ZvR3ZXs+j8SWz/3vcu3KtA398lcKi36qZ8ZI7iRg+OT8vzyqKoCDLc6nUqPFbPWzEwpKmJi2cXT0JpzaEHduNA4/NqgF7buaE8AO3mG6l5YJItkEXxfMpKvomKP9MYrG667Dr6stIWunSVjt0rmvYkJwhJ1v7bSfEOQlqwfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648748; c=relaxed/simple;
	bh=Nj4C/vLAOt1uuYPi0+84+X4EJokTWPcxVnegf+2Esfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRsfoArE45WBE+Qa4oM2mcC/+3eDDTrJbJ8DR8kyt1vN+mPqJNsvfygeNYf9BGZH7OiYnh0F4RtP5axLB9SG7D17OSiEE0yS0qUmKVM+1YbTblPEsxskNVC76L/wP/EDm4iW3KG7N+QiSqYo/cBYrDTPMVft3qrOfEfWMt+A7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ46lLPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ46lLPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEB7C116C6;
	Mon,  9 Feb 2026 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648748;
	bh=Nj4C/vLAOt1uuYPi0+84+X4EJokTWPcxVnegf+2Esfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ46lLPHNrP3vpLOCQB7FAnKnJrTT7PUGTjpuFCroArehWkJmDPaWv8ZYArvsHIzJ
	 FgAxMTOHvZiq3rsdPYyPUFYXuFOj5qLo1kd555RGcza1Eg5fk+uUtNF1eK0mPX7fws
	 2XkWJAMltSDNU0PfqUYaZdiiW0zv7Dw5kYFfKhxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Meneghini <jmeneghi@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/41] nvmet-tcp: fix memory leak when performing a controller reset
Date: Mon,  9 Feb 2026 15:24:53 +0100
Message-ID: <20260209142257.972960310@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit af21250bb503a02e705b461886321e394b300524 ]

If a reset controller is executed while the initiator
is performing some I/O the driver may leak the memory allocated
for the commands' iovec.

Make sure that nvmet_tcp_uninit_data_in_cmds() releases
all the memory.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 52a0a9854934 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 3c0769d40edd3..bf34849c15a20 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1443,7 +1443,10 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 
 	for (i = 0; i < queue->nr_cmds; i++, cmd++) {
 		if (nvmet_tcp_need_data_in(cmd))
-			nvmet_tcp_finish_cmd(cmd);
+			nvmet_req_uninit(&cmd->req);
+
+		nvmet_tcp_unmap_pdu_iovec(cmd);
+		nvmet_tcp_free_cmd_buffers(cmd);
 	}
 
 	if (!queue->nr_cmds && nvmet_tcp_need_data_in(&queue->connect)) {
-- 
2.51.0



