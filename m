Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050646;
	b=g8rCYqDBMTk4wyB4IEMaAgcBPzl6D/W9uS6isLkGjBguTz6f1MO/2ntMl4qrUgiQCSyR
	 KZDduixB5kglkY8rb0be6OckqScjlpXk4025VsjNYYz3HqJLA2iCufNWsMIZyyTlvYJUa
	 fPiDZUDOKOrFkh5bkLv1hSpPoQyDzJPVrVmvFwEMa2qyQSVpq3i/ElPprS0Vv8lpRO51F
	 xCdkYGK7FU/Ar7ovsxwASvy7G3MHfka3t/aqRnuHqI/YM7ELnbB9AAMryHwXQnZHRbnaJ
	 m/JoBJ9BC4bWY13R8NHWbsFBYVTYZatcK+QXoFCvuQkYvgc9ln9th0Z7dSYn3GtF7Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GSmH3TpbAbfOxJXL0tDZUevjtRAck86uHTo8cYad0zI=;
	b=j4hfOa0oczcALEV6c5nqHPsit2T7zvWOzN442iC3bSHbQHpn7NOUxQI5ps3W/hQEOgWh
	 wwmkDTPTTdEBGvR1HT3hixkSIJOs604VxKXJX87QTIPY9gcT3zMgptQXTl6cTGadwWRsQ
	 gxypLMl07eTeAoLzkehQgXNVxgWEDMuS977ONakWBmRelszYuLhl05sv3ZFvYQhmUKZFd
	 EvHemQ/vJbUK4Usd9n01TSVGYVluc6bsZb9Bq3nbu37BjnKhkI7Ud539YRX7tXB9f0+dY
	 jldM2qI2zjDNV5kpnSgwWekiCjVso4w+JHsDOmPoUJ5GdDvlXnE1hbeHIIAemgRutQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1+SafUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3A606A31C;
	Thu, 19 Nov 2026 01:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1+SafUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE51F000C5;
	Thu, 19 Nov 2026 01:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050646;
	bh=GSmH3TpbAbfOxJXL0tDZUevjtRAck86uHTo8cYad0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1+SafUiPv+hyE4+AKxsaSaf7Fb3GmI3onbH7dnk+gO/sNcuMgd5ashsE0so/137N
	 8ih/OgoJf2Zk/Y+P58Mennm1kRD/RFzYQrkr5icdwVddnv5I9knWUWUaddkhGVpgQe
	 z3oX1C4W2KTiS2neXKbRqLO2N2smlao8/371ufAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2782/2857] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150341.775045258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e335b853d919f2c6246ca0993115285742a2acc1 ]

blkcg_fill_root_iostats() shifts the unsigned long sector counts by 9
before adding them to the u64 byte counts, so on 32-bit the contribution
of a CPU wraps every 4GB. Widen before the shift.

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-14-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4c86003bf4445..b65aaf585f04d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -937,11 +937,11 @@ static void blkcg_fill_root_iostats(void)
 				cpu_dkstats->ios[STAT_DISCARD];
 			// convert sectors to bytes
 			tmp.bytes[BLKG_IOSTAT_READ] +=
-				cpu_dkstats->sectors[STAT_READ] << 9;
+				(u64)cpu_dkstats->sectors[STAT_READ] << 9;
 			tmp.bytes[BLKG_IOSTAT_WRITE] +=
-				cpu_dkstats->sectors[STAT_WRITE] << 9;
+				(u64)cpu_dkstats->sectors[STAT_WRITE] << 9;
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
-				cpu_dkstats->sectors[STAT_DISCARD] << 9;
+				(u64)cpu_dkstats->sectors[STAT_DISCARD] << 9;
 		}
 
 		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
-- 
2.53.0



