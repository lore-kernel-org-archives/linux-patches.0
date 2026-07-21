Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94046D561;
	Tue, 21 Jul 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649322; cv=none; b=amv2BbYbAiaGjugSJyqub0jRaapbu22YQ6foFuTiiAoaWtDacJ4SCkJCp8ET/213Jj4oRCvFhjd5AiZt40KgS2yHXEF8Y0+v7SORPrLIbffqv4HTJpUQEgvLHEK32FfAuA6MqO61Lr0eRs2S/1U4H6tMkPLkd/Am1YAmD0p09Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649322; c=relaxed/simple;
	bh=B8KaL9fAmVLyZqS0Q9cPdUqtG43ulQW3sODgYqF22Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBKec0tMkOVmH0W+UcTvoU5ZuQpEWDs59DO/w98q+M+fm4lLMyfpgLwmWgE0X2hGwLJYa64pkLyIuK3TCyaExNn2k0SWcUxM4JlSJQMVYBCo8v+PxilHs4rSTvYibLlYeZ7QkVDNK+JITxJ+D8z/8bOZspWl4jVq+YJYowgEvGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yhs1f9bn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yhs1f9bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9537B1F000E9;
	Tue, 21 Jul 2026 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649321;
	bh=ceNBS2MMlea1MYC/TkbNBJ4WHfaOVWYvU9ns95AwnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yhs1f9bnyP6NejCmLrkDFXSQHfsqsCCVSvk2N17rUWOPw6CbXrxKqcPFw2sed4pJ8
	 msYRvztsfAgtD9XuZT/7P4TWdyr6TiL+UjrkekW130DSbNljDja5E0USCfXZ5Sw8d9
	 59t9la3o3c5VfIqzdkydgtF0eA55jIeqY5C0gLY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0533/2077] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Tue, 21 Jul 2026 17:03:26 +0200
Message-ID: <20260721152605.374827713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
 net/netfilter/nf_flow_table_path.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 9e88ea6a2eef78..a3e6b82f2f8e95 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -163,10 +163,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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



