Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAFB3F3265;
	Mon, 17 Aug 2026 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975037; cv=none; b=JyG6OTHrdbFLntwQmkYKywlnoGgEtPTkALdoT7qhkbIQXj2PcUSQtPDyS1VujydfPhJfnlBBVTJppFsZbN4kBcdNXxdIAMMHSRpGeq+oLQ5jbZWxfjwaUY5LCP1Pp4iTngMzqmKM+LpOhWI/3N8KqnfnuZcnRFpVBKlPS18w690=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975037; c=relaxed/simple;
	bh=rCsuYdk99DhBsaKZ9Fkj9wU8Yqj2o9Q06M8rLivae18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTP82rwRYY26au23wV/ilVXOCNBvs9BpA4lji52owUzFjpaOjzyReZY6+flq/MG3nO87IQ+gU5IZ8m5C++0JnxvrVcGPJwg+J9vEFL8OBRw4zr6QkQf17ARDQWqRxHLXuqBgSSV2KRH5Ze9KAa9kOSEmwBixRyfozNc7cidVsE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEOGojox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEOGojox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5671F000E9;
	Mon, 17 Aug 2026 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975035;
	bh=nG7lu7lTZKSXD/j0Ks46qSncB0YavqCdxSJ+5cNfn2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEOGojoxnMXmCAd2C4alL1C2b139UX8phgkGcm9LeqidDcNmXZ36nwHxZhe1YdD+x
	 wgKFZdYdg6c+Phn71ULElk28pIHPbrjI48Gbq4HCQv2BtVrXSfkUd8OMm3vgAAiFQ/
	 iVmuHBrwdPHcNRxhRXdfEjZgbyo/BpSXeFNVOchA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 140/250] net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header
Date: Mon, 17 Aug 2026 15:31:41 +0200
Message-ID: <20260817132542.280173836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -3459,11 +3459,6 @@ static inline bool dev_validate_header(c
 	if (len < dev->min_header_len)
 		return false;
 
-	if (capable(CAP_SYS_RAWIO)) {
-		memset(ll_header + len, 0, dev->hard_header_len - len);
-		return true;
-	}
-
 	if (dev->header_ops && dev->header_ops->validate)
 		return dev->header_ops->validate(ll_header, len);
 


