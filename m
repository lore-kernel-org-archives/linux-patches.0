Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208455C1DB;
	Thu, 17 Sep 2026 15:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659280; cv=none; b=MNqkqDpEgcKDOI/VtnFZRPCUTZpWrizxAv5mB/IiDP95dkuinaMeNGj+I0oI/4hTR2m3OzqQbut9B1ExBw94DgwoGEAt0mo8d8FkxW+pnwaF/Scw4PilCj8d+PHbMOvtwROUG+OTYEyVvxd4CEuTdPcRRn1YTm0fBU3pfATirvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659280; c=relaxed/simple;
	bh=YwH43v3e5DY3e2WEye0KTnpRjfrahn5NfbnNUBklaIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN99knWqlllBBnti3J+YUeSUKESB4i92cd5qIwQtdYvkfsop5/N4mWGfrI2SrwQQhZl7yRMKnZzn4JyTsRPkBpEe3XpyifwelfzrANVpvrpcuxyIT7MfChr2zIOPO8kGHLo1KQAtIdY9KsxvGWB9MkVsx2wxOaYRx6Owz4WLnM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtvwKVwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtvwKVwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2635F1F00899;
	Thu, 17 Sep 2026 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659273;
	bh=Z0HCyYERm4fn06wlUppnbvLbz7FvfU/b2LSz44WuAuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtvwKVwYaMxfjZEKNIEvZH01wOGubOh2lj/f66yLLGlJXAZyuV/sq2NK8Vn8FXa+O
	 9t1mjWd35FXZAXojRPu43zE9q0FoVGdppWGWZ1bqDjCxbm3OAAzSI9OFczAgLzBjXi
	 J0VsZW/NaFTh49yg5fceFtVl4kHYfMjwYvVIntXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 200/733] ipvs: fix reversed sequence option serialization
Date: Thu, 17 Sep 2026 16:08:28 +0100
Message-ID: <20260917151356.150863709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit b04578b74f2d3755548fe9e829e3b2a6c6f966a1 ]

hton_seq() expects the host-order source first and the unaligned
network-order destination second. The version 1 sync sender passes these
arguments in reverse for both sequence blocks. This leaves 24 bytes of the
kmalloc-backed message unwritten. It may disclose stale heap data and
replace the live connection sequence state with values read from the
buffer.

Pass the connection sequence state as the source and the message payload as
the destination for both blocks.

Fixes: 986a07579533 ("IPVS: Backup, Change sending to Version 1 format")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index ea5fdd4f4ce76..fff2f7d6069aa 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -747,9 +747,9 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
-		hton_seq((struct ip_vs_seq *)p, &cp->in_seq);
+		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
-		hton_seq((struct ip_vs_seq *)p, &cp->out_seq);
+		hton_seq(&cp->out_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
 	}
 	/* Handle pe data */
-- 
2.53.0



