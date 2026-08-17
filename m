Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6275439F77;
	Mon, 17 Aug 2026 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975938; cv=none; b=oGBjsTOXRKeSC/JfcZnTDR28wjQl/VfgrldzSlnOX7GoC5XA89bPb8nednO24rb9nO2d7sFndVxjkeMvPg4mAmFRfmiwvpzUD4jR4GDqvP848ZMZKJl+4uaSD7amH153EI6wqrayU2rGM4y+ITEJLdp0f9Iyd5Fac8Gm487c/Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975938; c=relaxed/simple;
	bh=lJLGbTddFI0izBnN8z/D2B7C7b8NzCoojHguMyYIR24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGPNgr4hrH11zz1+NXtC7AecauC/R4Y+m/GatSCO2VW1gN2Rm3jDHTN4yGof2PaMlW9Cv7MS3Ke6KgQVQ0tRJgpJTD0mJ6mK4l3DRfGPzVUoaM7yluH0fkSNmllbJfxhEmgqSFrJAf6CjqnO7eHS+5H6IRDZV3JzrGjPq8bbrOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydIZLyGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydIZLyGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050311F000E9;
	Mon, 17 Aug 2026 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975936;
	bh=GXDz3GMzTI7xZyXNFf/uiyxbmp6l+Oagu5nB78w3fXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydIZLyGmte0CgkoLYaW1rOgawS69oNn8UFgGdRGrJoa/FXi4oGGh8HUpVxWUdbC1j
	 4yiTlxT05VQgUtwbRbex9+7Z6tX6c9p0f+gKZ4jCojbZyZDY8LYVrfjwcKVsKzSTfu
	 PCUMU0ifN0XkblpJOVi5PrbbwpzTTjPQChS9tHPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 193/389] net: bridge: vlan: fix global vlan option range dumping
Date: Mon, 17 Aug 2026 15:30:32 +0200
Message-ID: <20260817132546.732187885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 6c4110d9f499e2170fbb36723b0a5f50a8116304 upstream.

When global vlan options are equal sequentially we compress them in a
range to save space and reduce processing time. In order to have the
proper range end id we need to update range_end if the options are equal
otherwise we get ranges with the same end vlan id as the start.

Fixes: 743a53d9636a ("net: bridge: vlan: add support for dumping global vlan options")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20210810092139.11700-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1839,7 +1839,7 @@ static int br_vlan_dump_dev(const struct
 
 		if (dump_global) {
 			if (br_vlan_global_opts_can_enter_range(v, range_end))
-				continue;
+				goto update_end;
 			if (!br_vlan_global_opts_fill(skb, range_start->vid,
 						      range_end->vid,
 						      range_start)) {
@@ -1865,6 +1865,7 @@ static int br_vlan_dump_dev(const struct
 
 			range_start = v;
 		}
+update_end:
 		range_end = v;
 	}
 


