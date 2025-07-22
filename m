Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884952EE99D;
	Tue, 22 Jul 2025 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193516; cv=none; b=h30h3ZP5GNLy5DAK5eQwDmnQRaybCVS+XLq/JAhDJ1iOPzTw/HiSXhkNTPB3tHYKFG+WN5CmBaV8NIGBAHo+RS6s1psQG+kUMh6WG89kAn6oetNbXPJrx4D+Ib1rrdWf7Gb+KGnPofdt4K4pXC4PKOsc1woXx/mhwyYwT9U4JWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193516; c=relaxed/simple;
	bh=HB/JB6F67PfbvuV1UClOZhB3xU+/fiRQ4DvmoZZyDlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIhx5i3dEE6KEEnDS724rorY3fMVx0bW4bshJP8EQ8GPYRFBp8km3dme9Vl7cLqgkAxshLKUWd7M9jc6zhz0bVYYWRf5az+7qVARB0OCK4+SCrIVSZFEen5rYhlMJGXSKDZXh+TahHx081Kk/ndK3ro88UlEBxm870jGLxBprp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWBUkJRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWBUkJRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1131FC4CEEB;
	Tue, 22 Jul 2025 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193516;
	bh=HB/JB6F67PfbvuV1UClOZhB3xU+/fiRQ4DvmoZZyDlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWBUkJRs0oPslGUETW88E+/pJEESrA3DyNKf3VEA9ut4V+NIDLsfUIi0U5DF7BwSC
	 1YfQxQiqVE48bCJXgjGHoEA3wsMQNzriMzoqKcExD8ck8IiU9FDGFOKKogH2i7+lEZ
	 vSOEyaBFshhxivppW7UOlE8aW7O6AIpnv7fsUhoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Alan Adamson <alan.adamson@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 117/187] nvme: fix endianness of command word prints in nvme_log_err_passthru()
Date: Tue, 22 Jul 2025 15:44:47 +0200
Message-ID: <20250722134350.116194602@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 300e33e4742a5..8ba56017f917e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -377,12 +377,12 @@ static void nvme_log_err_passthru(struct request *req)
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



