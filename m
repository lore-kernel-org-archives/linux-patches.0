Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C697A280CE9;
	Tue, 25 Mar 2025 12:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905511; cv=none; b=YU5gA1uHvuvR1Q8B0GXHtlPGN6JtDSpQOPW11huTxFIb9fBQm97zzXvOes6s7u9S3reb7U/st6lcqKX/gtBuC/+jjAYIROEUJEj6QOMK+63kBPpma7M1t/OQQgNfVQV0zkJ/iI9+syw4iJMNORUcGqE2WekeEuS87FnpTIijLJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905511; c=relaxed/simple;
	bh=1EVWgSRWouHt8D4f+DXlcP5PVKAl70ylpqNsHMk4gWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCgyExWj9x3eze2SuLTqSO55m38H1UR4st2oNECfWyAFY9NpymMMRaVsGmKUPIvlFoiJorX/4ZLxVcAdNp6R74WVkdLQMiY3lsh6KifSW2nlRJ/YdeqfRyIgO+nvszv3Vfaev6uA3OWLSNCkRIyakcIikE5zRwHTR6ORxMautrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSmh3/Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSmh3/Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD7CC4CEE4;
	Tue, 25 Mar 2025 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905511;
	bh=1EVWgSRWouHt8D4f+DXlcP5PVKAl70ylpqNsHMk4gWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSmh3/ZpCvX9PVU5cMIDO7UIVxA4Il8D4s37rtttO/A7XqwPDk3VVVybYl+c49RKm
	 7pMdCXVwyhCtrg89bKomwgxRVWv7ZKsxRzfOfoTQO5u3NWbjxzMoobC5xbDaa4ivMO
	 QjbCe8uiT70CrPhdCRC1IF1UqQyeqGxCKShpIpTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/198] net: mctp i2c: Copy headers if cloned
Date: Tue, 25 Mar 2025 08:19:37 -0400
Message-ID: <20250325122157.041543756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit df8ce77ba8b7c012a3edd1ca7368b46831341466 ]

Use skb_cow_head() prior to modifying the TX SKB. This is necessary
when the SKB has been cloned, to avoid modifying other shared clones.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Link: https://patch.msgid.link/20250306-matt-mctp-i2c-cow-v1-1-293827212681@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 7635a8b3c35cd..17619d011689f 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -543,6 +543,7 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	struct mctp_i2c_hdr *hdr;
 	struct mctp_hdr *mhdr;
 	u8 lldst, llsrc;
+	int rc;
 
 	if (len > MCTP_I2C_MAXMTU)
 		return -EMSGSIZE;
@@ -553,6 +554,10 @@ static int mctp_i2c_header_create(struct sk_buff *skb, struct net_device *dev,
 	lldst = *((u8 *)daddr);
 	llsrc = *((u8 *)saddr);
 
+	rc = skb_cow_head(skb, sizeof(struct mctp_i2c_hdr));
+	if (rc)
+		return rc;
+
 	skb_push(skb, sizeof(struct mctp_i2c_hdr));
 	skb_reset_mac_header(skb);
 	hdr = (void *)skb_mac_header(skb);
-- 
2.39.5



