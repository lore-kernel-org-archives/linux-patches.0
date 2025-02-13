Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC9026B09D;
	Thu, 13 Feb 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459113; cv=none; b=mNHhlXizKwxyyYmTVqGL4cNM/Zk/FrqHF/fca67Y4bUh9Mb5LbN50ufV+2OuBS6TbSf6QcRtv8gQRjsmWSn9ZgzcjGeKJPb7vaZ/jKqZGzOZFRcmnOF5ybceLMDq3noQbixVdkpwzbfLv2rovmjgOrAmtDNWwc2C1j/E1iBctco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459113; c=relaxed/simple;
	bh=sNxI/eJsvevmCjS4mRG3SH4X2kna/IL/2j3V/pipYoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9cGGnrdiYVvikFg5SO1z9sHhqURiT7AOVNiQ1fwSRhVFa8087Px58bnkhqxffvuDG0QyiDfB/WZZRD7eg6JCMsHtRHipOyAMtQVWqVJh+anpiRIXl6s1Mr2TNCmUfAyMkNcbRYr2i2sP8bU/n21fwaIydYZCK86BxRkPXB2+VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kikqbwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kikqbwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F898C4CED1;
	Thu, 13 Feb 2025 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459112;
	bh=sNxI/eJsvevmCjS4mRG3SH4X2kna/IL/2j3V/pipYoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kikqbwvgJ2YpDuoAoPFNpICKKA40hBxBJngRsM9ArMq02FgTN049dtb0HspFGoXs
	 EHIiyJoe4KFiCzkMUw995L40TVubqVSsEswnM99fkVg8UxAMdi4D4lI9Cy5lA9Y7mZ
	 inKZPO5FaPHYt89bBDs5obczCb1rpsiqyG4vdm2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Botha <joe@atomic.ac>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 139/443] net: sched: Fix truncation of offloaded action statistics
Date: Thu, 13 Feb 2025 15:25:04 +0100
Message-ID: <20250213142445.964700838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 811b8f534fd85e17077bd2ac0413bcd16cc8fb9b ]

In case of tc offload, when user space queries the kernel for tc action
statistics, tc will query the offloaded statistics from device drivers.
Among other statistics, drivers are expected to pass the number of
packets that hit the action since the last query as a 64-bit number.

Unfortunately, tc treats the number of packets as a 32-bit number,
leading to truncation and incorrect statistics when the number of
packets since the last query exceeds 0xffffffff:

$ tc -s filter show dev swp2 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  skip_sw
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device swp1) stolen
        index 1 ref 1 bind 1 installed 58 sec used 0 sec
        Action statistics:
        Sent 1133877034176 bytes 536959475 pkt (dropped 0, overlimits 0 requeues 0)
[...]

According to the above, 2111-byte packets were redirected which is
impossible as only 64-byte packets were transmitted and the MTU was
1500.

Fix by treating packets as a 64-bit number:

$ tc -s filter show dev swp2 ingress
filter protocol all pref 1 flower chain 0
filter protocol all pref 1 flower chain 0 handle 0x1
  skip_sw
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device swp1) stolen
        index 1 ref 1 bind 1 installed 61 sec used 0 sec
        Action statistics:
        Sent 1370624380864 bytes 21416005951 pkt (dropped 0, overlimits 0 requeues 0)
[...]

Which shows that only 64-byte packets were redirected (1370624380864 /
21416005951 = 64).

Fixes: 380407023526 ("net/sched: Enable netdev drivers to update statistics of offloaded actions")
Reported-by: Joe Botha <joe@atomic.ac>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250204123839.1151804-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1e6324f0d4efd..24e48af7e8f74 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -851,7 +851,7 @@ static inline int qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static inline void _bstats_update(struct gnet_stats_basic_sync *bstats,
-				  __u64 bytes, __u32 packets)
+				  __u64 bytes, __u64 packets)
 {
 	u64_stats_update_begin(&bstats->syncp);
 	u64_stats_add(&bstats->bytes, bytes);
-- 
2.39.5



