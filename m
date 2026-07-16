Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368C642255C;
	Thu, 16 Jul 2026 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210525; cv=none; b=nkpI+Cz73vcWojtYMyIeRBSAmMb3B7h9G/molQYsJK4TJJ1h+LsmvHCfayrqu4kEbjLe62m3o9YbnwcWnA9KSzV9EtIesB7UnfRiJSGTbo0pGEddO8sNrbzoCi4io/9d1z9VDKMYjMiC+j2a0HIC2WATMwTu6wrkplyYheXBjmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210525; c=relaxed/simple;
	bh=evrlaiMgrKHqBxlDvyGgwToRczea8U30B7C/E95ndLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAzgJHgOkmow2dqIy/DQorx67lk8lcwwuEPUTwLvw2j8D0IQoNkB046rWR2D6NPkuorBLyG/HkZSwu94yf9+vSDy6PNhCOutMdImwCIyY74zUXuAy+SAXZe/nN0o1DZVXSazYio64futirb2yut+Be8+EwXB/Ghi0WOeHDhlF28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bncz5fC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bncz5fC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823DD1F000E9;
	Thu, 16 Jul 2026 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210524;
	bh=k8JYL+7bbWj43zKaLxCOdqqNl4BbnhKZCCHCiP27we8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bncz5fC2aov4NccsUiwW10EgRDBY4+kAwUlvyH383U4Mu8OwYrJmKchjffi0vlpHU
	 NnMI69c9Nz6PUhmX/3z1tUdv67QTaROOqyNZXPXEM361229iob/+vGvs7ChrJQ8ykA
	 eyEy2jIRvK3wKidsJMUOKr/YFTmBSXmcx/i0wPME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 079/480] iio: light: opt3001: fix missing state reset on timeout
Date: Thu, 16 Jul 2026 15:27:06 +0200
Message-ID: <20260716133046.421695856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -366,8 +366,10 @@ static int opt3001_get_processed(struct
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


