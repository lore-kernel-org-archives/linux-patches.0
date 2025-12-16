Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45039A105;
	Tue, 16 Dec 2025 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888377; cv=none; b=uEFw3MTXoZ6xvU6BkJ+XvKIVmBYAeHaq6sDbCzWFQkN9qWKfTaBvBetu8SiEGMEJHnt2wgW5hcvmHeU41ovaetDondQMbfRgX2t8uXPcP1734kh+Cs8GQpZgA62UfmL+uJzZsHuJb6bu+YZWgefa6TJn0Xjl1PBkgaZ+61csBkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888377; c=relaxed/simple;
	bh=d8gPHcn8DNqzpoOBPUJQNol23W6T/ofPEC4UI+oIN5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrCVcCixj/BPEpboVsmsRUd0hG8cfvqlYDIpJPzdeghzREJcOfv2K7ON1RXzguB/VJEcNS/tC8q99kfxhylAThPZ7+o24/gv469gkvkO7ymlPjOCdy1rvBkmJLoMun0sVYbXnHVTMSeIhCKJvtOsVJzIIAtrHeVMMQTQz9yn3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctTRcv9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctTRcv9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A929C4CEF1;
	Tue, 16 Dec 2025 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888377;
	bh=d8gPHcn8DNqzpoOBPUJQNol23W6T/ofPEC4UI+oIN5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctTRcv9ibtuSm7VQXwiYEKLwL5ZO/n+Bgf+Zwd8D2Hu+DbacuPcejyOdW/IQJHeQK
	 o7JKfQzbBdWoNyfez1FMwe4UFtyEWT/ValaHbcfGVOc76bDwsFCj2+ihOtXjTJGSYD
	 ncYto62mSMQKLQ3H+Dsq5To9vh4tZCcm76jUUf7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 516/614] net: dsa: b53: fix CPU port unicast ARL entries for BCM5325/65
Date: Tue, 16 Dec 2025 12:14:43 +0100
Message-ID: <20251216111420.064096298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 85132103f700b1340fc17df8a981509d17bf4872 ]

On BCM5325 and BCM5365, unicast ARL entries use 8 as the value for the
CPU port, so we need to translate it to/from 5 as used for the CPU port
at most other places.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251128080625.27181-5-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_priv.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 127ce7f6b16ba..80e7dd6169b47 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -344,12 +344,14 @@ static inline void b53_arl_to_entry_25(struct b53_arl_entry *ent,
 				       u64 mac_vid)
 {
 	memset(ent, 0, sizeof(*ent));
-	ent->port = (mac_vid >> ARLTBL_DATA_PORT_ID_S_25) &
-		     ARLTBL_DATA_PORT_ID_MASK_25;
 	ent->is_valid = !!(mac_vid & ARLTBL_VALID_25);
 	ent->is_age = !!(mac_vid & ARLTBL_AGE_25);
 	ent->is_static = !!(mac_vid & ARLTBL_STATIC_25);
 	u64_to_ether_addr(mac_vid, ent->mac);
+	ent->port = (mac_vid >> ARLTBL_DATA_PORT_ID_S_25) &
+		     ARLTBL_DATA_PORT_ID_MASK_25;
+	if (is_unicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT)
+		ent->port = B53_CPU_PORT_25;
 	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
 }
 
@@ -383,8 +385,11 @@ static inline void b53_arl_from_entry_25(u64 *mac_vid,
 					 const struct b53_arl_entry *ent)
 {
 	*mac_vid = ether_addr_to_u64(ent->mac);
-	*mac_vid |= (u64)(ent->port & ARLTBL_DATA_PORT_ID_MASK_25) <<
-			  ARLTBL_DATA_PORT_ID_S_25;
+	if (is_unicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT_25)
+		*mac_vid |= (u64)B53_CPU_PORT << ARLTBL_DATA_PORT_ID_S_25;
+	else
+		*mac_vid |= (u64)(ent->port & ARLTBL_DATA_PORT_ID_MASK_25) <<
+				  ARLTBL_DATA_PORT_ID_S_25;
 	*mac_vid |= (u64)(ent->vid & ARLTBL_VID_MASK_25) <<
 			  ARLTBL_VID_S_65;
 	if (ent->is_valid)
-- 
2.51.0



