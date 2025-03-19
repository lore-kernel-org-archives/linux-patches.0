Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EF1F5849;
	Wed, 19 Mar 2025 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395169; cv=none; b=LjmMN+Qd8S7Eo7Bsl/wGAAzC7EjYsnHn4o6mAV+0rmS52f7nkikRZ7t6NSggGDq128sQO8TYG6OVsFXZxiT0+GujSJjVnWB72rd+uhVaYuX0j85MePkkAji1+NlxDJVVn0IYj5EEo5kPYZtwMXqhTJLuKPc2tUtwaJEwfYJujT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395169; c=relaxed/simple;
	bh=AbpZ6SoSWLZW5EMjALIXcrSDmW5zOARf348NKfbnqb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQy2HG4lBN2GCSnb5OPdBc6gxpjjI7IVPoKKf7Idaeu5k8n8wafhEBm7bn+KgoPXk/7wnGtMiZ5p09XZWGvMb+LOeYkc8vnlU8DzZN5Pbwya4qLiMOSPXtQcG39JHpMiQJQQNRLeAifZ3lUlTAyTq3HRf6NLfyfWAMFfDKKbsAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNxOByx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNxOByx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD9EC4CEE4;
	Wed, 19 Mar 2025 14:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395168;
	bh=AbpZ6SoSWLZW5EMjALIXcrSDmW5zOARf348NKfbnqb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNxOByx0V6M1wU3C3cn85wYk1YUMgNUHi1vaEMi5J12IYfrpW2VQU6QyNaAaoQc3M
	 IP1m4lwiZXHzN6NL7URUFAs2wGsBc/FoFucFOdA8+/Krv1Ow76hYJ2uvyi0bDtvOK/
	 3yOJy0sFGowsjsYlM7vjSDgv7Bu0jfUobaYJi8Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/166] net: mctp i2c: Copy headers if cloned
Date: Wed, 19 Mar 2025 07:29:50 -0700
Message-ID: <20250319143020.503872880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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
index 20b8d7d528baf..fbe8483a07b58 100644
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



