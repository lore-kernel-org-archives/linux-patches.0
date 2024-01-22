Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9013D1DFEF;
	Tue, 23 Jan 2024 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014221; cv=none; b=OOj3IXBezixBO/E+cA0PHpCLWz8J5QHTgrRsdeESZMo1wSJfOiFe7sgk99tfxskygS+8gvf+GsbUcTDkyZOUeRP0ianP/SJ3JjzH9UZvAA0tx9CR6JINcl/dEg+0hQDozHySb1sQawxO+dm70mJ/NclKfdpU+odh0Eu3KZFy1Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014221; c=relaxed/simple;
	bh=8f1daPt7FWmvH/ATiZWvebzSPvqyu4VaNCysA//CCOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDFyB1e61oR9f58OTZdTrAjAjMVo3sAZXmRnJtBYZuSnXqhPMTuH+ibzMwmAk9ijh5QYqMlUuj8/Cf20NoeCvvSmTmvioH9xwGi64ds3ejABDYewtPin/cobvMiAzJdSwuJ5Q5Sfhjdk9GXVgRIBQm2tzVg4ep3XJ1jqi/iYJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aw25DT83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aw25DT83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BCAC433B2;
	Tue, 23 Jan 2024 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706014221;
	bh=8f1daPt7FWmvH/ATiZWvebzSPvqyu4VaNCysA//CCOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aw25DT83X1XoNX3Iuuvzv7FbdmO1wfJbT91ZBvvZQpxqTHo+xJSJQqr/7aXv4y/Ts
	 9pYzZTGKGOjlRqFTb5Crns5IUg7DoNCj3WNrEf6MLmyuWyJdFe0evTFvdq8C9CtVbw
	 ej2WCqR2JjWKC7dLKI82I7qhgZmM7jDd6u6D598Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 365/417] nvmet-tcp: fix a crash in nvmet_req_complete()
Date: Mon, 22 Jan 2024 15:58:53 -0800
Message-ID: <20240122235804.467988214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0849a5441358cef02586fb2d60f707c0db195628 ]

in nvmet_tcp_handle_h2c_data_pdu(), if the host sends a data_offset
different from rbytes_done, the driver ends up calling nvmet_req_complete()
passing a status error.
The problem is that at this point cmd->req is not yet initialized,
the kernel will crash after dereferencing a NULL pointer.

Fix the bug by replacing the call to nvmet_req_complete() with
nvmet_tcp_fatal_error().

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reviewed-by: Keith Busch <kbsuch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 7310f65af849..6d46143bcfe8 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -934,8 +934,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
 		/* FIXME: use path and transport errors */
-		nvmet_req_complete(&cmd->req,
-			NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+		nvmet_tcp_fatal_error(queue);
 		return -EPROTO;
 	}
 
-- 
2.43.0



