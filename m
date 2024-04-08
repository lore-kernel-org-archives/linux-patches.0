Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415FB8063B;
	Mon,  8 Apr 2024 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585177; cv=none; b=YXK+ciZ6g8Rrw8GsNZ21n7zziHeX2ZxSZ6z6CTr4ysSDyKZ9yElBFnXa75c18Gwg5Enxn4VQhP1MOWZDsvxFoYJKrfr7BCh4cnqNYXq8z5JTdwJ8GJa6Tz4uY+ry17MnOSjrSJwaGZBGfM7qZabcQabpfa9Y9xVofzhncTGb2wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585177; c=relaxed/simple;
	bh=pzFZPEf0sJJqIY3Ts+EK4JrKCtea31Kjk04UH+QxUlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyPKEeTznhghboRLqrA3Oq1QMCkcBTFv7dUAImYV+vdDQ7Qmzza3wgTmb5DUJoCXTtKMfyO5dskmrYUtwJFpx2U4ttHvqKJGOQ1LZ8L5wBKcdu8F6Em2tHifMBKf+GuYoW23g+fTZp5bvZQHdpmKmerDMlpZOwvZQxJmj5IDG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfu4dW7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfu4dW7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE13C433C7;
	Mon,  8 Apr 2024 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585177;
	bh=pzFZPEf0sJJqIY3Ts+EK4JrKCtea31Kjk04UH+QxUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfu4dW7MlcJNtpjeepxYfh6p6KT9888ppx1GybZ6ifA+D1WQv/rdrgmPUr3L2COwz
	 2L5DItIpUArW3+J5kFeGUGHstj15dNhsP3ZklcGJ2LVbSK1ZK0TdeA51hnztf6q3ab
	 LGQWVUqbjbaxcrIVbhcnxTXT1r3+Z4CYI1bMWcDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"min15.li" <min15.li@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Tokunori Ikegami <ikegami.t@gmail.com>
Subject: [PATCH 5.15 690/690] nvme: fix miss command type check
Date: Mon,  8 Apr 2024 14:59:16 +0200
Message-ID: <20240408125424.719628041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: min15.li <min15.li@samsung.com>

commit 31a5978243d24d77be4bacca56c78a0fbc43b00d upstream.

In the function nvme_passthru_end(), only the value of the command
opcode is checked, without checking the command type (IO command or
Admin command). When we send a Dataset Management command (The opcode
of the Dataset Management command is the same as the Set Feature
command), kernel thinks it is a set feature command, then sets the
controller's keep alive interval, and calls nvme_keep_alive_work().

Signed-off-by: min15.li <min15.li@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Fixes: b58da2d270db ("nvme: update keep alive interval when kato is modified")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1185,7 +1185,7 @@ static u32 nvme_passthru_start(struct nv
 	return effects;
 }
 
-static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects,
+static void nvme_passthru_end(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u32 effects,
 			      struct nvme_command *cmd, int status)
 {
 	if (effects & NVME_CMD_EFFECTS_CSE_MASK) {
@@ -1201,6 +1201,8 @@ static void nvme_passthru_end(struct nvm
 		nvme_queue_scan(ctrl);
 		flush_work(&ctrl->scan_work);
 	}
+	if (ns)
+		return;
 
 	switch (cmd->common.opcode) {
 	case nvme_admin_set_features:
@@ -1235,7 +1237,7 @@ int nvme_execute_passthru_rq(struct requ
 	effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
 	ret = nvme_execute_rq(disk, rq, false);
 	if (effects) /* nothing to be done for zero cmd effects */
-		nvme_passthru_end(ctrl, effects, cmd, ret);
+		nvme_passthru_end(ctrl, ns, effects, cmd, ret);
 
 	return ret;
 }


