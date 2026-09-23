Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E1A51D52A;
	Wed, 23 Sep 2026 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172767; cv=none; b=pt9WjabOm7QAUPPPij3fEnjMstsTL3IVVdGqMnVferr/kX4be7OGytYXNItuJfGRinEKi1t4WW9RzU701I13fmD36M/w1HeIOdvIXFpOPexehhWyH+rIFb1I/zIE6SwR/lc5AzwrtCG5nJ4tVBLDnLgWL857/SDWU0bOhXGO3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172767; c=relaxed/simple;
	bh=YMDrY+F39CWvWKTjPL9COrOTIxubDRvag+52jeNEKxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6Yd0qj1jqicvUfKbawMhZvKQhde4A7ew8J0QOtR+0LvTAoX48Xd7QP3z3kF8Vmvgjqcu6O2d5i9oAQvGk/Wj+eaFgQrmmTgPSb/8gfew16PY0V8mNPBjOiV8hdbYZ+bdhHpc5dS9xSxw3VAgouwnnNbSXHozeF++1tjAioQQQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBXKsd8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBXKsd8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8A11F000FF;
	Wed, 23 Sep 2026 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172765;
	bh=G8zxBrEk+cCeBRx2ADuUTGI/SQI1lm288L/byBuZvu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBXKsd8e+9Kms3WUOKn+xbOG6Misj8g/cBac1Stu//O9Fyq9VDtz9dEA7BT5LS5dQ
	 KYP0VhUk9NT9AtemXziAjv0LqkOWVoSdjv1vPUEF3k+9OhELbPxp82h6NqT11P9L1b
	 71HBgPpEGZ37tC/Mjn4CVr5nd7UsmvOkyWWnEVzg=
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
Subject: [PATCH 7.2 056/438] soundwire: cadence_master: wait and cancel cdns->work before clock stop
Date: Wed, 23 Sep 2026 16:01:17 +0200
Message-ID: <20260923140646.235598127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index 98ed337fb9b01..cf456d7cf0a8f 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1701,6 +1701,13 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
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



