Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1A24E4C6;
	Tue, 11 Nov 2025 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823116; cv=none; b=DrfditQo/29lDK3kw2BkIM3LaYNUTy2xBQMqarzsGuApOf3h2Xe0hFcsNKJ3iKJHLAfU8CXi4aO4vb74loytlo0tm/X40lPCpsZUltRH+REuevGxg1QyXML+1F96MM2Q+QgkG7lO1Ac8TZfTr10sUzLYHcQ2/bFNgFbved8Xe/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823116; c=relaxed/simple;
	bh=Kl2BoAigreeED37y1R3N3sJ+TBcUZO0bywx0/y16jeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni8fELnis+2YBX1VQnPnYNakjjOoNoJgaHaSpVU5JvbhRxSYpTGQaU9ifTDXcj8rv8jd7jeaaUAeH99wzPXTqoAQCe/F8+AVHLobuqVnu3rguyvTd6HVFz4PmXacGNnuHzuxfbV9Iv4axIDfHpULqFLmFN/t01IBoz8XuHAcFkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycxDG7SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycxDG7SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F08BC19425;
	Tue, 11 Nov 2025 01:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823115;
	bh=Kl2BoAigreeED37y1R3N3sJ+TBcUZO0bywx0/y16jeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycxDG7SHweTaGyU4DNtrRbIyqratQnFFyFLHuJwgqeDzMrPXlDCgl/tOUYKCFYIfd
	 2f+R6z25N+ggHWN2LjzmQQEpXh4V5MXpgXzTHc0cV4mvVXnF+A0ERC/3MYyr7WiQv+
	 KZtiuGMLkU2U3bpI4lkp1W+9EKjGiWjcJWSAWiS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 207/849] nvme: Use non zero KATO for persistent discovery connections
Date: Tue, 11 Nov 2025 09:36:17 +0900
Message-ID: <20251111004541.446168391@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 2e482655019ab6fcfe8865b62432c6d03f0b5f80 ]

The NVMe Base Specification 2.1 states that:

"""
A host requests an explicit persistent connection ... by specifying a
non-zero Keep Alive Timer value in the Connect command.
"""

As such if we are starting a persistent connection to a discovery
controller and the KATO is currently 0 we need to update KATO to a non
zero value to avoid continuous timeouts on the target.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6b7493934535a..5714d49932822 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4990,8 +4990,14 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	 * checking that they started once before, hence are reconnecting back.
 	 */
 	if (test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
-	    nvme_discovery_ctrl(ctrl))
+	    nvme_discovery_ctrl(ctrl)) {
+		if (!ctrl->kato) {
+			nvme_stop_keep_alive(ctrl);
+			ctrl->kato = NVME_DEFAULT_KATO;
+			nvme_start_keep_alive(ctrl);
+		}
 		nvme_change_uevent(ctrl, "NVME_EVENT=rediscover");
+	}
 
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
-- 
2.51.0



