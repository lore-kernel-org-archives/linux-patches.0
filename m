Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6116934752E;
	Sat, 12 Sep 2026 07:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199984; cv=none; b=u/7zTgpzB2SL0SrXhRFYqR0RT9hx3iJmxftgnJ0F4ZXTQE4E45XdbN9vJtxsZrZ0wMBnSsEko/iPtB5M9qJSuauwz4sAh4mbxnV7VyS3UZPQLqQXYAux7PQrMRJ7t4Fhtwta7bdFqUdpyPjXywZlXzEQFjMVddH46r+bNIPkZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199984; c=relaxed/simple;
	bh=Yv13phBWc3f5DGBKYji+MBeTTN1+glBiorjr3uABXzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYFR2JSUW1eZlio6DnpkduinR6LGwG8LaDyhfclTesLt/Qw8At//E6AaDLtA1uEtQiahmUiksQ8liWyGb/eQxh3KOOeUlw9XxAFewMDEdaGWO13bOZOHHTz2CLhwoGBr8zVrMADEp2F625oDSaTWB2HD3p67bfS4Jmfd1WytwrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctiaDcRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctiaDcRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CE1F000FF;
	Sat, 12 Sep 2026 07:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199983;
	bh=6EJtWGo/OOGDi2yg+EaK66PVOv3H3qenqJManmnaOpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctiaDcRo6IZs1XHlI0gVDEbrlh3TdP3KMFvUznIwalT2W6/5SmbSQqGs5QKbJHf2Q
	 PL2ll/3aS5UrmUuLbW8n2K4o4sZEtGytZ63R7VhtnBKxvmT/P0jxb/pYUFCa37aUWf
	 NUTw/IDHztBBRQJSiETaw9za1YRaZB344INgxjTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0698/1815] remoteproc: qcom: q6v5: Request shutdown if crash is triggered host-side
Date: Sat, 12 Sep 2026 08:40:48 +0200
Message-ID: <20260912065705.277369606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 0ea50486978f109e6d4c32267fab01ed654a2160 ]

rpmsg client drivers are allowed to invoke rproc_report_crash() on their
grandparent when they determine that the otherwise seemingly healthy
remoteproc has entered a functionally broken state.

In the crash handling path qcom_q6v5_request_stop() is invoked, which is
based on the current rproc state whether to request a graceful shutdown.

But the current rproc `state` will be RPROC_CRASHED regardless of where
the crash handler was initiated from, and empirical data shows that
unless the firmware is taking part of the shutdown the system state is
often left such that it's not possible to start the subsystem again.

Use the `running` state in the q6v5 driver to make the decision instead,
as this does represent the actual state of the firmware.

This makes it possible to reliably trigger a restart from client
drivers.

Fixes: 3cc889eb83f5 ("remoteproc: qcom: q6v5: Avoid setting smem bit in case of crash shutdown")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-q6v5-host-side-crash-v1-1-23bd53db90a7@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5.c b/drivers/remoteproc/qcom_q6v5.c
index a11d8ace554bc..241478ea29782 100644
--- a/drivers/remoteproc/qcom_q6v5.c
+++ b/drivers/remoteproc/qcom_q6v5.c
@@ -197,13 +197,13 @@ static irqreturn_t q6v5_stop_interrupt(int irq, void *data)
  */
 int qcom_q6v5_request_stop(struct qcom_q6v5 *q6v5, struct qcom_sysmon *sysmon)
 {
+	bool was_running = q6v5->running;
 	int ret;
 
 	q6v5->running = false;
 
-	/* Don't perform SMP2P dance if remote isn't running */
-	if ((q6v5->rproc->state != RPROC_RUNNING && q6v5->rproc->state != RPROC_ATTACHED) ||
-	    qcom_sysmon_shutdown_acked(sysmon))
+	/* A watchdog/fatal IRQ clears running; logical crashes still need a stop. */
+	if (!was_running || qcom_sysmon_shutdown_acked(sysmon))
 		return 0;
 
 	qcom_smem_state_update_bits(q6v5->state,
-- 
2.53.0



