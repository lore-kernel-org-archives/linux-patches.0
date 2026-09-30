Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5C53A6B7F;
	Wed, 30 Sep 2026 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794613; cv=none; b=Oi8ghJ3rp/AiDi1RTeCEmnjsAtFbbAvXXI3zSffX4EIOMjLoIK5yjshO7JSp97b+5ju3o+VD4cVdSORxawKvWogJBUU1TuBbOum/9+75Ua5KeZvf2tBsx1B/yn/awsQqXVCpnyYaS44eOzUDHsfOH/3o77QHDmxLpXfqes5zm0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794613; c=relaxed/simple;
	bh=xMF074R28TufsG3ldTxtKwF7Yzo8gnTHb3wzKafSJwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJxP0zvJHOTwVSd3TzLKuuPUQPpHlxAf7/X40Zr3J9hIQDEpeZOFi1LT6hK7ChhL7eUGgn/Zv6EgVxREyPgMbGxqxYqv8VsEtfrGqLZ6TMu+lVBom2GhyTwLWrLaV6oI1mciuY1XKSGozzLoNTjdrM8anlyBNY4BWh/qERQPRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiSaNCxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiSaNCxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C9F1F000FF;
	Wed, 30 Sep 2026 18:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794611;
	bh=M+jRM/ob4iGOFhkkuK3J+wuApTCyJUNEhqED3PJZ0gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiSaNCxhU6juehNqMg8ZFAz6cHjzo8Dk6Xf3gfenuWKj0UyI7os5BVskjH40+wjJB
	 WyhW5ilE19KuB/d8ycCyn4RVPdnp6sjKm08EgNvZvORFeYKtx2RSsvzPkanJ/Ifqwn
	 29LPvXHArVw6zvNJx4vBkZxOlAYF1ILg9QIhczks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0270/1193] spi: core: Abort active target transfer on controller suspend
Date: Wed, 30 Sep 2026 17:15:54 +0200
Message-ID: <20260930152440.167234982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit c1bab046d4786c5b17aab7c5225bf0d4a2a2d19b ]

When an SPI controller operating in target mode has a transfer in
progress at the time of system suspend, the suspend path proceeds
without aborting the ongoing transfer. This can leave the hardware in
an inconsistent state, potentially causing the system to hang or fail
to resume cleanly.

Fix this by invoking the controller's target_abort callback from
spi_controller_suspend() when the controller is in target mode and the
callback is registered. This ensures any active target transfer is
cleanly terminated before the controller is suspended.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Link: https://patch.msgid.link/20260625-abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 0b9cdd966c0a1..79e68b97dfecd 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3376,6 +3376,9 @@ int spi_controller_suspend(struct spi_controller *ctlr)
 {
 	int ret = 0;
 
+	if (ctlr->cur_msg && spi_controller_is_target(ctlr) && ctlr->target_abort)
+		ctlr->target_abort(ctlr);
+
 	/* Basically no-ops for non-queued controllers */
 	if (ctlr->queued) {
 		ret = spi_stop_queue(ctlr);
-- 
2.53.0



