Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215888;
	b=fdSQgfz9jz88i11j7g59Ku1b5Pd3v9VPOZb9e15PMwVKCm/vYpOSxm7UUwtbgPIGAMth
	 qvgMm9ai+OuM9kzB4ZLSSA2zXjtcIUfQLfbcsvgV+lMn/0pGCxVUihyI/pCfn6htumxcE
	 KJ5dRUYLNyBvmuAS6kNmUY5islbZ9JqtBDUvG4S6B7xDrUmwQ8QwJO2Wh18myHKOyDtkw
	 3YVW0C7ksK8CKybUAWx1jz+bagA/85CcfhYTcJzWNc+w+i4lyiLXE7e4mptjbvslJTqzm
	 1d5u2WBtimTfG0/N+wwIy9ps9HDNiSchbx8Yc4xpjX+UVoidj2r4fNMZQTUF7TTP8YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6kJufbXryyaPkeEJ9aSTkwlqChtsvSi1GZjFhTaIMCI=;
	b=fYknNbN1ykzZdUZPhhgUZttQY6D06OCPxs9YfoGE57snbOehCA7/gQ3ZZz05ej9/rcl9
	 qitm3Tyh01GU0EnifRIxSOFTDLhhe8hV0Nf9MsGv7+Qe/YKdQ0fJbO7EX3eGB/mBPFqAr
	 OkOol+hY2n+BsjNrxkuPhPvfIfFCJFheYbvShu5H+7sc3qX4yHAIGqLkIBKLyTBh1pVCm
	 NMc+7FKeXIcoAL44xzGyHM/R2qPg/EAevyiUREJ4DPS4w8BMWbjOPGxGWZnkasUHhYckG
	 2HXc5xHobp5LvM8o44sJvtJbZRNHyW85imEvycsFwDQ5NMGIZYSeACb4LF7Aw0cR4qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQqQV5Zj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2514606A31A;
	Wed, 28 Oct 2026 19:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQqQV5Zj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4A11F01825;
	Wed, 28 Oct 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215887;
	bh=6kJufbXryyaPkeEJ9aSTkwlqChtsvSi1GZjFhTaIMCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQqQV5ZjC+dFbRSHoPDDIIj2+NdWX7QZ2otfW8VJRQyQtnDQmUcdYnVYnjkxNgSFB
	 Gj/PjxKS4BuSe7HL5sA/DQ6/QsCux583nMMaEsKlYfOcKDdflxVdj7Dry5D3rgxZgc
	 Ck/Ipq2kDtCHSsNjIunX33t1glHVw71cKwjknqe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1323/1887] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Wed, 28 Oct 2026 17:56:59 +0100
Message-ID: <20261028170529.535210883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit e052f920773b73be49eb4d8702a9f85de7464363 ]

The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
decrement still happens and wraps it to 255. The break only leaves
the inner switch -- a later path entry can set info->indev back to
a real device, and we end up returning with num_encaps == 255.

nft_dev_forward_path() then walks info.encap[] (size 2) up to
num_encaps, which means an OOB stack read and a bogus count copied
into the route descriptor.

Should only happen on a malformed bridge path stack, hence the WARN,
but worth handling sanely. Move the decrement out of the WARN.

[ While at this, remove the WARN_ON_ONCE since this can only happen
  with a buggy bridge path stack --pablo ].

Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 7cffa4be67b2a..449d4b4725d2d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -149,10 +149,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+				if (info->num_encaps == 0) {
 					info->indev = NULL;
 					break;
 				}
+				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.53.0



