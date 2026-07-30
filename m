Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9FC43F8A6;
	Thu, 30 Jul 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422188; cv=none; b=e/Rsp8ai49RTRR5vxgi7LhQLxChz9uBA/qrtaJrNeuFpD3wf/UZpqPr0NfAq0fYkC3+cEoy9BiYtVOaOwYkODqqjC+hevC44lJ6uvXVB0OMeyOUGgWaT287/+UpV71y1hihWFL1SB5JQ6Tbpr0bOdiAyVrcuEWupfeaqYW/ldOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422188; c=relaxed/simple;
	bh=Y3HTAL5BGw/+cpy3DbRa8sMNsNT8AZQtAnaww5rntrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyX22zKmHlRJWeGH0HZyIbZn7EoS38thUwE99o9v8+o9ISlnvzgR+q43C0lXQHirOROuG/B0UqwQCE5B94TeNIbtgIPIuyo1YjI3txG7nz51Lm5Vkwz+VmFXx6IDMfz6MI4WZSD4SOa7W7ZdiPWjv01xQXSlXiNKksytkJn40pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjItNCT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjItNCT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6561F00A3A;
	Thu, 30 Jul 2026 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422187;
	bh=VqDQHrQw8hymQoCX/bVreU4HQJOU8dlGD9cx9ergKT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjItNCT+SYODiCJ1TxlGdqa6bqqthgvzV3imIZcBLWBTzIEc9mJBQUihNQaJwc4qo
	 MRKKq3CaM2E0Wug87B3JpCyHwOueTIfkBUfuuYsWSvcgLc3PwXPWDLQ+51u9DLTm79
	 YjCPr6tEZ+leK28fIvtfRU0jlw9UqvrS/3JGbz/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 353/744] drop_monitor: fix size calculations for 64-bit attributes
Date: Thu, 30 Jul 2026 16:10:26 +0200
Message-ID: <20260730141451.789044193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index afcd8ba411b6ac..61d6679b074eef 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -566,13 +566,13 @@ static size_t net_dm_packet_report_size(size_t payload_len)
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
@@ -766,7 +766,7 @@ net_dm_hw_packet_report_size(size_t payload_len,
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



