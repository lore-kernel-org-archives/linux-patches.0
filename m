Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AFF5275B8;
	Wed, 23 Sep 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175223; cv=none; b=GCzMtzFhAO7y9dY7pZRBp05LstuhrJ3X+ioiKwhM4m5toaWWLYlKN6uOxh1dwL6Hx959b86FUv589IM6DZn5PFTiZ9H3YpW05IXGdmFYh/KoMaG1EgNvL+1O2W7/DZu0EMj/A5ybB0rPemzVFPpaiUfPIfYvnhpF4MfXMQC6vc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175223; c=relaxed/simple;
	bh=CK9sTw8Zv/So8SpBJQHgBjSCuVAcc3UOXFh6aQb9RxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LtxDDaTCOyh5Vxqmu72qeNq8kD3JNXnyc7HZe2r3vNjawGe8duE4Ib+YfPGQ7wnIv0S0bX752PmupOs5rNNBiSx+aJ21373Zq8moR1ofhzIEFPMlL8hN/nVrLFDQi50xzcDhYTPWHSClQdoTF78MYKkwXqa3s5vd69j1Bgu0S34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZE0FRWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZE0FRWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6835A1F00893;
	Wed, 23 Sep 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175222;
	bh=oC2iBmwHpwOaEl+whOA7eOPqxtIw5hKxUU+CSlF3lYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZE0FRWJ2ShAlXZP3M9XTFCjXGNjFMdKvmAdCnoG9e8TXIfpXaT9ywcpBQkftHlLh
	 Mpbvye8TN5tkekEwExuSrE6qZJoUbftDNh+eVHMjXJCcy5c9UoVwboaQlTsucZu2Dw
	 SYOeQ8phG27nKMDT+41EdpFB4FCm31pRUb5z601I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	=?UTF-8?q?Martin-=C3=89ric=20Racine?= <martin-eric.racine+kernel-bugzilla@iki.fi>
Subject: [PATCH 6.18 324/398] wifi: iwlegacy: fix broadcast stations deallocation
Date: Wed, 23 Sep 2026 16:06:38 +0200
Message-ID: <20260923140651.816659321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2327,7 +2327,7 @@ il_dealloc_bcast_stations(struct il_priv
 		if (!(il->stations[i].used & IL_STA_BCAST))
 			continue;
 
-		il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
+		il->stations[i].used = 0;
 		il->num_stations--;
 		BUG_ON(il->num_stations < 0);
 		kfree(il->stations[i].lq);


