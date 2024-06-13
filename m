Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F9E143C5D;
	Thu, 13 Jun 2024 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279119; cv=none; b=jwEpY+9sKVCQd+QQeBMU6A+bbi6XW3l8nqp70mG55nUuhtYpGlPVyyB5QhBs8NDt/dWncI8NZJDdxingJwZkFrjetJsLo81X6K2W+3bPIUK0f2x9JaYeKlJPwxovl9oKetfrQTtGsal1IJ/EpkZ/gWHyXMtqCp/LlZtA2kJbBlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279119; c=relaxed/simple;
	bh=YUNwVrwJ0H7mqUol6heXPf3ThZGQ0XfIeywqm1Bvp44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4/2onBVvMaiVMBkTjv8HJVSO6AED/bYnhTByZtQOaALG/JMvmEHnTS0w9CcY2JxAmZgl0xNyGbzOmcY7RD695rl92+UK5j2axn2on2LAYeRKFrvqN2Y3dw2CXFvqTLKc44e7hUui6/EebZcNPu2dLUMgmVTfQqKoUtO5/EGgt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z42/m0ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z42/m0ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72F2C2BBFC;
	Thu, 13 Jun 2024 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279119;
	bh=YUNwVrwJ0H7mqUol6heXPf3ThZGQ0XfIeywqm1Bvp44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z42/m0ZRV82pOwSn3M1VDtrnzDCUqGiWvZI2FfXap/AhmiPWX1SwsSjRuJI7JPPOh
	 dAoNiSmDVqG8s7WGB4t0m2wKwQh2dOfPanQ2Wqm4a/kVLKsCrBiEOAH0/klfl4mB1/
	 ssXrra9pRnfpnZMfaZni7VuUqvUsM8kNcQKAdL3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang DENG <qingfang.deng@siflower.com.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 150/213] neighbour: fix unaligned access to pneigh_entry
Date: Thu, 13 Jun 2024 13:33:18 +0200
Message-ID: <20240613113233.774872229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang DENG <qingfang.deng@siflower.com.cn>

commit ed779fe4c9b5a20b4ab4fd6f3e19807445bb78c7 upstream.

After the blamed commit, the member key is longer 4-byte aligned. On
platforms that do not support unaligned access, e.g., MIPS32R2 with
unaligned_action set to 1, this will trigger a crash when accessing
an IPv6 pneigh_entry, as the key is cast to an in6_addr pointer.

Change the type of the key to u32 to make it aligned.

Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
Link: https://lore.kernel.org/r/20230601015432.159066-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -172,7 +172,7 @@ struct pneigh_entry {
 	possible_net_t		net;
 	struct net_device	*dev;
 	u8			flags;
-	u8			key[0];
+	u32			key[0];
 };
 
 /*


