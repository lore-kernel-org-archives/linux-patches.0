Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056936;
	b=nNljzlvHpWOtxjl5Y8VmIlGGb3JdoCpeU7xp3j6KMErzE5zJq0+Lu3XqVbtRxqcXGRIy
	 y7eH1l6msT2PydfnYdt5D0OPMQXg+Eotd9gIiOMm1unYp1BGRZhecRTtA9ZQBMqIgbs6t
	 F/GYZ9HxWzmTLSucZFykK5mTAfQ/D11ny96xpTXT+Ct4Wp91zl82MLHl2k/srJQKdpEt4
	 vNfwNyYt+6Oeu/pGfKo6DPd27aA1TNqj14SSvSR0t5rsxOI7HUZNvANM+GUQGMxUBS7Oe
	 LVvfqbLIoMlGRrW17fKoxJRBMWkW1hMDCwOIrFHoY1jsg4A9+i3RXpSxZexYMdz+r8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SO4m8j3RUJDT/wRbgccXEzdGywkOMMHxPV4io9X5vfU=;
	b=h7hIY47esbyar3aebw/eZ8x7sCbxLgjNcXV3URwWZbZjWjC/q3hAArkoJZdXFtOv/fjd
	 uvQJzM6QRvxtU79oAywfixoagBBIbKC/MQiQi5VWEqqETHovBW810oJP6MN4l5JrhzhFS
	 qIEIphKrc5q2IdorJGoj56Vb39u8S72PUNgUXsWu+mDe5OyqXIGdQk4n3PE5PHmud84na
	 4GXEkrH1lggP6z6LxLLb8du6LUgI4F+6Mrs7g4KvYfmWDCjZh/sfYA1W/CcJ0EJSkNybL
	 KhTXo9kFEMHGJSlDf6+J6nn7lwp5H4WInAUZoJXpaTFwkjBC6DQ0Ni26UcZ3EHtQxPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7lo2eoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131DF606A32F;
	Thu, 19 Nov 2026 02:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7lo2eoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DB21F000C4;
	Thu, 19 Nov 2026 02:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056935;
	bh=SO4m8j3RUJDT/wRbgccXEzdGywkOMMHxPV4io9X5vfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7lo2eoDrVFc1YI8aRMjcFb/qrCdKZeIS+j75GNvPeH/ZqhyjVK8IJXDKIZCSQUhn
	 VcxxiAgiUfYV/QnKH/UrkjiyI99SpUc6BOw5YPddC8aVkS+Ww0mmRurwCk8YZTXUSV
	 +TrPXub+5tVNFnHEfet/wuGpwEfsQtrc4r8JUZzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2163/2214] blk-cgroup: fix root io.stat byte counts on 32-bit
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150136.963148608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e8546adfce2b..a7a6caa9a3aee 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -894,11 +894,11 @@ static void blkcg_fill_root_iostats(void)
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



