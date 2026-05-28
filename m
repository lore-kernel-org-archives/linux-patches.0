Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE12F8EA1;
	Thu, 28 May 2026 19:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998353; cv=none; b=JSI1hEuhw+DrvG4aPe0qqZUgz0IOVVIFW0QE80794rKW6w2uosoO0fG+0n9/E+Et7BxmVRQ/3jWK8S+6seFX1GWQFc6aOzV+sXMLbWBBbFRNxlniyEzosxTLw29f92cOQxWIQoA4+YUlZRiTrX8OfP6FS5BOUGXtrOvFsyx9L9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998353; c=relaxed/simple;
	bh=tWw2tcwx0v/qiVBq7NjJlybKfvWD3iCHJF+mLSRpGGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo62AIfxTeyO2fdLH1InoUTCz6+zRSvAkOFgLpg9Ty0hdL/qrHRBwofPOIv40ha9KOOh+4e/WljeFn5Cv6fvreLIg781PXOSaRNZPdbZ4BWhmz2VufHeasbe5W5RpIJWeDMkaK9guWJpXLrip3vOxM2IAQs4elzvQeu+AhZvaYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXWmj9t2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXWmj9t2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FFC1F000E9;
	Thu, 28 May 2026 19:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998352;
	bh=eeg+gd8SVZtQ922/+yW6ZL9ejdEudXJCQ7W2qrIySzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXWmj9t2RVf7PPu2WZhE45QXD+BdpfvlIBX528RPr4stSSfgUs8TvQ2GFKP9CZTGx
	 dNFqqBnwFUB460HDicQjwiKP9/gJ+zYkgLwcIU26xEc6/HlPdEtKpgmxfqNuRgxKo4
	 1VUJbXEddQT6JW9xVQEhHKbgVajPjgtAzPoaOGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 143/461] batman-adv: tvlv: reject oversized TVLV packets
Date: Thu, 28 May 2026 21:44:32 +0200
Message-ID: <20260528194651.143590367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f50487e3566358b2b982b7801945e858c78ad9ab upstream.

batadv_tvlv_container_ogm_append() builds a TVLV packet section from
the tvlv.container_list. The total size of this section is computed by
batadv_tvlv_container_list_size(), which sums the sizes of all registered
containers.

The return type and accumulator in batadv_tvlv_container_list_size() were
u16. If the accumulated size exceeds U16_MAX, the value wraps around,
causing the subsequent allocation in batadv_tvlv_container_ogm_append()
to be undersized. The memcpy-style copy that follows would then write
beyond the end of the allocated buffer, corrupting kernel memory.

Fix this by widening the return type of batadv_tvlv_container_list_size()
to size_t. In batadv_tvlv_container_ogm_append(), check the computed length
against U16_MAX before proceeding, and bail out as if the allocation had
failed when the limit is exceeded.

Cc: stable@kernel.org
Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tvlv.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -13,6 +13,7 @@
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
 #include <linux/kref.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
@@ -160,10 +161,10 @@ batadv_tvlv_container_get(struct batadv_
  *
  * Return: size of all currently registered tvlv containers in bytes.
  */
-static u16 batadv_tvlv_container_list_size(struct batadv_priv *bat_priv)
+static size_t batadv_tvlv_container_list_size(struct batadv_priv *bat_priv)
 {
 	struct batadv_tvlv_container *tvlv;
-	u16 tvlv_len = 0;
+	size_t tvlv_len = 0;
 
 	lockdep_assert_held(&bat_priv->tvlv.container_list_lock);
 
@@ -316,13 +317,17 @@ int batadv_tvlv_container_ogm_append(str
 {
 	struct batadv_tvlv_container *tvlv;
 	struct batadv_tvlv_hdr *tvlv_hdr;
-	u16 tvlv_value_len;
+	size_t tvlv_value_len;
 	void *tvlv_value;
 	int tvlv_len_ret;
 	bool ret;
 
 	spin_lock_bh(&bat_priv->tvlv.container_list_lock);
 	tvlv_value_len = batadv_tvlv_container_list_size(bat_priv);
+	if (tvlv_value_len > U16_MAX) {
+		tvlv_len_ret = -E2BIG;
+		goto end;
+	}
 
 	ret = batadv_tvlv_realloc_packet_buff(packet_buff, packet_buff_len,
 					      packet_min_len, tvlv_value_len);


