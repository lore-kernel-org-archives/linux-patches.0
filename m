Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C134B697;
	Tue, 16 Dec 2025 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886400; cv=none; b=JsvIw3z/VW93QN41hjyMm+bKEnrMrxoniLJ/zgipKDylLKdVRorqp8DrCiTRaj0FHVXg/PrQhCLFqZUfSs4uwuQgwbY1yeUUzU6+R3O3TxCcXPhgRcCA7I8RsGvUyRORbrouhWfw9XEcQELkmuczy1nhkVJvXB9gskM5sGny3go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886400; c=relaxed/simple;
	bh=JfUJHatC7CxoiFPQ+7E2RRCdkspGwqBqwGP5rEx/Z3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLS0Y4z3Og/+gY8BdmeCwTGL6p9whRJLJ7Vr8FjBci2mG2sMkNzUN17vVF7aDye4CQyJpc826OYoLZEPgfA6pfLvZ6P8Qzx3/zBwmOAImAS3zYgO7WD+pxv76mW+vMYF/8PmJaf+3b5QZP39l5jSQ7xtW62122/iXM6e8UvKsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abegYo+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abegYo+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FDC4CEF1;
	Tue, 16 Dec 2025 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886400;
	bh=JfUJHatC7CxoiFPQ+7E2RRCdkspGwqBqwGP5rEx/Z3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abegYo+jhBxri6C2w/K/CXWYeeqNvIV3X4/mbKPImcG3Z7JVWBqnaxISA6NaIbV1p
	 rQM3ApLoSnrrvlrhe5JD6ypTqoCRODTzUihXHH2xBydoc3hfltbSBrZJr1j3vRgG1/
	 QN1sVDnTIOjoSGjX8S2QeUFs864QL9g3WoENAGZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 392/507] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Tue, 16 Dec 2025 12:13:53 +0100
Message-ID: <20251216111359.655663279@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 634f3853cc98d73bdec8918010ee29b06981583e ]

Add a sanity check to skip path discovery if the maximum number of
encapsulation is reached. While at it, check for underflow too.

Fixes: 26267bf9bb57 ("netfilter: flowtable: bridge vlan hardware offload and switchdev")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 225ff293cd500..3e1e8c6de9aa2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -141,12 +141,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.51.0



