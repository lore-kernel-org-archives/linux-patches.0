Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBE249D5AB;
	Thu, 17 Sep 2026 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668595; cv=none; b=KObGq5G7MpmJksnRJjpxETDefSXPYuoY0Xmd0N+l5vhw+rvQz63suepzJe9u+6Cs9mHSW38aRWJk8m7CN/HnCePZHT9oBVySCPvuZddMstLNAtIXTVqBEigudD47kuB9Km2fP8/yjFrEv/YxaqxvanvMOn1oQLX5djawoHDsAJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668595; c=relaxed/simple;
	bh=BU5wrvWhSu1IDYTJtAU1EOc5jEF0UM0iUy9w8oQA+pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRMY+b3EmbjodMQDPmGRYvCbf3/8HaQNRQhzE8bnAyusB9FcuODWdpCs8XvMIS7y8Nj7m5Qr6pgRv3I+RT/sJdZPyoPHH5wt+esAnZCjUJ7fu9bs19++LgGSGxP+fvKy4ERIrU8SZyMHFqcXPmDC6jRd1YwPiluQGRE1pojR8/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhyDja3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhyDja3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C5D1F000FF;
	Thu, 17 Sep 2026 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668594;
	bh=9TCtaIOJCo137hoA4mj1uBWzUvrQvo6kxZ44sknlrmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhyDja3drC95RNmS3KLbA5hFDNoZXKifpPuUCGwT2zlJtU3zo8EZtvgHXav66OLfp
	 +VPXTSK1hmddl3nd+41kB/rvm2A/cCPJlqbZfsAOGjjmojGBZTYSFRwer+F+j0yFL8
	 0xRqiPb6AqhlYjXRV8Ls2Bm5WHQ1C9XJldXevgDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0478/1102] drop_monitor: fix size calculations for 64-bit attributes
Date: Thu, 17 Sep 2026 16:07:01 +0100
Message-ID: <20260917151551.695925738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7089f7ab99c89f443c92d8fcc585e63f2727f0b3 ]

net_dm_packet_report_fill() and net_dm_hw_packet_report_fill() use
nla_put_u64_64bit() to append 64-bit attributes (NET_DM_ATTR_PC and
NET_DM_ATTR_TIMESTAMP).

On 32-bit architectures without CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
nla_put_u64_64bit() may append a 4-byte NET_DM_ATTR_PAD attribute for
64-bit alignment.

However, net_dm_packet_report_size() and net_dm_hw_packet_report_size()
used nla_total_size(sizeof(u64)) instead of nla_total_size_64bit(sizeof(u64)),
budgeting 12 bytes instead of up to 16 bytes.

This under-estimation of SKB size can lead to an skb_over_panic() when
__nla_reserve() or skb_put() is subsequently called.

Fix this by using nla_total_size_64bit(sizeof(u64)) in both size calculations.

Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260722141743.3266924-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index c880caa158a9f..e7e5f0830b54b 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -567,13 +567,13 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       /* NET_DM_ATTR_ORIGIN */
 	       nla_total_size(sizeof(u16)) +
 	       /* NET_DM_ATTR_PC */
-	       nla_total_size(sizeof(u64)) +
+	       nla_total_size_64bit(sizeof(u64)) +
 	       /* NET_DM_ATTR_SYMBOL */
 	       nla_total_size(NET_DM_MAX_SYMBOL_LEN + 1) +
 	       /* NET_DM_ATTR_IN_PORT */
 	       net_dm_in_port_size() +
 	       /* NET_DM_ATTR_TIMESTAMP */
-	       nla_total_size(sizeof(u64)) +
+	       nla_total_size_64bit(sizeof(u64)) +
 	       /* NET_DM_ATTR_ORIG_LEN */
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
@@ -769,7 +769,7 @@ net_dm_hw_packet_report_size(size_t payload_len,
 	       /* NET_DM_ATTR_FLOW_ACTION_COOKIE */
 	       net_dm_flow_action_cookie_size(hw_metadata) +
 	       /* NET_DM_ATTR_TIMESTAMP */
-	       nla_total_size(sizeof(u64)) +
+	       nla_total_size_64bit(sizeof(u64)) +
 	       /* NET_DM_ATTR_ORIG_LEN */
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
-- 
2.53.0



