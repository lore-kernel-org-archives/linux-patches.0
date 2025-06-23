Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8191EE7C6;
	Mon, 23 Jun 2025 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714524; cv=none; b=Vu1emNM5DZIxeHN/S8vcHRf4B1E/RUthbYzjMpXgwzGRyefjO2Fz/TneqnN52HRmS0uxxpEZJERXgijY/wJI+wqRIXUWlZnumwkOvyRRO9zt2x3xSqQ5hckA8znHw9A+EIxEStjZggZwZka8N+dBG24Fvp3rFVDW3bSXyC/mmew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714524; c=relaxed/simple;
	bh=ju+1wnqRYorKeP9pVIhd6EKVihvUsyxoR2ZHv1SLe6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqd7uoKqSr3ymbf799wdnYGiFxZKSaMwSM/wkkBgS9bwgoJ7ro18K7AOK6RtkN/r4Tf1SEJjX8XlbLnTfi8LZXBZHmjMEU07J8VkP3PFyYbTaEmlmj0ylM8UCIr+sAoN97sbRXsoZc/XvlTDWjHxpyip9N/T/JZLf1mKw71+C48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjJMWjEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjJMWjEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E36C4CEEA;
	Mon, 23 Jun 2025 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714524;
	bh=ju+1wnqRYorKeP9pVIhd6EKVihvUsyxoR2ZHv1SLe6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjJMWjElnAlBx/d1cKVxR3h6aq6IjwERK9odJ0VBQ0drcgcHLImZrhR1ZOftvyyls
	 VYd+uFAIMx2VCwpruau9vIfgjh0CrpfjUQuecS0URB11Tw2kqcurQkNGW8KBL80UyY
	 MkDwCn8cBxqJh+ZURxxyY7UYUuW9rDBcAq2BEdrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/290] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Mon, 23 Jun 2025 15:07:04 +0200
Message-ID: <20250623130631.801610913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 63a9a727d373fa5b8ce509eef50dbc45e0f745b9 ]

Add usb_free_urb() in the error path to prevent memory leak.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Link: https://patch.msgid.link/aA3_maPlEJzO7wrL@pc
[fix subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 311676c1ece0a..8151bc5e00ccc 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -503,8 +503,10 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 			  (void *)buffer, buffer_len, complete_fn, context);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		usb_free_urb(urb);
 		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
+	}
 
 	return r;
 }
-- 
2.39.5



