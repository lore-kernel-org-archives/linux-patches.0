Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509CC44605B;
	Thu, 30 Jul 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424320; cv=none; b=RLBUB+UDSkdVRq3w1TSXesOktfmP1XOVm6Nm6Aw3BR1UJGaB+65zcCf8RZzqnIJv/c+rhEwC3hjJJF75/H1Nd1+8NSoLpaYsVC4NQzKID0ai9BhsGo3YPCrJjUSOVTW+S+KCR9rRvWDWbxadl6SioPt9smnuiQuyWn+WT9GVMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424320; c=relaxed/simple;
	bh=qXtfFu5IInsSdBBGGU/Uk/slppqv2QCLvR4LCsrP4/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nrout/Fph0p/2jZDLcJCYmxDYcBkAY3BKAdwEn9qfTFvh6ZapiTVL2ldg5FI4nFB2+KsxIUtiH/C2kVcJmKph7rr5hnhUxYHYKFItjGelxduC5pFPowJCum43INf4e3JT/Ybxd2Au98yRxLXzP5y0qd2xbkTzUiQqTGN83Sp3kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+Rb0Jwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+Rb0Jwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5DE1F000E9;
	Thu, 30 Jul 2026 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424319;
	bh=tA8uoIE5ZhbjPW7udR/W8v04D7m6RJRPBf7RzpSalLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+Rb0Jwgl8JVrc+7IM3/M4KUoq3zHOOww2EdrzBBQcfV9QW/5RowNCZuJUqpHMxo/
	 bbJVeO/R/hNPp5Jb3j0QlNkO4d27wYmFmGodSUD/QQ2nM2gGOa9z4PG+439di2EmbB
	 Qt1/8pJCUgg5uT0CPEx4IxX1xWfgGDlhLpBUqr64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 315/675] mctp: check register_netdevice_notifier() error in mctp_device_init()
Date: Thu, 30 Jul 2026 16:10:45 +0200
Message-ID: <20260730141451.821656281@linuxfoundation.org>
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit d9a33cadc70a94c1582f65e6042e81027cd200c6 ]

mctp_device_init() handles errors from rtnl_af_register() and
rtnl_register_many(), but ignores the return value of
register_netdevice_notifier(). If notifier registration fails, init can
still return success while the module is only partially initialized.

Check the notifier registration error and fail module init early.

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260720072518.112614-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 04c5570bacff69..7861d83aaad263 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -536,7 +536,9 @@ int __init mctp_device_init(void)
 {
 	int err;
 
-	register_netdevice_notifier(&mctp_dev_nb);
+	err = register_netdevice_notifier(&mctp_dev_nb);
+	if (err)
+		return err;
 
 	err = rtnl_af_register(&mctp_af_ops);
 	if (err)
-- 
2.53.0



