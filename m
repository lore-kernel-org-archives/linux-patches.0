Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE46126C18;
	Wed,  5 Feb 2025 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763372; cv=none; b=qwUmwWoweAtBQylI9/bjog9GvKK8ShYzjaSr1eVEEdb+YPuJNvecBbNKsVs+qvHF/cDyCiVgKCMoQxI597xthgPmsG24yKPkoY3V41ao8Rn2Z7hvX/3WJuUqTMtEyUoZCRi33Sh0v5LnCai5ZcNLaRwGwrbhtpM/haJys2JSAGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763372; c=relaxed/simple;
	bh=YjV96UURJi4zuACjwe2SxzIkk4YMM9snizfdbxraK9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQxJrkzBClm/T/+EXkB8cmNt2HiETdefHhE0DRY3aNoKI+poEmceKAejFypXLTwZX2j+REyPuOxfgtqM849KbNiHZrRjXajxxVaBlSJ/rOXfJx4Tgx0sBfzrUSJMFajxJIZFKFTFt6QJpeN9/Vfb78bhSX2vyO65n+YW/DFDpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvVd/Gv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvVd/Gv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493B6C4CED6;
	Wed,  5 Feb 2025 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763371;
	bh=YjV96UURJi4zuACjwe2SxzIkk4YMM9snizfdbxraK9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvVd/Gv2keXuaRu5qa+Q1ggbggfBd3Fn+VDoCtpRK4O5QAr6EPUlxQqLBS0ZUer0K
	 q3684iqnNmvsJadNRM5NNXEB0Zj+yWl6RR4SDGW9K8nZPgbJYO2Xr1zk0/thc5K2Jt
	 7gb19PCNpwNbOI/+AwnncQe6TbyomJ0bxO2f2Rk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/393] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Wed,  5 Feb 2025 14:39:32 +0100
Message-ID: <20250205134422.327899631@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0a934adcef012..cf70793b1e905 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1065,6 +1065,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



