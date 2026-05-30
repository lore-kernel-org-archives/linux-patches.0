Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D9932D42B;
	Sat, 30 May 2026 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160502; cv=none; b=Exez7AzOusgKT0edTMup9BA06RnOPzCcTmHn5xyMeCIA0oURd3Q9zG0SvgF2fiLF/Sq9Ms0EGpq8Rmw+9Zzr305xIbPNje1UX8ZqD6u/X/rKgSQKjtTsSdT+mqCZelfyzsSTQBUmm8q/qXNE2+Y+nG3f8SR3paiEG/WwOPP8aqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160502; c=relaxed/simple;
	bh=aCtwWwwQkB2iAlj57wJqHHI18n/f0nGRWitT47Sb+4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGcRit6wH180Xp02SCE/5Tu5EySTMXfFhzdIJtbbQgIftVe9cl6Ewm4lg2mRnR9PpAARxzcUeyD4Cq+sJln52cZfn5ND5y7HH6H/DcpSYo5v6R17gEp177w0skQVOjJpTcHAm5jjIXlju9pBHTzujUX2eWFvpKeflR/ThDzowQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvJW0DPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvJW0DPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F611F00893;
	Sat, 30 May 2026 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160501;
	bh=xMHb3F2eX9ZxL1AAfolfxLrf4mrvdf7P15xRfImwfEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvJW0DPWGqmKebQg0h/JBBoC8djPzX+1QsuCnBwV4gzE5jKwDQAj81K7CXOzmQHb2
	 srL/pAfR09RZXK6dZUilPsgt6l1AQH39iMOba3jmq1klIho5hSXpT93rllpcYO2RNJ
	 Wue1lwnoKCx4Q8RSosrQBsK5v4eXSZ11qEuP8IsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 356/969] libceph: Fix slab-out-of-bounds access in auth message processing
Date: Sat, 30 May 2026 17:58:00 +0200
Message-ID: <20260530160310.173461112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 1c439de70b1c3eb3c6bffa8245c16b9fc318f114 upstream.

If a (potentially corrupted) message of type CEPH_MSG_AUTH_REPLY
contains a positive value in its result field, it is treated as an
error code by ceph_handle_auth_reply() and returned to
handle_auth_reply(). Thereafter, an attempt is made to send the
preallocated message of type CEPH_MSG_AUTH, where the returned value is
interpreted as the size of the front segment to send. If the result
value in the message is greater than the size of the memory buffer
allocated for the front segment, an out-of-bounds access occurs, and
the content of the memory region beyond this buffer is sent out.

This patch fixes the issue by treating only negative values in the
result field as errors. Positive values are therefore treated as success
in the same way as a zero value. Additionally, a BUG_ON is added to
__send_prepared_auth_request() comparing the len parameter to
front_alloc_len to prevent sending the message if it exceeds the bounds
of the allocation and to make it easier to catch any logic flaws leading
to this.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth.c       |    2 +-
 net/ceph/mon_client.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -257,7 +257,7 @@ int ceph_handle_auth_reply(struct ceph_a
 		ac->negotiating = false;
 	}
 
-	if (result) {
+	if (result < 0) {
 		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
 		       ceph_auth_proto_name(ac->protocol), result);
 		ret = result;
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -174,6 +174,8 @@ int ceph_monmap_contains(struct ceph_mon
  */
 static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
 {
+	BUG_ON(len > monc->m_auth->front_alloc_len);
+
 	monc->pending_auth = 1;
 	monc->m_auth->front.iov_len = len;
 	monc->m_auth->hdr.front_len = cpu_to_le32(len);


