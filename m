Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473628BA96;
	Tue, 22 Jul 2025 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192922; cv=none; b=UqxEZbwQHZ9JcTt6AYyN1g/46M0nNUczffN13rP4IxhoW5E+yW6sxgVLCf+tzRVnXCjDj6saM4JOoWtGWlp4nPRsdxFmN+MAap3sGJISCI2mJknjF6N0uci57KH1RpVAi5Na2hoFo78SHNYnOYK/s2kg9dXaoAzLIlMKZc7+E7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192922; c=relaxed/simple;
	bh=J3veklS9bmffwOFW+OMN4VSJrqwlDh3Bta2Nt1Z8h5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqiFZ5fu0EowYfHJvmSyv9C07tp8qwCnSRStg03kZFR/v2iDNh4eHIwACWAhNXKchNzca3oIV8Ww2GyEvi+IMgubvRZiOD9eZPKS1D5838R5eTv6zWK0+Wx81flTbjH/JkpJo1MjxVXeYNJnFLY3ljY8/4xSAD/agQ54sPM8Q98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQX8tMep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQX8tMep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2464AC4CEEB;
	Tue, 22 Jul 2025 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192922;
	bh=J3veklS9bmffwOFW+OMN4VSJrqwlDh3Bta2Nt1Z8h5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQX8tMepklYb4W0TePmI/gIvuRIm50/MpA4ymv8B40MuEhw9V6dBuF2ObxKvVe67Y
	 /fSs+CP0ISlsm+KXEOnqK4lJpa8UwgeirkJxf9f7UjUjzoBVpVuPWZs5E/Lc5C/XN4
	 wzj3oKabCh40hQkCz2Eou+snGPYvt2WaQG0jOmuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Alan Adamson <alan.adamson@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/158] nvme: fix endianness of command word prints in nvme_log_err_passthru()
Date: Tue, 22 Jul 2025 15:44:41 +0200
Message-ID: <20250722134344.375355172@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit dd8e34afd6709cb2f9c0e63340f567e6c066ed8e ]

The command word members of struct nvme_common_command are __le32 type,
so use helper le32_to_cpu() to read them properly.

Fixes: 9f079dda1433 ("nvme: allow passthru cmd error logging")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2ca14f2b7a0b1..947488bf43144 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -375,12 +375,12 @@ static void nvme_log_err_passthru(struct request *req)
 		nr->status & NVME_SC_MASK,	/* Status Code */
 		nr->status & NVME_STATUS_MORE ? "MORE " : "",
 		nr->status & NVME_STATUS_DNR  ? "DNR "  : "",
-		nr->cmd->common.cdw10,
-		nr->cmd->common.cdw11,
-		nr->cmd->common.cdw12,
-		nr->cmd->common.cdw13,
-		nr->cmd->common.cdw14,
-		nr->cmd->common.cdw15);
+		le32_to_cpu(nr->cmd->common.cdw10),
+		le32_to_cpu(nr->cmd->common.cdw11),
+		le32_to_cpu(nr->cmd->common.cdw12),
+		le32_to_cpu(nr->cmd->common.cdw13),
+		le32_to_cpu(nr->cmd->common.cdw14),
+		le32_to_cpu(nr->cmd->common.cdw15));
 }
 
 enum nvme_disposition {
-- 
2.39.5



