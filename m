Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C201E87B;
	Sun,  1 Sep 2024 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209317; cv=none; b=L+t8YHj+7K+zNrnWp6IThHbTU2W3mbvcr0wjYyvE0XItauimz7eU7tL0V63TqCiK0U+2zNbs0OwLMoV/WcQjEIx07HAsX9M2H/7c0lY4gGHoVehRb2fDh5GchwpVpDefylwGKLwZ2ztOs7kZ0iZAmDVq5Gq0y6J1MXKIJ9h0SBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209317; c=relaxed/simple;
	bh=N1wRxK6F6gaIwM+5wwPnXi5Gf0Eg33wzEXdr4XbsPbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLKjD8X9paUBTnoTxf5v2ejryB3T7SmXiuyF2IKiv0FCpF2SS/n9AR19J61VR3HseoY7g50tKfnmGnpW5LVKE/3VwkRv5yfo6wNSgQfWDtJ0yYTXZgG9Okl2ac9fR0sOkhQgj3RRoMhOc4OZmtXEZACarmDklvl0KR3sdN+X6+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYY0Zq0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYY0Zq0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C12FC4CEC3;
	Sun,  1 Sep 2024 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209317;
	bh=N1wRxK6F6gaIwM+5wwPnXi5Gf0Eg33wzEXdr4XbsPbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYY0Zq0r86nFyMISgM2cqp5kgnFdu9qaz7BE0LT5uUpQyDriHGfDBE/eEPukHBBTK
	 8emHWAX/vHbjpC2xGXAZz19ilbS8Y/qx0p5Kef1xtmVt8lqGb7AHphTb99X77/Oqv3
	 J6kwBJK0x4A8D9U2BrSP2AyIRJYz9m43SA4aEVGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 52/71] sctp: fix association labeling in the duplicate COOKIE-ECHO case
Date: Sun,  1 Sep 2024 18:17:57 +0200
Message-ID: <20240901160803.853537177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 3a0504d54b3b57f0d7bf3d9184a00c9f8887f6d7 ]

sctp_sf_do_5_2_4_dupcook() currently calls security_sctp_assoc_request()
on new_asoc, but as it turns out, this association is always discarded
and the LSM labels never get into the final association (asoc).

This can be reproduced by having two SCTP endpoints try to initiate an
association with each other at approximately the same time and then peel
off the association into a new socket, which exposes the unitialized
labels and triggers SELinux denials.

Fix it by calling security_sctp_assoc_request() on asoc instead of
new_asoc. Xin Long also suggested limit calling the hook only to cases
A, B, and D, since in cases C and E the COOKIE ECHO chunk is discarded
and the association doesn't enter the ESTABLISHED state, so rectify that
as well.

One related caveat with SELinux and peer labeling: When an SCTP
connection is set up simultaneously in this way, we will end up with an
association that is initialized with security_sctp_assoc_request() on
both sides, so the MLS component of the security context of the
association will get swapped between the peers, instead of just one side
setting it to the other's MLS component. However, at that point
security_sctp_assoc_request() had already been called on both sides in
sctp_sf_do_unexpected_init() (on a temporary association) and thus if
the exchange didn't fail before due to MLS, it won't fail now either
(most likely both endpoints have the same MLS range).

Tested by:
 - reproducer from https://src.fedoraproject.org/tests/selinux/pull-request/530
 - selinux-testsuite (https://github.com/SELinuxProject/selinux-testsuite/)
 - sctp-tests (https://github.com/sctp/sctp-tests) - no tests failed
   that wouldn't fail also without the patch applied

Fixes: c081d53f97a1 ("security: pass asoc to sctp_assoc_request and sctp_sk_clone")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com> (LSM/SELinux)
Link: https://patch.msgid.link/20240826130711.141271-1-omosnace@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 5383b6a9da61c..a56749a50e5c5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2261,12 +2261,6 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 		}
 	}
 
-	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
-		sctp_association_free(new_asoc);
-		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-	}
-
 	/* Set temp so that it won't be added into hashtable */
 	new_asoc->temp = 1;
 
@@ -2275,6 +2269,22 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	 */
 	action = sctp_tietags_compare(new_asoc, asoc);
 
+	/* In cases C and E the association doesn't enter the ESTABLISHED
+	 * state, so there is no need to call security_sctp_assoc_request().
+	 */
+	switch (action) {
+	case 'A': /* Association restart. */
+	case 'B': /* Collision case B. */
+	case 'D': /* Collision case D. */
+		/* Update socket peer label if first association. */
+		if (security_sctp_assoc_request((struct sctp_association *)asoc,
+						chunk->head_skb ?: chunk->skb)) {
+			sctp_association_free(new_asoc);
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+		}
+		break;
+	}
+
 	switch (action) {
 	case 'A': /* Association restart. */
 		retval = sctp_sf_do_dupcook_a(net, ep, asoc, chunk, commands,
-- 
2.43.0



