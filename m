Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8681DF279;
	Wed, 19 Feb 2025 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954153; cv=none; b=ClPNU1dLhaT1h0IBjlWoxNuPNYtxOO5aZqdM3OiD1tKs1iy9JM/jRSg7ECP4jXu4aZvLokrirPnuriQQQHZWrGsx7W8YONUsBfYn9haV0dn9OedPzQsTf94F8IrDDjdjDpokq1OLJnDTIPaLHMIMGnpO3cJVU2kMDRNE9q3OvIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954153; c=relaxed/simple;
	bh=e2GHqYKGYPCj557PDp0RfxzFBRF6KJoX2y37Wh3Zcp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU93kC8aYAZpiHaxrz6ItwBGlraFxX3M5n7rck5ZqNlUw5kgI5euHuF8+A+ZJimE5wRnxvKJAJJRH6PGPmfHrwU+bB5jpPJCjIhSTDVEVmF2n5NHS/TTsWyXp2hUOzvgVQrMSkUSc5y+DdGBew+XbgA7FQZjajxAdDwVyo5G/QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO/brNVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO/brNVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B05C4CEE8;
	Wed, 19 Feb 2025 08:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954153;
	bh=e2GHqYKGYPCj557PDp0RfxzFBRF6KJoX2y37Wh3Zcp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO/brNVzcuIirf3w2yfr02iTCkJv4rfF/msRYOb4ehC+mFw9zVcne4dzQ5oLsPr0L
	 hrQgz+0cvYLt12Kc7hIJwKhhtaYMGeiTpY34w5idUHUVm8Z27qe064Ig0fb7APAsJH
	 pJ/jlEZqEuIMroye1hZ9mqqy1B930NlAg/8zTUvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.13 114/274] batman-adv: Fix incorrect offset in batadv_tt_tvlv_ogm_handler_v1()
Date: Wed, 19 Feb 2025 09:26:08 +0100
Message-ID: <20250219082614.080496098@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

commit f4c9c2cc827d803159730b1da813a0c595969831 upstream.

Since commit 4436df478860 ("batman-adv: Add flex array to struct
batadv_tvlv_tt_data"), the introduction of batadv_tvlv_tt_data's flex
array member in batadv_tt_tvlv_ogm_handler_v1() put tt_changes at
invalid offset. Those TT changes are supposed to be filled from the end
of batadv_tvlv_tt_data structure (including vlan_data flexible array),
but only the flex array size is taken into account missing completely
the size of the fixed part of the structure itself.

Fix the tt_change offset computation by using struct_size() instead of
flex_array_size() so both flex array member and its container structure
sizes are taken into account.

Cc: stable@vger.kernel.org
Fixes: 4436df478860 ("batman-adv: Add flex array to struct batadv_tvlv_tt_data")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3959,23 +3959,21 @@ static void batadv_tt_tvlv_ogm_handler_v
 	struct batadv_tvlv_tt_change *tt_change;
 	struct batadv_tvlv_tt_data *tt_data;
 	u16 num_entries, num_vlan;
-	size_t flex_size;
+	size_t tt_data_sz;
 
 	if (tvlv_value_len < sizeof(*tt_data))
 		return;
 
 	tt_data = tvlv_value;
-	tvlv_value_len -= sizeof(*tt_data);
-
 	num_vlan = ntohs(tt_data->num_vlan);
 
-	flex_size = flex_array_size(tt_data, vlan_data, num_vlan);
-	if (tvlv_value_len < flex_size)
+	tt_data_sz = struct_size(tt_data, vlan_data, num_vlan);
+	if (tvlv_value_len < tt_data_sz)
 		return;
 
 	tt_change = (struct batadv_tvlv_tt_change *)((void *)tt_data
-						     + flex_size);
-	tvlv_value_len -= flex_size;
+						     + tt_data_sz);
+	tvlv_value_len -= tt_data_sz;
 
 	num_entries = batadv_tt_entries(tvlv_value_len);
 


