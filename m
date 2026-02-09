Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD43033D2;
	Mon,  9 Feb 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648931; cv=none; b=BMRgwh2uas6RgblhnEsip0k5im4go2sg6nwvtSQuVmz16jc3YUI+iaoem9hSs2BW09aDi8iomc2WZtweZuDYgR+T007JBpctrN8C2EGiGB1pQnsXfIlTb5bPgoDDB6gp8nWIMKHokFVyIEt73OE/JP39k5dOgM6TuGT0kVei6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648931; c=relaxed/simple;
	bh=ErxkjptpVbJYG9CPrZIya3cbs9giXLJJ9HXp+sS8Fw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM67yRaD7Ao9VsTZ9/z/gdAqmYJ+BxSwAfDAH1lziAgJEYceK/ys3jXwvXSTz1XBZK+z1gmWHXiiSPDNjVnSeEx8pjv+j4y8lDUN3BBjMOiiG+Dqkq2kZYs/NsN50hv/DhPp33fr+jj8l+iY96RDYgspNPw3DGF/JXGPlWypwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT/ilJ7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT/ilJ7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5694FC116C6;
	Mon,  9 Feb 2026 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648930;
	bh=ErxkjptpVbJYG9CPrZIya3cbs9giXLJJ9HXp+sS8Fw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT/ilJ7qyHNDS9L7cFt1VkxUl8lxLOXmgzKSKflqCBVYwEsbMKK810JUdx9OO36h0
	 NTS+FS3gCAqyy0N6Yh0EIEMdqensw4F80rtgSaoaWclm7wTgqx3HAEN1GV7MPtgdwC
	 q8US0fX9UyyKggXzIG2zAbbNizfxb1q+qayVrEbk=
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
Subject: [PATCH 5.15 56/75] nvmet-tcp: fix memory leak when performing a controller reset
Date: Mon,  9 Feb 2026 15:24:53 +0100
Message-ID: <20260209142303.861450978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7eb4d06f12294..bf3585652c681 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1473,7 +1473,10 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 
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



