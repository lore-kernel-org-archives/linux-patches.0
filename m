Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D55337EB4;
	Wed, 17 Sep 2025 12:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112887; cv=none; b=qQAZFxyP9jlPirfCYMgkTkQNTBJE6+/+DaAaRe0fP3OOorxV57ZGcbPg/yhWH9u61FrdBrYdOCcnwBZA8n0+3aNqdjNJrHRu1CA9yuboaIxUJwodJcHEmwNDNUomN2B/GzBt2EuoTMufCs4RyOkbL/jnlYFc1WECOK/btbP/pIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112887; c=relaxed/simple;
	bh=57ZQlM+x4snq16+zZOkmNCHsh74w7vIwz65/J5OL0Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euKoLQJf4SCxVZAIGnewvLztnZgj1zHsPMqthZPQYk7WfahRQPEQ+/i9k37DvmQL9DILrGtLBMx5XTpnDtId7l0j6gWuLAmLktTlmQ3Ae0jaB0jPnGS86UNsDKFcbqevgh1VWx9X4daPQxXwujseE4lbFDZ68HAtzFskjee+LcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jF1RUA09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jF1RUA09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E38AC4CEF0;
	Wed, 17 Sep 2025 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112887;
	bh=57ZQlM+x4snq16+zZOkmNCHsh74w7vIwz65/J5OL0Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jF1RUA09iXEnIymKVpKKE65esr0p9YjGSJoknggGDyXqVGblDXca9AlApcwxN8GGq
	 uPPZieRuuA5RfYXhvYMZoIjqfO0ha7Pn/a1is8z0utRmRfXcdIzfTtrUs87abyTCR+
	 ihDXPsOUA90+xVDKtmLTJgI4KCtk8FG8kCDK1uk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 062/189] net: libwx: fix to enable RSS
Date: Wed, 17 Sep 2025 14:32:52 +0200
Message-ID: <20250917123353.388029048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit 157cf360c4a8751f7f511a71cc3a283b5d27f889 upstream.

Now when SRIOV is enabled, PF with multiple queues can only receive
all packets on queue 0. This is caused by an incorrect flag judgement,
which prevents RSS from being enabled.

In fact, RSS is supported for the functions when SRIOV is enabled.
Remove the flag judgement to fix it.

Fixes: c52d4b898901 ("net: libwx: Redesign flow when sriov is enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/A3B7449A08A044D0+20250904024322.87145-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -2071,10 +2071,6 @@ static void wx_setup_mrqc(struct wx *wx)
 {
 	u32 rss_field = 0;
 
-	/* VT, and RSS do not coexist at the same time */
-	if (test_bit(WX_FLAG_VMDQ_ENABLED, wx->flags))
-		return;
-
 	/* Disable indicating checksum in descriptor, enables RSS hash */
 	wr32m(wx, WX_PSR_CTL, WX_PSR_CTL_PCSD, WX_PSR_CTL_PCSD);
 


