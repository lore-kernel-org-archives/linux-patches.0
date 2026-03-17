Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29723EF64F;
	Tue, 17 Mar 2026 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765796; cv=none; b=qSy1eyPgPvmcG2qMlzeqFmx2CZiDevk1xTEqFaagjHTTuHCLSalew789bC3s7enhA6J2hwN3kYkN+GmN5+pOWlDhKwStxlfEKKaQ0+giQiRN5Rzje2RxWXzCeVGdTyv9JJL6ua0f1v84AYuint/YKjq1vB6oDpcGozkaz6lPHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765796; c=relaxed/simple;
	bh=pO//gdvvQQrEGKabTM3TVfulSwq/1JYJ8CZxtbDRE0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of7hOH6lHkqg3IGLswxLvmJjK795w8dY4bQ25nGtsI759ZCIWrHjzawAhOqanV2ei0atnMvvezJpcczmkXvG/7U9BujOybepkffWqDuV729N76UL5pp/Q/+aDFh6QxYrq0EsESAepmUb0savWjFVlKFYgZvbb0fvcCXXnsQ4Sd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fkc/N0YU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fkc/N0YU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2990CC4CEF7;
	Tue, 17 Mar 2026 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765795;
	bh=pO//gdvvQQrEGKabTM3TVfulSwq/1JYJ8CZxtbDRE0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fkc/N0YUHItEpYt215avmATx3Ynf1DnovdyLGxsdxpcuY4I6PDqwgwfZ2KYwmx2zY
	 qQrkN5zrWIysmaCILRAl5U7BszkqLbpUsG1qbMkgX4dFgx4t7CBj/Scmeb652dK2+z
	 TAZHpzzy/nnIYUZWv3IOYJ6aVmfmKyFJE/fiRpnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyuewa@163.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 066/378] mctp: i2c: fix skb memory leak in receive path
Date: Tue, 17 Mar 2026 17:30:23 +0100
Message-ID: <20260317163009.439032994@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyue Wang <haiyuewa@163.com>

[ Upstream commit e3f5e0f22cfc2371e7471c9fd5b4da78f9df7c69 ]

When 'midev->allow_rx' is false, the newly allocated skb isn't consumed
by netif_rx(), it needs to free the skb directly.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Haiyue Wang <haiyuewa@163.com>
Link: https://patch.msgid.link/20260305143240.97592-1-haiyuewa@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 8043b57bdf250..f138b0251313e 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -343,6 +343,7 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	} else {
 		status = NET_RX_DROP;
 		spin_unlock_irqrestore(&midev->lock, flags);
+		kfree_skb(skb);
 	}
 
 	if (status == NET_RX_SUCCESS) {
-- 
2.51.0



