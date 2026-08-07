Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B7412C05;
	Fri,  7 Aug 2026 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117442; cv=none; b=nFXujJdsSK8cmGnPbbcxguvRGD2eW1g8b7tGEBh0fEFXBhtQ28FNolW/5gDfhpggadXFKryD6q7VpxRUA5OXUsdxzTiPKrWy31QepEK+jjgc++7Cini6H9yAM8r7ENV0Ub9iPCDSwWp1psjY8547IT2FkXYUNTd30Q0t5jrbORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117442; c=relaxed/simple;
	bh=lRJgsTtemaDIj3GqFzMB+x9PiHfB0lyqf0g2wy2J0CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cap09dr/8iIJuO7su6nB8Qi1O8bHrBE9i2xff72dtPtCMoUP93Z7UcAqCmaQ8eRxqPJluaDq2paXZrB/fWzwUCbzXI0gkJ++/qTzfiXUJhhKNp68aA0WMG/6FpFdpXEwyrnpWgWFZ+emm+WlHaEcplHQO6bpfx6+5q1S+zEENhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NINO3ZI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NINO3ZI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994B11F000E9;
	Fri,  7 Aug 2026 15:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117441;
	bh=uP0uNEIUS2fOQkEOojovMRaiBK1aEchYFAaFNogS/ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NINO3ZI+609wifkfgjsTFvqXdzaxgwR64s/m13yIcAJlZQ85VmAL16uhOZQzoYyea
	 yEJXJ7oAjGppe9XEDZoEmOZAx4RE3SNfi6xtWqXNCorhdCi33ARu4i9YPTrc+Qu0i2
	 G4byA+OMsgx8th2ENXzRRpx16KAFO8lVDVikSXvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 321/438] sctp: reject stale cookies with mismatched verification tags
Date: Fri,  7 Aug 2026 16:38:37 +0200
Message-ID: <20260807143434.817001792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>

commit 9d8da8e0a9bce4a340af60dd0446bc7eb8d07587 upstream.

sctp_unpack_cookie() skips cookie expiration checks whenever an
association already exists.  This is broader than the exception in
RFC 9260 Section 5.2.4.

For an existing association, Section 5.2.4 permits an expired State
Cookie only when both Verification Tags in the cookie match the current
association.  Otherwise, the packet SHOULD be discarded and a Stale
Cookie ERROR MUST be sent.

The broad check lets an expired Action A restart cookie reach
sctp_sf_do_dupcook_a().  In a runtime test with the default 60 second
cookie lifetime, replaying such a cookie after 65 seconds returned a
COOKIE-ACK and restarted the association.

Check cookie expiration unless both Verification Tags match.  This
preserves the Action D exception for a lost COOKIE ACK while rejecting
expired cookies in all other cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260723225623.2658868-1-yangyx22@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1802,9 +1802,9 @@ struct sctp_association *sctp_unpack_coo
 		goto fail;
 	}
 
-	/* Check to see if the cookie is stale.  If there is already
-	 * an association, there is no need to check cookie's expiration
-	 * for init collision case of lost COOKIE ACK.
+	/* Check to see if the cookie is stale.  RFC 9260 Section 5.2.4
+	 * exempts an expired cookie only when both Verification Tags match
+	 * the current association.
 	 * If skb has been timestamped, then use the stamp, otherwise
 	 * use current time.  This introduces a small possibility that
 	 * a cookie may be considered expired, but this would only slow
@@ -1815,7 +1815,10 @@ struct sctp_association *sctp_unpack_coo
 	else
 		kt = ktime_get_real();
 
-	if (!asoc && ktime_before(bear_cookie->expiration, kt)) {
+	if ((!asoc ||
+	     asoc->c.my_vtag != bear_cookie->my_vtag ||
+	     asoc->c.peer_vtag != bear_cookie->peer_vtag) &&
+	    ktime_before(bear_cookie->expiration, kt)) {
 		suseconds_t usecs = ktime_to_us(ktime_sub(kt, bear_cookie->expiration));
 		__be32 n = htonl(usecs);
 


