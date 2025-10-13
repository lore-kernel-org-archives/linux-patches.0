Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8B63081D3;
	Mon, 13 Oct 2025 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370117; cv=none; b=n4tlE2F3YFYwtNkKc+ArsESmJE365JAyjHFY2GEn05FabFNXx65IpHzMFl86ku3hktmaP0RBHQd0hNVXKZvrUCkRMHfpgq+PV5/d2aCvXOjYvjAi92fC0kbJuYQThyMDdRZ3BPirHj8KkC1fZg+cU/IgX787a7Pvr56dS5C/f+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370117; c=relaxed/simple;
	bh=v6+FHqO8/XpifNAUprtxHFklfqKMPwkxKXzCn0bLs60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv1BfNzJY0OLm1P/zpnF9jI52sK4vMvrdOvyBhpN3RzlGmXlc3sbOSBtEQwdGkemZaGtvWBS2VUkv/5Vz75/BFD+rGOfISdoRY0jp2b7hJ1YuJhwKwakQsCkr/KWrR201NNvXshpZfOw5q4eip2alzfn1aMKhoo0F53VadQU/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJcU+WgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJcU+WgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE67FC4CEE7;
	Mon, 13 Oct 2025 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370117;
	bh=v6+FHqO8/XpifNAUprtxHFklfqKMPwkxKXzCn0bLs60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJcU+WgNVGFhq3nSpFWxOejV5Pdo7UPf5ON8EX+WYD2V+Kaw8kRtJFk7Q5TCTJKAk
	 c63bBNfs6RKpE12wCuxEeeL7KKmpWBSnLSC8g/RfMLjGTk8TQZfu1lCAmKqN2Q5Zcp
	 31Z10XvtOirJkXPCECNK4Zcvjz1ZXKB+z6evZr5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 451/563] ptp: Add a upper bound on max_vclocks
Date: Mon, 13 Oct 2025 16:45:12 +0200
Message-ID: <20251013144427.619612482@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: I Viswanath <viswanathiyyappan@gmail.com>

[ Upstream commit e9f35294e18da82162004a2f35976e7031aaf7f9 ]

syzbot reported WARNING in max_vclocks_store.

This occurs when the argument max is too large for kcalloc to handle.

Extend the guard to guard against values that are too large for
kcalloc

Reported-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94d20db923b9f51be0df
Tested-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20250925155908.5034-1-viswanathiyyappan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h | 1 +
 drivers/ptp/ptp_sysfs.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index b352df4cd3f97..f329263f33aa1 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -22,6 +22,7 @@
 #define PTP_MAX_TIMESTAMPS 128
 #define PTP_BUF_TIMESTAMPS 30
 #define PTP_DEFAULT_MAX_VCLOCKS 20
+#define PTP_MAX_VCLOCKS_LIMIT (KMALLOC_MAX_SIZE/(sizeof(int)))
 #define PTP_MAX_CHANNELS 2048
 
 enum {
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 6b1b8f57cd951..200eaf5006968 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -284,7 +284,7 @@ static ssize_t max_vclocks_store(struct device *dev,
 	size_t size;
 	u32 max;
 
-	if (kstrtou32(buf, 0, &max) || max == 0)
+	if (kstrtou32(buf, 0, &max) || max == 0 || max > PTP_MAX_VCLOCKS_LIMIT)
 		return -EINVAL;
 
 	if (max == ptp->max_vclocks)
-- 
2.51.0



