Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB65339844;
	Thu,  2 Jul 2026 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009970; cv=none; b=jK3PvCxZJ0vWHnA+pEC50juDO4FB9LDq1BuKAlQCI8WJYyLI3BGxI996DX6omC13JkFmSsXcQqymviRbIt/RXVCzFuxdDNC0pFdz8Ow0BapffrD3XHF/TOI5Uv3gAiHdNMDbFi3qZkUOBdXoc3VJsB3wTcVLwNVFweJmqFJ9kU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009970; c=relaxed/simple;
	bh=u6mSSgVIFRd23dPU4u6xDHvYF9zAIP87BkK8pFoMFzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeQkOZCPpJWzqaMKDOcuKTVJKoWXJBw+OnGcrEBDF2HISBzGxnUQ9+eA55WRe4VUwictRsqCwBVJqvOazXUReyy4yp/relTnDT5zn1eWR21W+4+Lh8aSkD/FoX7urz3kV6qZuBm7geSLuV/mhjqjOMSO4fwQ8uYaZ81AfFX8hjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7kW9JVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7kW9JVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E25D1F00A3A;
	Thu,  2 Jul 2026 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009969;
	bh=lSbvrSMGLkTKhrm+IncKkYQryWzHWPEJEtpDn7/P484=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7kW9JVoaujH3WE/gUi22vzzjrq23EOZPynlNoCtx3ic7zJs+pvd4MpCbCfPY3Erf
	 ueEq0LYFW9XQKTEECZeTkySZ8W9SLzUxbkmVojw53CdbPdHcHCkZnUIvF3N3aRMBQk
	 TB3+8Dl8cjYQdAl5ubjIQKSn6S+0gpL7BmIfDtkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/129] batman-adv: tt: prevent TVLV entry number overflow
Date: Thu,  2 Jul 2026 18:18:56 +0200
Message-ID: <20260702155112.519702070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 99d9958fa10fb684b2a8e2c48a8d704122721420 upstream.

The helpers to prepare the buffers for the local and global TT based
replies are trying to sum up all TT entries which can be found for each
VLAN. In theory, this sum can be too big for an u16 and therefore overflow.
A too small buffer would then be allocated for the TVLV.

The too small buffer will be handled gracefully by
batadv_tt_tvlv_generate() and is not causing a buffer overflow - just a
truncated reply. But this overflow shouldn't have happened in the first and
the too small buffer should never have been allocated when an overflow was
detected.

Cc: stable@kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index e0503c8f24c353..53d2aadcafa154 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -850,11 +850,18 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	u16 total_entries = 0;
 	u8 *tt_change_ptr;
 	int vlan_entries;
+	u16 sum_entries;
 
 	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
-		total_entries += vlan_entries;
+
+		if (check_add_overflow(vlan_entries, total_entries, &sum_entries)) {
+			*tt_len = 0;
+			goto out;
+		}
+
+		total_entries = sum_entries;
 		num_vlan++;
 	}
 
@@ -941,15 +948,22 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	struct batadv_softif_vlan *vlan;
 	size_t change_offset;
 	u16 num_vlan = 0;
-	u16 vlan_entries = 0;
 	u16 total_entries = 0;
 	u16 tvlv_len;
 	u8 *tt_change_ptr;
+	int vlan_entries;
+	u16 sum_entries;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry(vlan, &bat_priv->softif_vlan_list, list) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
-		total_entries += vlan_entries;
+
+		if (check_add_overflow(vlan_entries, total_entries, &sum_entries)) {
+			tvlv_len = 0;
+			goto out;
+		}
+
+		total_entries = sum_entries;
 		num_vlan++;
 	}
 
-- 
2.53.0



