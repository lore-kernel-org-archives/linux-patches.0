Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EDC1442F7;
	Thu, 11 Apr 2024 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830034; cv=none; b=fRZe+J4W8kXgJM4uUH4h99Xzzs+rt5jY+plmiAvxRteps1j2nAd94v8D7UF+Qnddi/c76xAfHmOZmB8gfGycgGIVoIw1OmxWoAAdHF/Svc+L++rHNEFEACt3MRNDFegUysaRhTtpYOn0EfD3QT40LzOD4TJuAB+pxdpnGdI9zR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830034; c=relaxed/simple;
	bh=PD1r+kb8IPEWJ4Qg4v7w42xBc936JPbkqJ1AGx5FOcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HooMCoYEOEotl+KiEWW2BfO4ySvbEilGgirCmqdEqrlIQf9cN1dmMiplmKp8I/w16yMOb3fWJzxeJ7cWoYybUFLYCcnVzPjsIsGxtOvn4krBCwyo6/S1jdkw+V6cCTWoiQCk+EdanYkjk63vBfJ785LRbLCiyJbwfIuF/htCwUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=em4jCl6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em4jCl6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCEBC43390;
	Thu, 11 Apr 2024 10:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830033;
	bh=PD1r+kb8IPEWJ4Qg4v7w42xBc936JPbkqJ1AGx5FOcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em4jCl6zVoKNJt2fHo5dBZaendGwl9wsgnaK+szPSSKndmh1IzdYgOrcvHbPKBViK
	 uW3gbFojmxJsl3GUwKFLuFqIkai9y2LeBfKZlNJa5QMYEEzTuzaHhRuqiGuuf1GW0Y
	 K3gk7TRMsmJRMXKZItoG+Mz7pm/4dYqCe6thBVnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 005/143] batman-adv: Improve exception handling in batadv_throw_uevent()
Date: Thu, 11 Apr 2024 11:54:33 +0200
Message-ID: <20240411095421.070551748@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 5593e9abf1cf2bf096366d8c7fd933bc69d561ce ]

The kfree() function was called in up to three cases by
the batadv_throw_uevent() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Thus adjust jump targets.

* Reorder kfree() calls at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 5fc754b0b3f7f..75119f1ffcccf 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -691,29 +691,31 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
 				  "%s%s", BATADV_UEV_TYPE_VAR,
 				  batadv_uev_type_str[type]);
 	if (!uevent_env[0])
-		goto out;
+		goto report_error;
 
 	uevent_env[1] = kasprintf(GFP_ATOMIC,
 				  "%s%s", BATADV_UEV_ACTION_VAR,
 				  batadv_uev_action_str[action]);
 	if (!uevent_env[1])
-		goto out;
+		goto free_first_env;
 
 	/* If the event is DEL, ignore the data field */
 	if (action != BATADV_UEV_DEL) {
 		uevent_env[2] = kasprintf(GFP_ATOMIC,
 					  "%s%s", BATADV_UEV_DATA_VAR, data);
 		if (!uevent_env[2])
-			goto out;
+			goto free_second_env;
 	}
 
 	ret = kobject_uevent_env(bat_kobj, KOBJ_CHANGE, uevent_env);
-out:
-	kfree(uevent_env[0]);
-	kfree(uevent_env[1]);
 	kfree(uevent_env[2]);
+free_second_env:
+	kfree(uevent_env[1]);
+free_first_env:
+	kfree(uevent_env[0]);
 
 	if (ret)
+report_error:
 		batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
 			   "Impossible to send uevent for (%s,%s,%s) event (err: %d)\n",
 			   batadv_uev_type_str[type],
-- 
2.43.0



