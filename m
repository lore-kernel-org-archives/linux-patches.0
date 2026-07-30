Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB16436BF8;
	Thu, 30 Jul 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422170; cv=none; b=ZAmfVMqVKc2roOC+N3aXXrNfXlK2tuxUM0sSC7PkHUbeqd89AP9bcsjSyuruN70Mawu3CEjGD8In2UkJbIKq7NUmZMsS0RPwfQXD1pfyqf0CoBgbbUMRZX9WSaLaJYt0PohBh5J09zB9Wjh7Lu/0A/msIa17l/LLV7FxrSFWVRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422170; c=relaxed/simple;
	bh=okK2ZdvNFqLf7SkqZSeIaaDtaxdvIYdadeQYvL7bRZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ8DyIXadt9C3KF+ApchTFcTF3eL/qYxsxCjKG4LK1BMKpmThd49PVM04l3Mbx/yfYf+Nj9LqzpF3Egoet7AtD6XIPEFaWcRklq4tQ9Hj4DUtMmKwuK5fYGPp1xK/BpUXvwxbDRWsPmcbWgStJN62AFDnwtjuhlsG640L4vMQ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQ5IO5t3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQ5IO5t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49801F00A3A;
	Thu, 30 Jul 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422169;
	bh=5u4jj/UOr+i+IdJ1sY3ZzXR3WiHbJs9sJd9zPuUxNZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ5IO5t3jA+teqxjUr8GSlADc9sW7kd+RKxI3tpDLXW5dwqCeQwRfYUuly13AFZOx
	 TnElr0AIoDPbfkpNVarIyYUY7yyn5qEsPXI0K9FzPmm6VtzUcFAD2zE21STaW81gtu
	 RI0P1gRC+heYhAohWh9VgRZkExlsXd0LpvQBugsE=
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
Subject: [PATCH 7.1 347/744] ptp: netc: explicitly clear TMR_OFF during initialization
Date: Thu, 30 Jul 2026 16:10:20 +0200
Message-ID: <20260730141451.662128132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



