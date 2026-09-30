Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951A24FC320;
	Wed, 30 Sep 2026 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783618; cv=none; b=lPpUZMNu2G5fIqeCY45ERHSGGK83fXJASoN+DaPShe7LwmyRamVELy5XLJfIMe+ySNlCFD3Rv+rG0A55NMNOr5IYpFGwvjs0nq7czS5OG26PzqhdouO3stAPTIy6IyQtWDXpPJEUoOaOos9MPsQ0k9FH+d9H+di8h9/Egkz1boE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783618; c=relaxed/simple;
	bh=eCyVk7e4Y+cYWwxqurbhQxocwLxYpjckFh5lt+Pt/BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvyyyR5IUBoSMNjCqIcbrumt7yxb9JmfYI9Vf0XgCJ0M1DEdoyz+WzS3KaLWOucALbm+yi9GzbcCiFR+tjqHobG9/v/NpTlO5NRTp4gGYuqhiES9BA2wc+qouE26fkYWEbyxj0cbe+LG1DMR3k4J91AY7R6FhibXqsXb5Mqz0Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkgXgfF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkgXgfF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8BF1F000FF;
	Wed, 30 Sep 2026 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783614;
	bh=a6pplQCtCfD2QjXhPvoZuVnTsxmYctmO17Wn1R0Jyus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RkgXgfF9OrD+ppYGLtOv+Eblnl2v0SlUWE9j0y10fKtgM3nDIHA9PNIY7lyAUOO26
	 d4nJMBljIeOP199wvR8WrQTVBXmEd0iK2tgsI/8WxVMQ4aHt4QqQQIRwEplQ/bvjki
	 p4rw9XwGXB6oOhfOQsUcHjN5t9IDNTEfUfNAJCX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Martin-=C3=89ric=20Racine?= <martin-eric.racine+kernel-bugzilla@iki.fi>
Subject: [PATCH 5.10 462/595] wifi: iwlegacy: fix broadcast stations deallocation
Date: Wed, 30 Sep 2026 17:25:55 +0200
Message-ID: <20260930152357.620147394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit b5526b780f8b297a76030410b96ba29153afb98f upstream.

On the error path of __il4965_up(), il_dealloc_bcast_stations() clears
only IL_STA_UCODE_ACTIVE, leaving IL_STA_BCAST set. This causes the
same broadcast stations to be deallocated again by __il4965_down().

This can occur when RF_KILL is toggled during driver startup.

To fix clear the entire 'used' field, since we will not do any
other operations on the station.

Reported-and-tested-by: Martin-Éric Racine <martin-eric.racine+kernel-bugzilla@iki.fi>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221733
Fixes: c2fd34469d16 ("iwl4965: Fix a memory leak in error handling code of __il4965_up")
Cc: <stable@vger.kernel.org> # 7.1.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Cc: <stable@vger.kernel.org> # 6.x.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Cc: <stable@vger.kernel.org> # 5.x.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260820093059.18779-1-stf_xl@wp.pl
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -2326,7 +2326,7 @@ il_dealloc_bcast_stations(struct il_priv
 		if (!(il->stations[i].used & IL_STA_BCAST))
 			continue;
 
-		il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
+		il->stations[i].used = 0;
 		il->num_stations--;
 		BUG_ON(il->num_stations < 0);
 		kfree(il->stations[i].lq);


