Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66243E486;
	Tue, 16 Jun 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623962; cv=none; b=DSm63eQXgkfreg63Vh4Ow5S8ipEjT9qq0NAFuNauu07hwknP5NglhijzVAmkLQdKkIm4qQ0uYHE7YakY5AWuWofQJl0e7xZaRSObRVjMUbVHcGTv2ttCLutTJnCxAzii2Rp9oYOEQ9eVYhTFkG7P5UdrLbIpKoOucvX0J53NdaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623962; c=relaxed/simple;
	bh=l+JEmkKLOgobAGHt9bBKcXevT0vFBeYnfEhnIc+sBw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAyIENUMF097SQCbx5SsQLjmvXqlrSBxWMYvdm0h9kb/xx9KkhbjA0L/WnzrgDyOTBLQt28i3IUmOyeB2Da9Jvta/K3tLS+8oDugq6oEQfjQJ7V79Ikha3T3Ak6aGmqwbxp8uPX4120eYMe9tVvPp56cu+JGJkaLZSuL0cKabGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPoKpVDe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPoKpVDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A921F00A3A;
	Tue, 16 Jun 2026 15:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623961;
	bh=95Lc47aJgsAOcH8/LlPeE7HToycFb9Tq/2QMOyCbEGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPoKpVDeAZVtZC4rFUifuVtPwTl3A1rB1N4ZfN/4hd3y2hQA5UkqQlTqggHJVGsli
	 Bcd+rQPhizFbqh8oMdE28DEi2hr0kkRLK3+PwQo3NUXXaQEVMe4JJbcbgXOQ8AaD/O
	 P2a8reyryqM1cHv1WAbX4f/ZIyXRLjnukMVdO3FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Salman Alghamdi <me@cipherat.com>
Subject: [PATCH 7.0 247/378] staging: rtl8723bs: fix buffer over-read in rtw_update_protection
Date: Tue, 16 Jun 2026 20:27:58 +0530
Message-ID: <20260616145123.192653869@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Salman Alghamdi <me@cipherat.com>

commit 514ab98364595007d4557ecc85d7e5f012c504d3 upstream.

rtw_update_protection() is called with a pointer offset into the
ies buffer but the full ie_length is passed, causing a potential
buffer over-read.

Fixes: e945c43df60b ("Staging: rtl8723bs: Delete dead code from update_current_network()")
Fixes: d3fcee1b78a5 ("staging: rtl8723bs: fix camel case in struct wlan_bssid_ex")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-staging/DI2H39EAAFBZ.3KI5NWN02AQ2S@linux.dev
Cc: stable@vger.kernel.org
Signed-off-by: Salman Alghamdi <me@cipherat.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260508222649.23989-1-me@cipherat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -471,8 +471,11 @@ static void update_current_network(struc
 
 	if (check_fwstate(pmlmepriv, _FW_LINKED) && (is_same_network(&pmlmepriv->cur_network.network, pnetwork, 0))) {
 		update_network(&pmlmepriv->cur_network.network, pnetwork, adapter, true);
+		if (pmlmepriv->cur_network.network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+			return;
+
 		rtw_update_protection(adapter, (pmlmepriv->cur_network.network.ies) + sizeof(struct ndis_802_11_fix_ie),
-								pmlmepriv->cur_network.network.ie_length);
+								pmlmepriv->cur_network.network.ie_length - sizeof(struct ndis_802_11_fix_ie));
 	}
 }
 
@@ -1081,8 +1084,11 @@ static void rtw_joinbss_update_network(s
 			break;
 	}
 
+	if (cur_network->network.ie_length < sizeof(struct ndis_802_11_fix_ie))
+		return;
+
 	rtw_update_protection(padapter, (cur_network->network.ies) + sizeof(struct ndis_802_11_fix_ie),
-									(cur_network->network.ie_length));
+									(cur_network->network.ie_length - sizeof(struct ndis_802_11_fix_ie)));
 
 	rtw_update_ht_cap(padapter, cur_network->network.ies, cur_network->network.ie_length, (u8) cur_network->network.configuration.ds_config);
 }


