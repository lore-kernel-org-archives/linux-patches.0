Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4ED13777E;
	Tue, 16 Jun 2026 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635357; cv=none; b=ESlB3RP4mb0Mx217gvBEbp4j66YiOaj/RZz1ZkJ9wdUADwt2HvOpheoAH+m1sY2zbfJ5lwTotgt+9KekqUVdEOsQVBXILRfzT3BKymgXYbvnrckyGJxZD6ZRvIDGX56aI8eppp6i914yZjOJMiPU31qZnqkQNQosTPZYEi8+8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635357; c=relaxed/simple;
	bh=jyCzQbCRrPfi9LTFtc7yCT2773H2bczZjN1EmwFH81A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQwABRrZKDpII2YMUc58tF9I3vMuMWUT111LzxTh3UCMKmxtvNbaumq7i9nOtECWZougjPMjX1gXlvIEm1VF4Q89G4qYP/T8kIohmCoyc1pXoqOQm8pLJWwR3nAkf00RwpeA/SD4VtA/vdN5xK8TcK3eTem8SHvl/ZJq75dIPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFtki9dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFtki9dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942141F000E9;
	Tue, 16 Jun 2026 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635356;
	bh=rdQUSzBIpN0pAJz/IaBW9JuIYROtMr6kRwvN6PVsIRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFtki9dzfnqrQVR20E7HJUcBwISmQQDxOa4FOESxfPTwlFER587ZMnLWcLAg71EjW
	 l5lC1lGAiazEoNb68sFIbO34cK+bK2Mi0bcBSrWkK46R1mUgp4uko+8NJp3bJw3acd
	 0hBd1zoSc9+MdrcNI51EAKTD7U7U7t/ohDL5pYpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/342] batman-adv: tvlv: reject oversized TVLV packets
Date: Tue, 16 Jun 2026 20:25:29 +0530
Message-ID: <20260616145049.795165575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tvlv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index 75f7ea827ed9dd..8da8184a2ebdfc 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -13,6 +13,7 @@
 #include <linux/if_ether.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
@@ -160,10 +161,10 @@ batadv_tvlv_container_get(struct batadv_priv *bat_priv, u8 type, u8 version)
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
 
@@ -316,13 +317,17 @@ int batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
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
-- 
2.53.0



