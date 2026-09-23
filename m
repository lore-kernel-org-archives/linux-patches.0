Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202E9511E8A;
	Wed, 23 Sep 2026 14:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173910; cv=none; b=uBJBe637F/HiBmZgbNPm9xqg8CLCtSZSh7Xcyf5w3hrW1IPRanoX6l7+2k1mLW+pbEXdPbjGO8pK/PqA/ZjWAKIZ59X3IXelj2WYczL/CiwduHW8DMWPfQa0L0eCyCADb+Gt3olxIPkmgHjpsST3QILBy+SS9J55ak9XkDo2c0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173910; c=relaxed/simple;
	bh=WKFB+rkfJwFOTjEgVP+5OS6xmzXPLoktNFr37y5MLik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQ9ib6ZoYsEM5e2dREN0LYc5oZlsuIIwHAPoweMZKpNgxV5sG2UfVDS/jBzCzOYPFJqF1ymVUkVpfpkH2s5nki1Ms2LJZ7B3+R2XkLgnWEJt7l7j0L3ynP/auIsIOf7WvSFGyJa434Dtl3DodFEBj7mcOWdkX22Ltk0m57sZg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcYTGNtU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcYTGNtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86D71F000FF;
	Wed, 23 Sep 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173908;
	bh=59l2yDEv9YBzdte7s7wC5MQv54KxmTfH7lvxwPkeVVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcYTGNtUuLusheghAb42fsoQIsKvcq2cRYzGtowO56+Kn+UGO6Dw1MY71K7C+Sdpz
	 MW8RA/NuMFqdKbZ/Y36y+FD81fcMpxAYFX66/J1u/gW4x4tuvunBvzQwgKtkwfIWDL
	 CC9GFT0sCQQ648coqrzSzlGP3lLiQ6SvdoCaymng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Martin-=C3=89ric=20Racine?= <martin-eric.racine+kernel-bugzilla@iki.fi>
Subject: [PATCH 7.2 383/438] wifi: iwlegacy: fix broadcast stations deallocation
Date: Wed, 23 Sep 2026 16:06:44 +0200
Message-ID: <20260923140654.794889728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 		if (WARN_ON(il->num_stations < 0))
 			il->num_stations = 0;


