Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DA4548EE;
	Tue, 22 Jul 2025 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193092; cv=none; b=EhoV/d6XRPCwh7JyHPoSB7xF0BJ+lWa3AC41TQltcoifVmvl0AwthEzizTeXDV3zVzQsSDu3cUbPiWvWd2Z7E7Ond0MpLl/CNEIi9gvO66YsTsZ4uzCZdscVvPjYpr1LGiQ7DiSBNf3L6JWcEyEXAyn5E48Wc7hjU9/pew+GiUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193092; c=relaxed/simple;
	bh=Dga6LEvf+N7QeLKkOkt3GYqZmAuDEuXroxnivMvTpqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvuIl5vgtYAum2zfe/to4bAkl6Rc5wKfU9F6jr+Yh9OpM6a1B75Y0seOv8+PrNW1LLL+qJkRVlg6GwSi+Fl2ohrJwFEQffc3Wh8enoClJCKCnR5o965QwdZi7tYpCAM9XpNpJX+Ul9vncYFf/ctpXdmeNi1rXrypTBUKIqvvevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Zwqjvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Zwqjvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5749BC4CEEB;
	Tue, 22 Jul 2025 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193091;
	bh=Dga6LEvf+N7QeLKkOkt3GYqZmAuDEuXroxnivMvTpqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/ZwqjvmwGmmb9YnfwHLBGKtXaZeXLCQ7WJWXJZZur1RXnKU4GvoNYxTR9Sm1NNTN
	 luutAY/97b6EsV9Y5kPB/HM+F5VqrF5YBnppyR4Cml7iQMxwzs+Hj3I+APJEmIDMt/
	 LNckyTpZu8jz49RCdGpQlItaToNl758CAPImPxwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 148/158] net: libwx: fix multicast packets received count
Date: Tue, 22 Jul 2025 15:45:32 +0200
Message-ID: <20250722134346.238957457@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 2b30a3d1ec2538a1fd363fde746b9fe1d38abc77 upstream.

Multicast good packets received by PF rings that pass ethternet MAC
address filtering are counted for rtnl_link_stats64.multicast. The
counter is not cleared on read. Fix the duplicate counting on updating
statistics.

Fixes: 46b92e10d631 ("net: libwx: support hardware statistics")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/DA229A4F58B70E51+20250714015656.91772-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2355,6 +2355,8 @@ void wx_update_stats(struct wx *wx)
 		hwstats->fdirmiss += rd32(wx, WX_RDB_FDIR_MISS);
 	}
 
+	/* qmprc is not cleared on read, manual reset it */
+	hwstats->qmprc = 0;
 	for (i = 0; i < wx->mac.max_rx_queues; i++)
 		hwstats->qmprc += rd32(wx, WX_PX_MPRC(i));
 }


