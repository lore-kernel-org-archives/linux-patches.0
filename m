Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0212566F7;
	Tue, 13 Oct 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894850; cv=none; b=OkfkQQmf/cy2Nc1fSTsaegNILC5BJ23uopuWgMt8dopsDx+uiwCOrHqxwHHWyhhTKPsdUeZhPNF+DnvdPAsLp/hJnvGBrwM9uYbgoUwuybwowzkBRsnb+aUeaILpfr0PxZaTLt92xJwtjiVOLIJ2eJKYpxBqFA6wiuMDSKAdP7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894850; c=relaxed/simple;
	bh=KGCS9Y9KHUnm0H0/ylSZ/E8H0Oy5/1j/T6tIXt8a2Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhNaKlnIr2yUdquT7160dj6IYuaKFleiJFXJdWYe9DO+oHOSMFnRK757DUpo0A5ZsP+DB92H3QGej5OQdQyIy0z9B3qExGvcb/6N4dNhoyW/y2vUKzGS8/h9SjZdOzGZj/NoEIOVckGTanouaQSTw/y1k1Vd21SZN9FwSwzecKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvATqqn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvATqqn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE0F1F000FF;
	Tue, 13 Oct 2026 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894848;
	bh=g7DQ5jg1L52useh+mV8oOtv6NyH9OdeMWbcSQm6+cwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvATqqn8aeH5yegEWFOKy/zUnLU4OF0m6GN43QG2Zp4Arc/9DPHf3YyVzLk/MyIly
	 rLqyMp+MMej3Cylnw2PoVbeMphIs1bBTGyVRY5iYntH3FFbX5jIjV/cjfvQul+Svwi
	 SCu9j9k7Zv3JruSFv4edcjXY6eBcEPBNGeCkG35g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/497] net: systemport: Fix buffer overflow in bcm_sysport_get_stats()
Date: Tue, 13 Oct 2026 13:34:03 +0200
Message-ID: <20261013112909.690443702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit eb7b84af0ec5c71b4920e999611b466b3784496c ]

When running on SYSTEMPORT Lite, certain statistics are unsupported and
skipped during bcm_sysport_get_stats(). The variable 'j' tracks the
compacted index into the destination data buffer, whereas 'i' iterates
over all elements in bcm_sysport_gstrings_stats.

Because the buffer allocated by ethtool is sized only according to
bcm_sysport_get_sset_count(), storing values at data[i] instead of
data[j] writes past the allocated array bounds, leading to memory
corruption.

Fix this by writing to data[j] instead of data[i].

Fixes: 10377ba7673d ("net: systemport: Support 64bit statistics")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-2-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 2b784ced06451..c0af40cdfd165 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -516,10 +516,10 @@ static void bcm_sysport_get_stats(struct net_device *dev,
 		    s->type == BCM_SYSPORT_STAT_NETDEV64) {
 			do {
 				start = u64_stats_fetch_begin(syncp);
-				data[i] = *(u64 *)p;
+				data[j] = *(u64 *)p;
 			} while (u64_stats_fetch_retry(syncp, start));
 		} else
-			data[i] = *(u32 *)p;
+			data[j] = *(u32 *)p;
 		j++;
 	}
 
-- 
2.53.0



