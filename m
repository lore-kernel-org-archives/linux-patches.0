Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC4825EF96;
	Tue, 11 Mar 2025 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705431; cv=none; b=J4K1/bbMFiySe9gTqbvwwv1HuopPzF3RvzyGzmSqtzQPcQJ1e5kI+EUh9sLLAAZgz0X+37mqMHOgPP4zN94JTbIuSOY44BCjCPOgWHXmtYsxYOjTACqSRuGc3MRdhxV3+OSqcjbCezAbBibKcfz5yCyx49IhNuNeoE1JB4CaaCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705431; c=relaxed/simple;
	bh=iSQy0LUIQRgFMdxtxvatU2W4DR5/DjdBY3hUpM5DgW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPj+UhjwuQfbF/D9ChBtPHU6KGDBchZILV73lV805V3ZKjgLsrfndCQH6pIGe5G/JMbcd4a9B5ftvqFKVHMBUGK1k97FveD0T6weYWEpM4rYjrUw8Lr++x6fo5EIpzb6lEQwygTOXKTlqHi/CBpOjrdMbWbZemwqkUaEDkTHE4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhyGNrrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhyGNrrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECD9C4CEF0;
	Tue, 11 Mar 2025 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705431;
	bh=iSQy0LUIQRgFMdxtxvatU2W4DR5/DjdBY3hUpM5DgW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhyGNrrx2x2vmp6vN6Lei14gacrKdVik6xoo+4nvLggufZlUmNQN/WZuLw4GyhJT0
	 6BsMXpoSauSKchJtK2f1NwKr2WiiD8GFtq9/bca4GGpBycn9mE186xdx1r8u7NV6cv
	 8x4Nd6XhWXQ5C0l0S1I+lVjeJd1ELKTeW9C9VS1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/328] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Tue, 11 Mar 2025 15:56:25 +0100
Message-ID: <20250311145715.484771440@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit f79bc5c67867c19ce2762e7934c20dbb835ed82c ]

rtl_init_core creates a workqueue that is then assigned to rtl_wq.
rtl_deinit_core does not destroy it. It is left to rtl_usb_deinit, which
must be called in the probe error path.

Fixes: 2ca20f79e0d8 ("rtlwifi: Add usb driver")
Fixes: 851639fdaeac ("rtlwifi: Modify some USB de-initialize code.")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-6-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index b5b95ec1231e0..9e31ce0a9f562 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1079,6 +1079,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	return 0;
 
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



