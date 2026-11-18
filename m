Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028022;
	b=moPcKguZjUmK5KS6wr2s3kUti1wsr09c1Gn0oCAyOns6VF/ids+1wWNwH6jyUIHOEfMx
	 5VqduWut6SOjPbpTK+0mQiFs9bWWDQHfwxTxXgXR+sBcTt8R2/HviStyrhVHSNW77KoeD
	 clbdqoTh+b0YS/14FDrL3DAdRZZZIymhxTNoGGFElJqIe3JnJNQpCUgrfmzwakE5dhZOh
	 UKQZS2Sw2k0if/60131Qy6q0aZauxc6ojf+GBgWoYv+NmhtFQNUktQPxIBmidIhy3siQW
	 pvQjLX/5v7xQbh/gxv50ssuqfxVP5rSo0jv43XCl5HFq0D/LmIzPPO68bTAUKfvH14Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWopWaZJjQ5uW6hSnhGRwYmBfj7xgD339m12SK4wQQY=;
	b=OkUyBTyS87jWAqZRwVREVcDsG9Q+fqwlzhAA8EIWByGlP6cf3v+T35EWwjwVOHsrVMyM
	 vaUY//WEMfUcMdx0/kASxdcaWxJ0/p72UX8o01a2KJmZtR+HOHOmhjkypaatm/eOEpGnX
	 VACuOA3cbom5CPMTaE+ebLeT//QYyzx8VNPYoEJXvBGD8mxZoFZRiw8W0CIKYu9/J0mND
	 Pd/Xlch5A8yuhdGmMU2LosMeL8HqhRwNl7dP08Tx12dGIocbH6OB4COOq0nuZZ0l24S+u
	 29Y4kXakb0myRY8Za31tPkkRYSEwsZzZKqHxNqLL/DdOPYjJjaIO8stO0eLVwLYd94g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkJFWuvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87FE606A320;
	Wed, 18 Nov 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AkJFWuvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153601F000C4;
	Wed, 18 Nov 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028022;
	bh=RWopWaZJjQ5uW6hSnhGRwYmBfj7xgD339m12SK4wQQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AkJFWuvgwdn0e8S1uUy2txMOq1CEW1O73AzIj4wTQIt/ttk95ve/Z6JtE0mv4QBKZ
	 NC8KgPydBywnnxe3FbyzO7hZqk92euwCWPco0ENO9le0qudgqeN1QmE9+q4QtQ2r5l
	 bNRtGwemqoBfP2oTShJ/tC/EOpt0UWyo8EPao9dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1995/2151] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150234.397196689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 6d5a2cb0b7d6caf170d37ae7ac74738d592d2a05 ]

__netif_set_xps_queue() walks the OLD dev_maps to free its entries.  The
per-row trip count uses the NEW num_tc while the row stride uses the OLD
dev_maps->num_tc, so when dev->num_tc was raised without rebuilding the
XPS map the last row indexes attr_map[] past the allocation:

  BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1458/0x1ee8
  Read of size 8 at addr ffff000014f69458 by task insmod/112

The loop frees entries in dev_maps, so both the trip count and the stride
must come from dev_maps->num_tc.  The map is sized
XPS_CPU_DEV_MAPS_SIZE(old num_tc)/XPS_RXQ_DEV_MAPS_SIZE(old num_tc, ...),
so iterating the new (larger) num_tc reads past the end.

Fixes: 255c04a87f43 ("net: embed num_tc in the xps maps")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20261021155538.67867-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f7126ede6d6a5..356e9a3fc224d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2971,7 +2971,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



