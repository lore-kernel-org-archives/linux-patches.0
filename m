Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB1F34F49F;
	Fri, 21 Nov 2025 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732482; cv=none; b=fDK/US0xAba8PvH6odEkXnyW67dvREqUDKyR+Psrvj3B5ApniWY3DiMeu6uR/LsguuTQggimiK/3qd48Wj+3xI/OhTLGtAydlJvmzUXPXjJrB5ZiDQx/D/mD6EuFqAm50pC37u06WA99tb20UwDZaHD2XVMcvafN/PuH2AMUzIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732482; c=relaxed/simple;
	bh=EngShWTY37RBXXqpDFO9go7NSKfxWJIF8LkGAsC9Ipk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgAgT4X94cADRbu/PQn5KegEYS0T3bb2eT9iJYZcVdaNkpcMYc/l49nm5OBOqO86xYhhhacLO656uguUlzF4L0t1Lc3YZbFVQ8ZeMWladlg9qzZ8/wb30snF/4tV+PmH8TQmMZN2N8jMjLxMNOfJf3mi9dYy/KqYl96kV9fmmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5DMWDSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5DMWDSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D897C4CEF1;
	Fri, 21 Nov 2025 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732482;
	bh=EngShWTY37RBXXqpDFO9go7NSKfxWJIF8LkGAsC9Ipk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5DMWDSydJgjSle3gr15BnfLxviPjgO07AlaGVQNrPMaSrC8gUJDKp2oKtFXba6in
	 Aq6GgcFHZtYWW3CwEeANXTgkWnsypQds7FPevnhCy9D8XxxIgyfo9Y0qpF9Cl2j0xw
	 VgMvGdfShaNtdGjRYfkH6XfxOVDKVLceMnCseZZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/529] nvme: Use non zero KATO for persistent discovery connections
Date: Fri, 21 Nov 2025 14:06:42 +0100
Message-ID: <20251121130234.689042782@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13221cc0d17d4..78d00e25a1790 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4414,8 +4414,14 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
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



