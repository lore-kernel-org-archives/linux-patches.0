Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF718DF67;
	Tue, 10 Sep 2024 10:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965269; cv=none; b=LCFDz6mTkU5ThtJs/JfldnTgPxQ8VWFQ6mGGsoZuGFPQFrWhkEy3DiCX95XlZbp1v7PdU7/4usAdQ5jeTPtM39KIvq5GIsMmgjKjVAtWBX06VrU5+0TfWdSgc3iSBQy57AQ3ZSigBLkZs2qYmJhoM1os2BO2UK+eTz1VUxnydXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965269; c=relaxed/simple;
	bh=mMAPMl6eJslHDD08TFZKEAkaaaWbnXxDXNaz/EU/LM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6TjwvtjcABbjWn76xhkiY1dNu55QHWb/gpICGHYSpUGsreQPfK8GkEFOOVnMnqfDeVYDmFzxqNjyK9fz3uhZJElk1VMXcb4f2yMi58s2+cujce5j8NrOBEyat1LMuVhsR8f/QyGc0ZqNB5WB8Nqv8orQaNiaucxpoiGp/LXj1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaOWYAa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaOWYAa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1DFC4CEC3;
	Tue, 10 Sep 2024 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965269;
	bh=mMAPMl6eJslHDD08TFZKEAkaaaWbnXxDXNaz/EU/LM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaOWYAa10yOJi6jD/xUOTQbxX/aiaqzHvN8EaYeL4nYtWs8lqJEHIo/IUkPjc5z+v
	 /PPOxveVGLVRnTF2YWY1mXGS/MA/JzQk4rk3RIEzzuMZcI3MGxlya72BeV06nkWS30
	 rzMH1A2jZmfkzaEjxRvIrhFtZy+h5Z9kRnFh1esQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/186] nvmet-tcp: fix kernel crash if commands allocation fails
Date: Tue, 10 Sep 2024 11:34:34 +0200
Message-ID: <20240910092601.992469441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e493fc709065..5655f6d81cc0 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1787,8 +1787,10 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq *sq)
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



