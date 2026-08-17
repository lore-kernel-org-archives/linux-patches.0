Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E0A3D301E;
	Mon, 17 Aug 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977680; cv=none; b=KEWCOyM3iriNRHJ8LLm1dy7NyraYagI3v6FmttSYlf1NCdI7iNdrLYO+Cmkx1MbJmqFAUhltALS7+24ugliF8JS42zzboDvPQ2Ai9LLhukYqXqUha2wyqNubmS3AndL6CM7yHlFlnCi5cAPvzvF4P3dQXx+5JnkiAP/BKuM/lt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977680; c=relaxed/simple;
	bh=h90cVJ0ASGvtPw94yQGGDjKWRM7vPsRdChbSVxZKCig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btCleXqkOw8maxP6+/9vh2a6ILUR9S46KWviZJVLQR3qv2H0S+YNfTM+3RrZWwcqX5HVj3HyTmmLVnKb0Siha8m+rf/z6UmWTGop4T+iwXYxFJi76sjABqqKvbAYny1t/GrW8zgMb6gP0awe6SAlPeadu78OywtYkbS1ntP35Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii3kA6FC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii3kA6FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEA01F000E9;
	Mon, 17 Aug 2026 14:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977678;
	bh=aQV6QBWkvBf0lbsxhSuCjNQC3v5WZ+33vrag4V8WTgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ii3kA6FCKdOWI6nCk7khjGCrSWMIIy2k7zJhRGl+bid7JOrMPDWlHJ/5qKcQsrV6j
	 ZS0FeDsRX3BXE1Ncub/sfPk5aV4NRQWViYncyX/5ehmk8cZpMNmzk+3UcKn/Q0FxBu
	 Wg3K/NkJNHBaaOOir5NzCxi3BqF4AK2g0amp6/vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 413/456] net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header
Date: Mon, 17 Aug 2026 15:33:23 +0200
Message-ID: <20260817132555.398580751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang Tang <q.h.hack.winter@gmail.com>

commit 3b9a324e646d3657a8d9806dfbfe4f3e4066e882 upstream.

dev_validate_header() reads dev->hard_header_len directly when
zero-padding short link layer headers for CAP_SYS_RAWIO holders:

    if (capable(CAP_SYS_RAWIO)) {
        memset(ll_header + len, 0, dev->hard_header_len - len);
        return true;
    }

Packet send paths call dev_validate_header() on skbs whose headroom was
allocated from an earlier hard_header_len read. If the device is
reconfigured so that dev->hard_header_len increases before validation,
the memset writes past the reserved buffer, an out-of-bounds write.

This out-of-bounds write is masked in some SOCK_RAW paths today because
the same concurrent increase can first make skb_push() exceed the
reserved headroom and trigger skb_under_panic(). Remove the zero-padding
branch before making those hard_header_len reads consistent, so the
snapshot fixes do not turn a loud panic into a silent overwrite.

This path is only reached for variable length L2 protocols, where
len < hard_header_len but len >= min_header_len. No remaining in-tree
variable length L2 protocol implements header_ops->validate, and the
CAP_SYS_RAWIO bypass that zero-pads and accepts short headers has no
real value beyond allowing testing of intentionally malformed input.

Drop the CAP_SYS_RAWIO branch. The remaining reads of
dev->hard_header_len in dev_validate_header() are comparisons only and
have no memory safety impact.

Suggested-by: Willem de Bruijn <willemb@google.com>
Fixes: 2793a23aacbd ("net: validate variable length ll headers")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang Tang <q.h.hack.winter@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260805125729.19220-2-q.h.hack.winter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3333,11 +3333,6 @@ static inline bool dev_validate_header(c
 	if (len < dev->min_header_len)
 		return false;
 
-	if (capable(CAP_SYS_RAWIO)) {
-		memset(ll_header + len, 0, dev->hard_header_len - len);
-		return true;
-	}
-
 	if (dev->header_ops && dev->header_ops->validate)
 		return dev->header_ops->validate(ll_header, len);
 


