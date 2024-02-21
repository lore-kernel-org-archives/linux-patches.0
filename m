Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F59A7F46C;
	Wed, 21 Feb 2024 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524456; cv=none; b=FVEZzb9oDwvftlwH20KawXzG2k5kq9U2YoVCDu/LrgFGFmr2VzOUgGZFjZv+kNAaS5Iy/gnDLwhpixPJdWr0L1KfbKUIDY8/uTIvdP4iKZHIFIap6TfV4bRA42vxlU3hL1lY1bjUBv9+Uw4l5jc++Zm3HJ4r/PZR1ksJ4w4TRxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524456; c=relaxed/simple;
	bh=wbICEqvs+aqtqktIE2LpLSVP+PESsOG5WRgVp+vwRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm8n5GHTC5xaCm6oirIRWgV28O55vIc8JygbyEMf+wU5RwYObamXXVbI9MwpOnBhYMNcHPEeOkPmLKEDjYJ2TUmcF8sgZ2MyELuB7/Ei3tFyAnew11XnAaKiP/ZHdBERACqO2A4UYO02pUJAcYCGVvH+YkILDHGPayDNBRy0L4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0hdjQiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0hdjQiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D971C433F1;
	Wed, 21 Feb 2024 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524456;
	bh=wbICEqvs+aqtqktIE2LpLSVP+PESsOG5WRgVp+vwRJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0hdjQiwEX+GOhPyB/y6GQA8seXgY49ZXajktbrgOM9rE0SCs+jt+T48U7EUOhObS
	 1Kuh4DQdJAgcKrFMf5a9zlbfENwmUnQ3tp7OQUgvqSicCeab7Dh84A7I5DLVWZCWE/
	 jPLownRm4trApRGtS3uu1LUEigB3lGI+5gnvbkyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 5.10 221/379] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Wed, 21 Feb 2024 14:06:40 +0100
Message-ID: <20240221130001.439218492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 1184950e341c11b6f82bc5b59564411d9537ab27 ]

Replace rcu_dereference() with rcu_access_pointer() since we hold
the lock here (and aren't in an RCU critical section).

Fixes: 32af9a9e1069 ("wifi: cfg80211: free beacon_ies when overridden from hidden BSS")
Reported-and-tested-by: syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_BF8F0DF0258C8DBF124CDDE4DD8D992DCF07@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6f0a01038db1..a6c289a61d30 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1802,7 +1802,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



