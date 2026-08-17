Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5273B38A9;
	Mon, 17 Aug 2026 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977441; cv=none; b=PPB+kVbH4dPAaslIyQgIwAXDpNM7zQRlPQYTFSFhgLk4i+zS6uacop572Rca8zBQhEn6y/yIlDSGTmACe4zN4bFnTPtMoZv5RjDUl3RFSFRIlFeJ1kyr8MdhFYbDLiUDQelORFG4LcDRw01VC0ejQQc2bFrIWgMxcvm+V4NKV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977441; c=relaxed/simple;
	bh=i35gAbWDiwcEbk3T2wz1DcuGL9Y469nV3AXmhWWfT0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhjlNZMeBJuy7WUiqwBngdRHPW4hcZN2zeOooHKfB7GnbdkUGqXMkXL7GcDeRZWhjaYqp+rAW5chD7Rxke+r27LeWv5mx8lgAbVOlIXVbNkz/G9Ip/yrR02+ERCMU8EYtJRW+wIOAZYGtlcKu7hA76Mwweh9W+gB6xaOffWSbqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRB6jT8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRB6jT8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AAF1F000E9;
	Mon, 17 Aug 2026 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977440;
	bh=cVFzCMmDmugPKhSA5frRGyDjXZaulUpo8v5767xkBM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRB6jT8zN44lceK+wzMxH9pg0UWwjztjJ+TqmKfLJg3v5/M3jEyq2omWD8H+pJYIb
	 O/QAJLOt8LgF/csjDMNi5jN4J1dTomVLOMVn+bS7Ch2ptm46fwn7jI+vlOa+j1jg3F
	 qaRZZdrKZ1EhNhoGgby5jdIkmMKGpYIW8ipUfBtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 330/456] sctp: reject stale cookies with mismatched verification tags
Date: Mon, 17 Aug 2026 15:32:00 +0200
Message-ID: <20260817132552.548420690@linuxfoundation.org>
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
@@ -1821,9 +1821,9 @@ no_hmac:
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
@@ -1834,7 +1834,10 @@ no_hmac:
 	else
 		kt = ktime_get_real();
 
-	if (!asoc && ktime_before(bear_cookie->expiration, kt)) {
+	if ((!asoc ||
+	     asoc->c.my_vtag != bear_cookie->my_vtag ||
+	     asoc->c.peer_vtag != bear_cookie->peer_vtag) &&
+	    ktime_before(bear_cookie->expiration, kt)) {
 		suseconds_t usecs = ktime_to_us(ktime_sub(kt, bear_cookie->expiration));
 		__be32 n = htonl(usecs);
 


