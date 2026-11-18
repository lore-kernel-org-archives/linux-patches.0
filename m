Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058061;
	b=gsUh90j5klG2b3L9UJRl8PhLu6RUfZ2NZfZJ66PAEJwk/3DsYAOqM3LjMLzV5K/3U6f/
	 WZhZh7tqNUuj8swgAY27ariag7XcyDjO/jLJBZUSJtwHfd6sBLh162rnzBeqjVWWVctfy
	 s01BFaNJTNC43so014Q1vJnzmRzYA24v1/+EV+ihNQeuNwdn9teV9JXQMtXlw9DVykTAS
	 bV3W3rTf9P6FzOKSN4POmbpFvS8WXxQX9Lb5QJ/XW7aV3z+qZRSvrgRrDoQ67Ku7iKzxk
	 l6w6HjsYHg+b8HY81PmumGsi0jCuDDfoAuoDOfNKIXtOTypBf1hbnKHpJjOzDteBpVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j3fiOfbLtx6w9Q0X2T4wihf/66Cze0G2QuwZU+oSZoY=;
	b=3dXYkCKQFtbV/+ZfC0tIt7bN2eq9m3+saqG28JzQ1/XTtHLzNf+wIUkynxSwbSUeMr6U
	 4UYVTzr/U5TLmIfp5ASeE5VUTCriDdQc4QQW02iu7YmalaWNK2neq5gUbZqcgOLfmiIcJ
	 mGBkeEULOSx2e/a/BfR1VzqKvqtaiESnWy7jhsECgOrM25zstZw3gyzEjZGLGpDvh29Dg
	 1nGJzDVN0tTW/F8rNUIqjzkxbEE+2Bf+bKXXyz9+OIk5iNo48phZlHacTZVImDBlhp7MB
	 H4GCbOJz21Rgio56V606B0drp5omC2Pv74xrN/ew4lKZ7GMemZ3PELd8vAw+YKD2viw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruMvs4ls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39232606A32C;
	Thu, 19 Nov 2026 03:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruMvs4ls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6041F000C4;
	Thu, 19 Nov 2026 03:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058061;
	bh=j3fiOfbLtx6w9Q0X2T4wihf/66Cze0G2QuwZU+oSZoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruMvs4lsf1ViokLY7+Fr7dAtLxutr7PKmYzW/nv32y5VPS1QLn4X4rkk6A0+YmiEf
	 nulaj654Txr/PLf5vNxQG1ndfAlPgK+5TAJ+3kc6vPMPuFZ+jpwOeTicWCpOYqBTds
	 9ZSg1+YYWnZ45gTvhND4R6YIaKlGCRDPY04r507g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0349/1848] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Wed, 18 Nov 2026 15:39:47 +0100
Message-ID: <20261118145927.310043143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit cd49f62f4161c7340d9c9f53b67757575900c0bc ]

The length and offset is provided by the usb device, so it should be
validated.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 9f9d4b77ecf5d..1f42bc12cdc58 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -358,8 +358,24 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	/* process each rr3 encoded byte into an int */
 	sig_size = be16_to_cpu(rr3->irdata.sig_size);
+
+	/*
+	 * Note we are not checking if we are reading beyond the end of the
+	 * packet which was sent, and reading stale data. If the device
+	 * sends a packet which is short then we get garbage IR, but no
+	 * out of bounds read.
+	 */
+	if (sig_size > RR3_MAX_SIG_SIZE) {
+		dev_err(dev, "length %u is incorrect\n", sig_size);
+		return;
+	}
+
 	for (i = 0; i < sig_size; i++) {
 		offset = rr3->irdata.sigdata[i];
+		if (offset >= RR3_DRIVER_MAXLENS) {
+			dev_err(dev, "offset %u is incorrect\n", offset);
+			return;
+		}
 		val = get_unaligned_be16(&rr3->irdata.lens[offset]);
 
 		/* we should always get pulse/space/pulse/space samples */
-- 
2.53.0



