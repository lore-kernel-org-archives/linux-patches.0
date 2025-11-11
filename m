Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223FB2EB5CE;
	Tue, 11 Nov 2025 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824750; cv=none; b=lJrs2YDU7U9rAwU+1Ks6/IBEnM6VEGHjaNhBGGtUJ07HeOXjVLVOu5KbM1LOSUUATEwHuSZnlepSbwxw72gJSOZIe2yR6MxLivbOO90p3IhRxc//6ZmpPfkPD/SbkPrp2qoeSVABGZP53cVFCtFy/aNbRe7YQNhG3kIi9BrN2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824750; c=relaxed/simple;
	bh=KPpyqMNEzL1cvFeDjO9HYzSq2sEWec+qomyTp22Xzgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeV7ERV6y5HCyHWoOSipNEna4V/66GZbkFrOtMlRLVBuZKnvbM2LvRiUI7R4y5cY6JQxzjMdn9ngyRdiF4WFeRrpoik5gmfCungiZpwnHhFon/Q7PVVGj3SAAaT89PTwrcDbVaAS1WNM+BO9cx1vni/NwnrZBfLf634xK6cvnu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvKf2zLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvKf2zLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DEFC4CEFB;
	Tue, 11 Nov 2025 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824750;
	bh=KPpyqMNEzL1cvFeDjO9HYzSq2sEWec+qomyTp22Xzgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvKf2zLBJEmPVR/jt2FVfTWlSlHgd5i6Dw5yozJY14jGYlm7V3hmRNnqrgR3BwcFO
	 FdoywDlKeQbO7X0aFIYH5qXaCjnBwVX9Log6meVeOWrUWdfS5d9CcNsb9MTfM/L60C
	 obnWIkBWM7+q7HFBZPnWrcXpOrKXyOYCYNnBidP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 510/565] Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()
Date: Tue, 11 Nov 2025 09:46:06 +0900
Message-ID: <20251111004538.427390604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 1c21cf89a66413eb04b2d22c955b7a50edc14dfa ]

The memory allocated for ptr using kvmalloc() is not freed on the last
error path. Fix that by freeing it on that error path.

Fixes: 9a24ce5e29b1 ("Bluetooth: btrtl: Firmware format v2 support")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 59eb948664223..c4431c5976b40 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -625,8 +625,10 @@ static int rtlbt_parse_firmware_v2(struct hci_dev *hdev,
 		len += entry->len;
 	}
 
-	if (!len)
+	if (!len) {
+		kvfree(ptr);
 		return -EPERM;
+	}
 
 	*_buf = ptr;
 	return len;
-- 
2.51.0



