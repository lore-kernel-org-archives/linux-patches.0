Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF9223E342;
	Mon, 13 Apr 2026 16:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098774; cv=none; b=V4DAbDzUEn5IyjgM8ALgKXCK2WfgYkLIlXDYD8tCP31VCdoBOSNCzTWRCpWTxrC18Yj9jhCCSaRQhpvsnvAUbz/ZSn4U40Cv5nbmAY5s8nhpB1nEkOMzW0/9Z5/DLnjUi+QbnEZTDMwCr7/NmGVsFdHHALVVxl/JBCHeNe7QxxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098774; c=relaxed/simple;
	bh=EdeTsZT2d3LEfFQszP5dClnpjz6wOLxt/xbmUrpcU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4oI+PnQoRVeZbbN7PJDOmcN7VT4OoK3NZr+lHuqPrKxFO7yG96jwwK/k2Z7ktrbpV1RrasvMJvB5BrLHhT1hkD52JA3SMZKMPpBIipr97tu6AzFEqACyK60MLZpjHWvLePkxLanqiuQupPbuhiVXbK4RIkB0NaIlX6sVIhtv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KelD3RUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KelD3RUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B0CC2BCAF;
	Mon, 13 Apr 2026 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098774;
	bh=EdeTsZT2d3LEfFQszP5dClnpjz6wOLxt/xbmUrpcU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KelD3RUzL7PTNUTOUxv55Sbfkvbc3e+ZooZKnZotqY2EHBCI46bPJOc0oPR1at6PC
	 0AprrSRK59rKN6Mdl7m2b8Ri1Sa7wDjLKrKjsWepzt3Sw80UKJid0rWqZtaZnBTGs6
	 zNnVhIn/euLb/pVVtNaUOEQLpX7JcNWaLXLYmig4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/491] i40e: fix src IP mask checks and memcpy argument names in cloud filter
Date: Mon, 13 Apr 2026 17:55:29 +0200
Message-ID: <20260413155822.189382750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e809085f492842ce7a519c9ef72d40f4bca89c13 ]

Fix following issues in the IPv4 and IPv6 cloud filter handling logic in
both the add and delete paths:

- The source-IP mask check incorrectly compares mask.src_ip[0] against
  tcf.dst_ip[0]. Update it to compare against tcf.src_ip[0]. This likely
  goes unnoticed because the check is in an "else if" path that only
  executes when dst_ip is not set, most cloud filter use cases focus on
  destination-IP matching, and the buggy condition can accidentally
  evaluate true in some cases.

- memcpy() for the IPv4 source address incorrectly uses
  ARRAY_SIZE(tcf.dst_ip) instead of ARRAY_SIZE(tcf.src_ip), although
  both arrays are the same size.

- The IPv4 memcpy operations used ARRAY_SIZE(tcf.dst_ip) and ARRAY_SIZE
  (tcf.src_ip), Update these to use sizeof(cfilter->ip.v4.dst_ip) and
  sizeof(cfilter->ip.v4.src_ip) to ensure correct and explicit copy size.

- In the IPv6 delete path, memcmp() uses sizeof(src_ip6) when comparing
  dst_ip6 fields. Replace this with sizeof(dst_ip6) to make the intent
  explicit, even though both fields are struct in6_addr.

Fixes: e284fc280473 ("i40e: Add and delete cloud filter")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 3ddb712b732d5..014734ea71ff3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3655,10 +3655,10 @@ static int i40e_vc_del_cloud_filter(struct i40e_vf *vf, u8 *msg)
 		cfilter.n_proto = ETH_P_IP;
 		if (mask.dst_ip[0] & tcf.dst_ip[0])
 			memcpy(&cfilter.ip.v4.dst_ip, tcf.dst_ip,
-			       ARRAY_SIZE(tcf.dst_ip));
-		else if (mask.src_ip[0] & tcf.dst_ip[0])
+			       sizeof(cfilter.ip.v4.dst_ip));
+		else if (mask.src_ip[0] & tcf.src_ip[0])
 			memcpy(&cfilter.ip.v4.src_ip, tcf.src_ip,
-			       ARRAY_SIZE(tcf.dst_ip));
+			       sizeof(cfilter.ip.v4.src_ip));
 		break;
 	case VIRTCHNL_TCP_V6_FLOW:
 		cfilter.n_proto = ETH_P_IPV6;
@@ -3713,7 +3713,7 @@ static int i40e_vc_del_cloud_filter(struct i40e_vf *vf, u8 *msg)
 		/* for ipv6, mask is set for all sixteen bytes (4 words) */
 		if (cfilter.n_proto == ETH_P_IPV6 && mask.dst_ip[3])
 			if (memcmp(&cfilter.ip.v6.dst_ip6, &cf->ip.v6.dst_ip6,
-				   sizeof(cfilter.ip.v6.src_ip6)))
+				   sizeof(cfilter.ip.v6.dst_ip6)))
 				continue;
 		if (mask.vlan_id)
 			if (cfilter.vlan_id != cf->vlan_id)
@@ -3799,10 +3799,10 @@ static int i40e_vc_add_cloud_filter(struct i40e_vf *vf, u8 *msg)
 		cfilter->n_proto = ETH_P_IP;
 		if (mask.dst_ip[0] & tcf.dst_ip[0])
 			memcpy(&cfilter->ip.v4.dst_ip, tcf.dst_ip,
-			       ARRAY_SIZE(tcf.dst_ip));
-		else if (mask.src_ip[0] & tcf.dst_ip[0])
+			       sizeof(cfilter->ip.v4.dst_ip));
+		else if (mask.src_ip[0] & tcf.src_ip[0])
 			memcpy(&cfilter->ip.v4.src_ip, tcf.src_ip,
-			       ARRAY_SIZE(tcf.dst_ip));
+			       sizeof(cfilter->ip.v4.src_ip));
 		break;
 	case VIRTCHNL_TCP_V6_FLOW:
 		cfilter->n_proto = ETH_P_IPV6;
-- 
2.51.0



