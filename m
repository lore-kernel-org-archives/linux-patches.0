Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE51A3CB56A;
	Wed, 30 Sep 2026 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795971; cv=none; b=TRmE5wJMJCkIZSiFOUaM/5ehXc9QmqVP643rZUj9u/f1hiMlILwjfn2APfTT5J9ZwsW/5vbLGfk0dT3nOhPHP28bR5CkC/F9w+Z2g0XRDw0z04BmXbGW36wQBBmX07oRK4CuBOlzG8+McEz/QfjyRQzhaIVH+om8+DqEFU5vMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795971; c=relaxed/simple;
	bh=mzjfTVBu0G9gjfJhV1BKg00TlJtiW57FWugfsikw1aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGsJwmAmBd8qfWWhFMrUfSSpJXm9BgOEAah0BHYb6A2xvPqfT8d7X4cpWSvldyifyIs74SQvzb0WyCEmAvMSNLLyU+/t46jhKeL2CBG6Oh8RqvbptaiDRtB/eFNkEF7coIDNf9Ny/lQ9dkyQLrEjGwfSoexVC9ra4IpXVUVvFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RadDAFAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RadDAFAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AD01F000FF;
	Wed, 30 Sep 2026 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795969;
	bh=atL4tjGR5n8rv7VjBPGy3ZVv9ROAx8isdPL3609uAKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RadDAFAFUi3LNjwpZLeQVa22b1v7u3BAAMYD1+B+HM2wX7jxfse3vQ2nbt+8xyNJc
	 Sk+sQNVkj8jndWdyJn42CJS/mJVfoe7IxpPAC/guWb+xQXuHdxQHGJnXI1DSg/HsXU
	 zPAroMAIbvcr84H6kiZeXb6H4BtuwUgGfTs79phQ=
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
Subject: [PATCH 6.6 0747/1193] soundwire: cadence_master: wait and cancel cdns->work before clock stop
Date: Wed, 30 Sep 2026 17:23:51 +0200
Message-ID: <20260930152450.847414672@linuxfoundation.org>
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
index fdbd5d477a68e..6823666162475 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1659,6 +1659,13 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
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



