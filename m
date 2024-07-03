Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85FA183091;
	Wed,  3 Jul 2024 10:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004074; cv=none; b=o8sRi72jRlsukTwAjq2qRPqx+4GQekj2kvEf9LA62y1F2LTyHVt4fCJQyLLa3mkoozRTZM6L46paIiVrsaSOH9H3YzbgemiQJR7Oo3HLKWk6UStSYTrIUMf21+SsOj4iZl4RyUG46SLAQnSaC9sVsEOaBimzsFHsLjadXyUtNrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004074; c=relaxed/simple;
	bh=rT+eFjbB1SviXCVDztNibDTwFDxM/UBZGGYNLS+iE3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aM2tmH1/sYvn+iN1H/i0lks5MyUJ8hcw69KQ9tshkG6ps05PxLpA/KtHrzaQQbQ24Wi0fz8069o1cpmBHdfMeyXNAAbXv3J7u9VlrNb+YLlrQKEDsvkPNkj2nca3E4JmIOtpj9rlxzmyfiH9N1FH1QUBj5T4UwJf5VPR2h2EUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI122SRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI122SRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10606C2BD10;
	Wed,  3 Jul 2024 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004074;
	bh=rT+eFjbB1SviXCVDztNibDTwFDxM/UBZGGYNLS+iE3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XI122SRR8rcaAKQKhcrJ+iw4SCPDury4RmcLmJbOKUTKe8mCpA5pj/mTnhF7MIuzf
	 dwGPPda5H7mwOXSu2AGaiqSan+lY9h3TzLPbkI37htxD8t6M9kg+5JRsdJf6djZEp6
	 Cbb6E6g4Mp8o3/LhRxiP7udUR3aU+sQkeOVWNsGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/189] net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings
Date: Wed,  3 Jul 2024 12:39:34 +0200
Message-ID: <20240703102845.765083796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit fba383985354e83474f95f36d7c65feb75dba19d ]

This functions retrieves values by passing a pointer. As the function
that retrieves them can fail before touching the pointers, the variables
must be initialized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240619132816.11526-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 491625c1c3084..387091cb91340 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -798,7 +798,8 @@ static int rtl8150_get_link_ksettings(struct net_device *netdev,
 				      struct ethtool_link_ksettings *ecmd)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
-	short lpa, bmcr;
+	short lpa = 0;
+	short bmcr = 0;
 	u32 supported;
 
 	supported = (SUPPORTED_10baseT_Half |
-- 
2.43.0



