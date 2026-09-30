Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4C1341ADD;
	Wed, 30 Sep 2026 19:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796449; cv=none; b=DmFib1J2qmeSKg22oEiP/q67UU652F4GH3AX48tEbKWiEXZBA1zpMtsvRyeaQL97053Z7FrD8LsYVx298IrwZTFX2xoz1jNn0HL5fZrgl34Us+r34VYy2muWZkclPqsOshiUeq89WZgdf2o5OWchSzpr08Ktr1lkvjbLXolAXmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796449; c=relaxed/simple;
	bh=iqMD6D/G4x6HSOq9+aAdFA19TjC4Q8Qf8c356t+IJL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wt4WJo1gVTv71+gaZ6S4fbF84Mpoq/HbefNCL/LLDEhfOibfQXe29c5lqohYIHomQb69bylnd9BdpZuMSd0aAayfYFT5QQ0e6FFBLrfdocFmeLNeGhqpl+fEUgRSL4BgUwAeoRi2RCpOipUskYCONFU9aG40AIT9lglVZCJ8C3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBPquWgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBPquWgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E722F1F0089F;
	Wed, 30 Sep 2026 19:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796448;
	bh=UUUgc0CSeO/THNW+p8KkQy6Zg5ycBptKPbhreyO3eA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBPquWggHSZPoGYtylwcI9y4bDdlXtvtYyd+rQbkAv0y1TlDljGhuVxxwwTQXzFaf
	 HZa/cLqkumysqh4FIn6tqxkXA8agRKTtqmRxRIUstvyEuYQUUOe2Yye9XaCu/aa9ku
	 dsl5M43tHJmOCmwGM5Qbbe9JmBk0WWRABYIWHnXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Martin-=C3=89ric=20Racine?= <martin-eric.racine+kernel-bugzilla@iki.fi>
Subject: [PATCH 6.6 0918/1193] wifi: iwlegacy: fix broadcast stations deallocation
Date: Wed, 30 Sep 2026 17:26:42 +0200
Message-ID: <20260930152454.636384812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2324,7 +2324,7 @@ il_dealloc_bcast_stations(struct il_priv
 		if (!(il->stations[i].used & IL_STA_BCAST))
 			continue;
 
-		il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
+		il->stations[i].used = 0;
 		il->num_stations--;
 		BUG_ON(il->num_stations < 0);
 		kfree(il->stations[i].lq);


