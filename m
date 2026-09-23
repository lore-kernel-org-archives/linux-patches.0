Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E08440A16;
	Wed, 23 Sep 2026 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174975; cv=none; b=kQWbry0Lzgy57dYHKluJLXCiEeTbaghVtKIyrR69kc9OPycYY54ZhZe74pPDP3o3mf+3CVE9KfnQFaWSx6NS8Q9sdb05L/yrvo1G34h15dacW/kmOluK1Y9WkeahlSChmRslifnOJHWcaowrueMagtRjg1t2Xg/K1oQn//CwVpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174975; c=relaxed/simple;
	bh=wMW9zPgFxwgc6Xn38dbZxEkAeDb4JkXDgEkqCJ60k1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eX3YenjLRWuUbe+db7Hu1eF4ObyPFa/saVDeMsM/Sc/QFD6zWo5R+ctuwRMcIZwMUjI15UXfsr7044I8bz0eUY5cclLHSa3Ituu3ygf9gbYdkAZSDWSiPck9AYwtV57fQcN/31O5L6r2kuPPhcwC2sywb4LHbFgjKj2nD6Hub8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYzSKjvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYzSKjvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8F41F000FF;
	Wed, 23 Sep 2026 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174973;
	bh=7FpzaDK6DIX8GjN60SXo5K2ILu/XKmWRss2Kx4qfMPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYzSKjvjWQMmTNAk8/1C0ExF9/ZMAb/IZOdvvJNrJ7YOwAhtysU9X9H982TB8aKsI
	 FQtJuOygn8htmUcc/8tM87FslN24dh6zXhVDHCQfHZOMnp3QRpzqre6bAQ6i66VHp+
	 PxLLxJ3NidpEteqxXlE49SkDOx01mYuvsE7p57Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 247/398] net: wwan: mhi_wwan_mbim: guard against a cyclic NDP chain
Date: Wed, 23 Sep 2026 16:05:21 +0200
Message-ID: <20260923140649.813322748@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit 5d063822ac5184939c1ed377a339a01d8ae814e8 upstream.

The NDP traversal in mhi_mbim_rx() only stops when wNextNdpIndex is
zero.  Nothing requires the offsets to advance, so a modem that
points an NDP at itself, or at an earlier NDP, keeps the loop
spinning forever on one CPU.

Break out when the next NDP offset is not larger than the current
one.

Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
Cc: stable@vger.kernel.org
Suggested-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Verified in a QEMU guest with a fault injector feeding the driver's
receive callback an NTB whose single NDP points at itself: the
unpatched driver spins in mhi_mbim_rx() with one CPU pinned at 100%
and the thread never returns.  With this check the loop terminates
within one iteration.

Changes in v2: move the non-increasing check to the wNextNdpIndex
retrieval site, as suggested by Loic Poulain, instead of tracking
the previous offset in a separate variable.

Link: https://patch.msgid.link/20260911021734.1396599-1-zhugl3@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -350,9 +350,13 @@ static void mhi_mbim_rx(struct mhi_mbim_
 unlock:
 		rcu_read_unlock();
 next_ndp:
-		/* Other NDP to process? */
-		ndpoffset = (int)le16_to_cpu(ndp16.wNextNdpIndex);
-		if (!ndpoffset)
+		/* Other NDP to process?  The offsets must advance, or a
+		 * self-referencing NDP keeps the loop spinning forever.
+		 */
+		n = (int)le16_to_cpu(ndp16.wNextNdpIndex);
+		if (n > ndpoffset)
+			ndpoffset = n;
+		else
 			break;
 	}
 


