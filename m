Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF123B71B6;
	Wed, 30 Sep 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792031; cv=none; b=QczTzl6uJ/HqKYUG8HHapbEm/4+tzcrESRt0msxWwYNNncPmz7PwnARpMAvYSMtuKj+L40hTI0HcP8rFzjHGb1r1IxMmxI3DYZqvYiS58HijnrQ+ewz9hcxArVEC0R6S5+Y+4C3KDyMaF9Ri9lVlpOU+N/sZngSwCML1tLPAmbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792031; c=relaxed/simple;
	bh=aCY+9YScB7kFVcMShTkdrxaclzCU8OXBUm9h/DtTSRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8Zrp5tEwN5nqRyB7z8gR/+Y95UWSV8jXxPw6C/kMI38F/NEGRHKnLBib1xU3q2bzXFQy9XTgOAIBJtbwf08gZVhvRN299RIstTPO4Ly/JLQgOBghk9QDafPDKE/hf/Y0d4ZYCvbdSntVLp911C48jp+mJ2MGjC800G6XlsUE8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1AgVC9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1AgVC9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0C11F000FF;
	Wed, 30 Sep 2026 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792030;
	bh=xUrpIJiBKvPTFgNrLdOgO7nFH7YaSEoHvAqhc/LU97g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1AgVC9+y5LuyH/47Q9ZcOhp8JO4kCHfnqs6s0cQp6X1h+vDIcm0yIvhbOxB2wnmC
	 ApdTEuYRUVhFmzvoW66gQvguCmeP9rFUCDIWcfeQvvwgnbJtA+NqHiDbYylVlbS7hv
	 sEWAqIWLiG13wcKWsU81ES6/R4BQ/uMFTNP0RWqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	David Lin <david.lin@intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/752] soundwire: cadence_master: wait and cancel cdns->work before clock stop
Date: Wed, 30 Sep 2026 17:25:36 +0200
Message-ID: <20260930152408.358101797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit aba7b41faeecb7692458095ce6fafc341fe0b80e ]

A peripheral event could happen during the clock stop process. We need
to wait for the event be handled before stopping the bus clock.
Otherwise, we will get the IO transfer timed out issue.

Fixes: af4cc917826f ("soundwire: cadence: mask Slave interrupt before stopping clock")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: David Lin <david.lin@intel.com>
Reviewed-by: Shuming Fan <shumingf@realtek.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260901031019.233254-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index fb37e14404ec8..e330e50e3e0ec 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1565,6 +1565,13 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
 		return 0;
 	}
 
+	/*
+	 * wait for any in-flight peripheral event handling to complete before stopping the clock.
+	 * No need to disable peripheral interrupts before canceling the work, as the peripheral
+	 * interrupts are already masked before the work is scheduled.
+	 */
+	cancel_work_sync(&cdns->work);
+
 	/*
 	 * Before entering clock stop we mask the Slave
 	 * interrupts. This helps avoid having to deal with e.g. a
-- 
2.53.0



