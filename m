Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99059433AE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5zT8qsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B395C433C7;
	Wed, 15 Nov 2023 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077090;
	bh=1libU7SG4Tz28OFmqmPtt0ZAAIHyLF4e+Z3URz5VuaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5zT8qsyZCItdMQh7Tk9xCRYe66qFlC7Det1F8D8XpLW3QrU4qe6UcbJpRNxgylja
	 +0oVuJGp8EsAlvxCCYX6CLbwDx4m8FO1Fok/XQcFaGm9zY86YEw1r6JqL2LAdQpoa1
	 BiwXbjqHuYp+0Gst8X4CXb7pCgwFvhrZ5XRqInIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 517/550] nvme: fix error-handling for io_uring nvme-passthrough
Date: Wed, 15 Nov 2023 14:18:21 -0500
Message-ID: <20231115191636.776499266@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anuj Gupta <anuj20.g@samsung.com>

[ Upstream commit 1147dd0503564fa0e03489a039f9e0c748a03db4 ]

Driver may return an error before submitting the command to the device.
Ensure that such error is propagated up.

Fixes: 456cba386e94 ("nvme: wire-up uring-cmd support for io-passthru on char-device.")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 09a223642bc12..c4995d92882b8 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -511,10 +511,13 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	req->bio = pdu->bio;
-	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
 		pdu->nvme_status = -EINTR;
-	else
+	} else {
 		pdu->nvme_status = nvme_req(req)->status;
+		if (!pdu->nvme_status)
+			pdu->nvme_status = blk_status_to_errno(err);
+	}
 	pdu->u.result = le64_to_cpu(nvme_req(req)->result.u64);
 
 	/*
-- 
2.42.0



