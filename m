Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE13A346A08;
	Sat, 12 Sep 2026 07:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197039; cv=none; b=KCxKhip8T+5zeMWMEg4lvCWLtoVqxZxXdzo6llWfXfGYABy5p3ywjOu9bfCX0Ex/au1oNOhURbb82G6flAZucMfMFreodg5sH5LKAbrsew5kwtcpfr3iQhIozrvAqb4wvNbqb/NT55FjBSfDvqD34nbPW6tw8VYUsbjA+cd4cnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197039; c=relaxed/simple;
	bh=76tQQBbYR0sZzrdIQ0H3Pk7xhYEfL9B6yjBQ3wpXbu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGuJHCdSj3NrbslyQSUbZB8xzcehQm5uhqq+11xEzMolbxjLS91won/tNzARFVCVzPJqPqzJmqBDKgwHhiwsp7ojl7Xtv/s7QzTL1wz+46tPIAkYWzkpE33itk9OZqkmX5co32kvTDe9Ezi3BeoRFkugbdQ2nyQNGjIA315QNZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTaP8+Ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTaP8+Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06C21F000FF;
	Sat, 12 Sep 2026 07:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197037;
	bh=E6errLRgXPROqO/jjXriMArHP4dVcm5iFIX25LQX3cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTaP8+PscK2kYA34mlcd4/IViEZmdlsXKcrmBh3fJMI0uoN8JkP2F8daKxpaljQcB
	 dI2uS/0yZYyxxGsUr9gHUf/DA5ueoHdxqNhu5Zw3jfwVjQHk2/ukQFFC+HZRfBTG6v
	 W7knRHgrH0eWcq5YXCzpcGP0r+wTo3yEU7OrUXGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0086/1815] ASoC: rt700-sdw: always drain jack work on remove
Date: Sat, 12 Sep 2026 08:30:36 +0200
Message-ID: <20260912065651.026478143@linuxfoundation.org>
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
index a451d5d1f8ab5..bb449f08e30cf 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -458,10 +458,8 @@ static void rt700_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt700_priv *rt700 = dev_get_drvdata(&slave->dev);
 
-	if (rt700->hw_init) {
-		cancel_delayed_work_sync(&rt700->jack_detect_work);
-		cancel_delayed_work_sync(&rt700->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt700->jack_detect_work);
+	cancel_delayed_work_sync(&rt700->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 }
-- 
2.53.0



