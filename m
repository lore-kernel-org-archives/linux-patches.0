Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAC510973
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAB3C433C0;
	Mon, 26 Jun 2023 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804906;
	bh=OgHqwIY8rGq/HHn1hD0yYLlYuhNWRn90S1CNL2qy43w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09zZEsvVsztSllJHYaqVkxNhCk9+XNYrSgmQ1Ahh9Y2x/6ZUFlbB6U/7EDzYJdKbE
	 nN3MBQsYyk5pJ5rTKFmoYBfyzfofvtGiqDcJEabJJPrWeB7DEZdBhoNOrFzPwlJGi5
	 GynuspvdKtng0MLKfx9zjkkrJEjnXiL/ec2ESccI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Costa Sapuntzakis <costa@purestorage.com>,
	Randy Jennings <randyj@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 82/96] nvme: double KA polling frequency to avoid KATO with TBKAS on
Date: Mon, 26 Jun 2023 20:12:37 +0200
Message-ID: <20230626180750.432609671@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit ea4d453b9ec9ea279c39744cd0ecb47ef48ede35 ]

With TBKAS on, the completion of one command can defer sending a
keep alive for up to twice the delay between successive runs of
nvme_keep_alive_work. The current delay of KATO / 2 thus makes it
possible for one command to defer sending a keep alive for up to
KATO, which can result in the controller detecting a KATO. The following
trace demonstrates the issue, taking KATO = 8 for simplicity:

1. t = 0: run nvme_keep_alive_work, no keep-alive sent
2. t = ε: I/O completion seen, set comp_seen = true
3. t = 4: run nvme_keep_alive_work, see comp_seen == true,
          skip sending keep-alive, set comp_seen = false
4. t = 8: run nvme_keep_alive_work, see comp_seen == false,
          send a keep-alive command.

Here, there is a delay of 8 - ε between receiving a command completion
and sending the next command. With ε small, the controller is likely to
detect a keep alive timeout.

Fix this by running nvme_keep_alive_work with a delay of KATO / 4
whenever TBKAS is on. Going through the above trace now gives us a
worst-case delay of 4 - ε, which is in line with the recommendation of
sending a command every KATO / 2 in the NVMe specification.

Reported-by: Costa Sapuntzakis <costa@purestorage.com>
Reported-by: Randy Jennings <randyj@purestorage.com>
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e5318b38c6624..98a7649a0f061 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1247,9 +1247,25 @@ EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
  *   The host should send Keep Alive commands at half of the Keep Alive Timeout
  *   accounting for transport roundtrip times [..].
  */
+static unsigned long nvme_keep_alive_work_period(struct nvme_ctrl *ctrl)
+{
+	unsigned long delay = ctrl->kato * HZ / 2;
+
+	/*
+	 * When using Traffic Based Keep Alive, we need to run
+	 * nvme_keep_alive_work at twice the normal frequency, as one
+	 * command completion can postpone sending a keep alive command
+	 * by up to twice the delay between runs.
+	 */
+	if (ctrl->ctratt & NVME_CTRL_ATTR_TBKAS)
+		delay /= 2;
+	return delay;
+}
+
 static void nvme_queue_keep_alive_work(struct nvme_ctrl *ctrl)
 {
-	queue_delayed_work(nvme_wq, &ctrl->ka_work, ctrl->kato * HZ / 2);
+	queue_delayed_work(nvme_wq, &ctrl->ka_work,
+			   nvme_keep_alive_work_period(ctrl));
 }
 
 static void nvme_keep_alive_end_io(struct request *rq, blk_status_t status)
-- 
2.39.2



