Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943E361DA6;
	Sat, 12 Sep 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228901; cv=none; b=XTYf/8zh/g+IkxU+mco7u6beRVbl2fK4PmH9JPZwQptDmODm6FMWiu8Gj8zvsaUuy7iyzvMm/IwGboKtgm63F/OwofMd0B/9kZUwBpLW6kxrLtGBOtvgHOl87cvTRVl/1NCIddogN4u61NLbJ/Sevu33q6O4uY2CTnJCConEsVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228901; c=relaxed/simple;
	bh=rrlIQhe8JGvO/hhPQYWXtmRxg64GT+cZvjVTzAPICIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owc3FaE6vDf+FR6KXtjzJVr8XZjpsNexQAWnaSm+hsWly0MMsESCOZjQPuqGDfDBgN+Qxm1uKz9VosQlmy0Y9i2QnniZRMQOtRDh1eY6qbDco0LcpcuB6tprM2JOtjKpi/gpirGMmMyIbNXY/+Vm7AuUIBGAuL+ckb7WJyDzgUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USaExa7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USaExa7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB781F000FF;
	Sat, 12 Sep 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228900;
	bh=bli/XJLLfx03Ar/fjKQrXB8kbucqHL6p6pVP1jhsHlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USaExa7FZNzIZjRVMHYtsajLKTEZfgYZZqpHQZ6TNrZIPv6VSyGFWOnltsESszvvA
	 GGF0ih1GAtJnv22LlPCF6E8H7IniMg0JnGB72WKrU8TxSV75uwIpLnwb22AovKplxp
	 bGDIRjr+sdm7vVmv5oiSUXqCXsyZg0bv1tmRaMQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0481/1191] ASoC: rt700-sdw: always drain jack work on remove
Date: Sat, 12 Sep 2026 08:53:29 +0200
Message-ID: <20260912065559.036976107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 612ccf42acd14bb2685fa60c3495ca13e63e8989 ]

rt700_sdw_remove() drains jack_detect_work and jack_btn_check_work only
when rt700->hw_init is true. That state bit is cleared by
rt700_update_status() when the SoundWire slave becomes UNATTACHED, but a
jack work item can already have been queued by rt700_interrupt_callback()
or rt700_jack_init() while the device was initialized.

Do not use hw_init as the remove-time guard for draining these work
objects. The delayed works are initialized during rt700_init(), so remove
can cancel them unconditionally and pair the object lifetime with the
codec-private data lifetime instead of a mutable hardware state bit.

This issue was found by our static analysis tool and then confirmed by
manual review of the SoundWire status, interrupt and remove paths. The
remove path should drain work based on whether the work object exists, not
on a runtime hardware state bit that can change after the work was queued.

A QEMU PoC queued jack_detect_work, simulated SDW_SLAVE_UNATTACHED, and
then entered remove. DEBUG_OBJECTS reported an active timer/work object
associated with the rt700 jack work path after remove skipped the cancel.

This is sent as an RFC because the practical trigger depends on SoundWire
core remove ordering after an UNATTACHED status update. If remove cannot
run after hw_init has been cleared while jack work is still pending, this
is a defensive lifecycle cleanup rather than a reachable race on current
systems.

Fixes: 737ee8bdf682 ("ASoC: rt700-sdw: use cancel_work_sync() in .remove as well as .suspend")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260619122325.2504287-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt700-sdw.c b/sound/soc/codecs/rt700-sdw.c
index 96fc5f36d0d05..07de03ad92d43 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -464,10 +464,8 @@ static int rt700_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt700_priv *rt700 = dev_get_drvdata(&slave->dev);
 
-	if (rt700->hw_init) {
-		cancel_delayed_work_sync(&rt700->jack_detect_work);
-		cancel_delayed_work_sync(&rt700->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt700->jack_detect_work);
+	cancel_delayed_work_sync(&rt700->jack_btn_check_work);
 
 	if (rt700->first_hw_init)
 		pm_runtime_disable(&slave->dev);
-- 
2.53.0



