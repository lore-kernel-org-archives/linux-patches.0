Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CD51DFFB;
	Thu, 15 Aug 2024 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732271; cv=none; b=Jj38ndZzT53loGoEFbbAPLWqTloQrCd5XeBQhCxvgkXg54ipBsO4H1H8G79j1rLrSZU18w+mDCs6lz2fMA97Pd/Gb/KHW/fxy8gXBMddmPud8LcJY46vpSoAF6EK/X+oPSyNt+QBzJlYRDbWZSo31BThI+7qeiPmdL4K6XtbcuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732271; c=relaxed/simple;
	bh=0MLEfnPBHog+ghEUW76Ws6lgsQuJ04S89wFitB+ZFQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP7fwUmOJEdOOth68P9v5iz7kkBI638hz24NK/jJWda0mG/wCMCz8awTJo4WRdHYTJwkmmH+TD00pxyi2+aZDhPB4oyp86tJeesRrqVlAGibavV21pR5V9NQ75jCh4p366wqvqQTbHyJW2RpJz+ntR723vi2MYtWRn7i/hiXpc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dp4+oa/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dp4+oa/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A60C4AF10;
	Thu, 15 Aug 2024 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732271;
	bh=0MLEfnPBHog+ghEUW76Ws6lgsQuJ04S89wFitB+ZFQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dp4+oa/341eNyAChq3ksmKaJjHSGHNwQjVUI2kcdak5iwH9lbxsnlj2++R2v5sNsb
	 HELp0RU6wPhZ6G4csaEny7yXEI2Snc0yrJkOkpbonMWPhyLtSjab3EvMgrwTR/6uoc
	 oKfODou1RGcE66m53oLuhEJxbRxO0oP7RUB7RBiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 128/352] ipv6: take care of scope when choosing the src addr
Date: Thu, 15 Aug 2024 15:23:14 +0200
Message-ID: <20240815131924.202432331@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit abb9a68d2c64dd9b128ae1f2e635e4d805e7ce64 upstream.

When the source address is selected, the scope must be checked. For
example, if a loopback address is assigned to the vrf device, it must not
be chosen for packets sent outside.

CC: stable@vger.kernel.org
Fixes: afbac6010aec ("net: ipv6: Address selection needs to consider L3 domains")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-4-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1822,7 +1822,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


