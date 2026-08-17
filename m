Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9649E4334B5;
	Mon, 17 Aug 2026 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978093; cv=none; b=Ba/M+mN2T5RTUM4MW1vgdI9BC0TuIZ5vLLJU2G9Yjn7REuMwhrjhPFpJLo2OCgKwhmVz+bC8Sn5mH1V2A0SOy8qiLSP4worpOqKCwMFqBy+cGX0UBYpmDS9cv0ab+hmmqDBG10irpxFYcBjsOd7SxG/cecW+IE1+BD3CZvRRK/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978093; c=relaxed/simple;
	bh=ZBJNPsqAUsmyVLOK+1e/rbkmfkB6TlATRehPuQt76pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLf/B3kdwKWTtUPajAUcW+8FkVsl638Q3m5pTetQB8coMgrpS4n0VQwS3mYaE2CVoJd20AQzaJGt6lZTzcBRXWiP7eFZbdqC7jaSrgz6Uki8BJUvYw2UE+JvhjY87M4fA8ayY29JDr6pu7S3oLI2MNv1cvwCClNaOO36mYJ+VF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDLnjJez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDLnjJez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4A11F00A3A;
	Mon, 17 Aug 2026 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978090;
	bh=Z2fWpuEIMZkBjyn6ubPNOCV5G6n4dzOtkOyZLUpUaIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDLnjJezf/iEFqCediCP1dz2fGTIjxAu6cR+0HTrJ4WBnJitulq6U4dQZaQl3MJsm
	 yH+DNg5xBGq93TYqgeQUZhtYynlemxChykIAa9GQgwnZR5t2TlfTq3+a5gI5rUYReO
	 Kpg+fRPFKHFjrBSNlOEBt3f2XVqSCPQCCxphZFOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 098/181] net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header
Date: Mon, 17 Aug 2026 15:33:12 +0200
Message-ID: <20260817132539.318513650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3191,11 +3191,6 @@ static inline bool dev_validate_header(c
 	if (len < dev->min_header_len)
 		return false;
 
-	if (capable(CAP_SYS_RAWIO)) {
-		memset(ll_header + len, 0, dev->hard_header_len - len);
-		return true;
-	}
-
 	if (dev->header_ops && dev->header_ops->validate)
 		return dev->header_ops->validate(ll_header, len);
 


