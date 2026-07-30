Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44D399350;
	Thu, 30 Jul 2026 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424289; cv=none; b=kixhIvnSvOY/luNTY7yuburBiauwB9XxzVdvNOCuQCpaaRdAZfOm7bet19MO6W7D1HVxWmo2lN5ciwIQg/dp+B1Yjzl+q47/ZIKHSHivnrIKuG3QC/zU9IZpFuAOF+bx+6D4pp3a2/ZHT8nX3BUOXD9WeYMBtwNvsSaXIgRsAXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424289; c=relaxed/simple;
	bh=x3ZV8hsz+apEhGxhck8ty8qAXBUbyrWWjDO/skX7/nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK7OwqOzeI/Q+brBQVsIO3qFvXVArOGs+QPIAkT/ImH3Lz8Ne/6gXuQy5UJ0v7GD/0a2vIvYu5dgN5zyP00g7s2SdgN20mUmmrBfdtZbbKkymn/CIF8jrQCBMhlfwwuKiHnweM2oSHGHqCVtBVBmGUuU9WLBy2FpmEaz1vvyck8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WExgN4nV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WExgN4nV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161A71F000E9;
	Thu, 30 Jul 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424287;
	bh=dBHDDlC8q45kZt+gDV6H4J/JBByYuOeuEmqxjrsKLNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WExgN4nVG733Ut2iVBr+s4rbQt9zl9U4VZxsJDFqi0h3RUv1IoBYAL8wSd/XxdTWl
	 r0cpAwMJTpu/03mKxqCcuve8QEgcub+GpUZ7rP0nkq/PV2SZGJf/t/yshAX0pW2wpF
	 KQlpcrcURaMZko/1IYswVwiR5dx3AZtByTG0CcgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/675] ptp: netc: explicitly clear TMR_OFF during initialization
Date: Thu, 30 Jul 2026 16:10:44 +0200
Message-ID: <20260730141451.799735550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit c3f2fc231a39e29fe9f0adc14a3ecc3c1260d3c5 ]

The NETC timer does not support function level reset, so TMR_OFF_L/H
registers are not cleared by pcie_flr(). If TMR_OFF was set to a
non-zero value in a previous binding, it will persist across driver
rebind and cause inaccurate PTP time.

There is also a hardware issue: after a warm reset or soft reset,
TMR_OFF_L/H registers appear to be cleared to zero, but the timer clock
domain internally retains the stale value. When the timer is re-enabled,
TMR_CUR_TIME continues to track the old offset until TMR_OFF is written
explicitly. This can cause incorrect PTP timestamps and even PTP clock
synchronization failures.

Per the recommendation from the IP team, explicitly write 0 to TMR_OFF
in netc_timer_init() to flush the internally cached value and ensure
TMR_CUR_TIME follows the freshly initialized counter.

Fixes: 87a201d59963 ("ptp: netc: add NETC V4 Timer PTP driver support")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260720012508.23227-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_netc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_netc.c b/drivers/ptp/ptp_netc.c
index 94e952ee69902e..5e381c354d746a 100644
--- a/drivers/ptp/ptp_netc.c
+++ b/drivers/ptp/ptp_netc.c
@@ -779,6 +779,7 @@ static void netc_timer_init(struct netc_timer *priv)
 	netc_timer_wr(priv, NETC_TMR_FIPER_CTRL, fiper_ctrl);
 	netc_timer_wr(priv, NETC_TMR_ECTRL, NETC_TMR_DEFAULT_ETTF_THR);
 
+	netc_timer_offset_write(priv, 0);
 	ktime_get_real_ts64(&now);
 	ns = timespec64_to_ns(&now);
 	netc_timer_cnt_write(priv, ns);
-- 
2.53.0



