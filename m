Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61905357A3D;
	Wed,  3 Dec 2025 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778820; cv=none; b=FaR7qVVOoos/2CU7CKZuGtjUJBP/xs1Z7l3cF/kbzQ/hdPgBiwKp7/uWlB0DDiE3j/9o/Uf/cOMBoAmEDHkUVcbw/KLYwqoXUxmA9ih9UmsSiqxgzU773ChjXDP5SvoVlObkhl7uIPPXYbDMvQivC6HiPrvDmlpqElGaL5FBslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778820; c=relaxed/simple;
	bh=QHYeFpbfqFiQT108PUQLw5ftc6M/cAYbM467ApqKQp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emPj+TXecMLJw1Oma2b8/CxRP4GvdtHbfYh4igMIzirlwHMPKAkx2Ls4BPVE2mgsGY+OoNZpGq0222ys1DGdeViyaoat2FH3n5BfjEC0hY9a5zm3qOaJ3M3jz03slToXNWsCXXGdrAD5qfuprf7xdWQGAPA89YNfx+THqKIhHuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzYB4TgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzYB4TgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B810C4CEF5;
	Wed,  3 Dec 2025 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778819;
	bh=QHYeFpbfqFiQT108PUQLw5ftc6M/cAYbM467ApqKQp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzYB4TgAcT7AvKfgTIdiJQ7Xg29Ldm+n4TP7QRvOH1qTxx9A7BA2Bp37ILiqwzwBH
	 4q2yM8g42etDOTXNIVjOHMqY5uYc+U+SXVhC2sX4yKAJoAaYq2iDqu4V0ww7c5zD3f
	 i8CV+aB5Kj7okPYQ02o7gm60AVnMsE0rO3OKinsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/568] wifi: ath10k: Fix memory leak on unsupported WMI command
Date: Wed,  3 Dec 2025 16:20:38 +0100
Message-ID: <20251203152442.013101145@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 2e9c1da4ee9d0acfca2e0a3d78f3d8cb5802da1b ]

ath10k_wmi_cmd_send takes ownership of the passed buffer (skb) and has the
responsibility to release it in case of error. This patch fixes missing
free in case of early error due to unhandled WMI command ID.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.3.7.c2-00931-QCAHLSWMTPLZ-1

Fixes: 553215592f14 ("ath10k: warn if give WMI command is not supported")
Suggested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20250926195656.187970-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2fda5ca3e6ee9..22ce8b529067d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1935,6 +1935,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn(ar, "wmi command %d is not supported by firmware\n",
 			    cmd_id);
+		dev_kfree_skb_any(skb);
 		return ret;
 	}
 
-- 
2.51.0



