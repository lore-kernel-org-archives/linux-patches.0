Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0E40963F;
	Thu, 30 Jul 2026 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421926; cv=none; b=NvrW4WBbL8/2jHn9OIjN5NCzm/hfAaUCkX/PW+JApwkvbnRGXaIgbs0cwHyJ55t04oLcyBAkVnpAAajLpq1NpZkxKvwoOCg4ZhGKo/Oz0z3g9d+hxWQSSsDqgydMQ3p0tOlXKrnTCKnE/UuxQ9NaT2dpQ02LYNwzPr9csdmuPOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421926; c=relaxed/simple;
	bh=QYtDsQ6Q/o08ZvSTnJLpuqmwWia6v9j/6hiFUQzvjHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV/r97RZCCB39VAagC5A4dJ03OuLWdZenF23Sg9XDBq9uzYaI/n++rU6jeHUOHvHDJEHGQ6A+HEGM8Ma4O4G6fdWrxuFrg9yeJp2GnGFnEnSl4L8Fh1YZWofSq+mhJQvnPFur3EHiJWQzNkn2UmO54HpWtSMWmit99u1zD5w2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftTh8+6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftTh8+6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875271F000E9;
	Thu, 30 Jul 2026 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421925;
	bh=iFzP+Fwt9WEhiaerRR6LU9OrFsEe7vukZZPLB2sPG8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftTh8+6jOMTUYgghFg34HaDMMeI/RNaq3Td9AmiuuFY15OwOJ5V0+YXrF9mWy3JNB
	 gVcnRFBYh3+kw8sijb0mdT1JkMVFXldLt0Tln2Vy318QoK1ry9zDCzEXf9tZfnty+r
	 RwCQ3uuXHYF6IS1BvPz4zMZJB8ZcZ7XR9lZsxFhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 264/744] net: txgbe: fix FDIR filter leak on remove
Date: Thu, 30 Jul 2026 16:08:57 +0200
Message-ID: <20260730141449.906347256@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit ecaa37826340520664a4e5522f803ff48fc3f564 ]

Perfect FDIR filters can be added while the interface is down and are
kept on the software list for later restore. unregister_netdev() only
calls ndo_stop when the device is up, so txgbe_fdir_filter_exit() in
txgbe_close() is skipped in that case and the filters are leaked on
driver remove. Free the filter list from txgbe_remove() as well.

Fixes: 4bdb441105dc ("net: txgbe: support Flow Director perfect filters")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260713091911.1614795-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 8b7c3753bb6acc..1f633bdf1972f6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -951,6 +951,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	netdev = wx->netdev;
 	wx_disable_sriov(wx);
 	unregister_netdev(netdev);
+	txgbe_fdir_filter_exit(wx);
 
 	timer_shutdown_sync(&wx->service_timer);
 	cancel_work_sync(&wx->service_task);
-- 
2.53.0



