Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1C3368972;
	Tue, 12 May 2026 18:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609450; cv=none; b=YPn2fJelKLjMaKgRvU9YLhfMr5/vYpzGjRAY4BXNKu+Rv3WI1xpwBDeQZpuXzqXm5Pkoo/qY3n0wcLf7TFuV1qtDMZnTMIvwI4zQ6qlGB91c3pz/3CGO6oaQgtmHgYkQNGd+NZk40ANRuo5fYhnKrfZWsR2xoIc1LfpZx2rLZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609450; c=relaxed/simple;
	bh=EQoPxhIvZCdYPCNpfrqEO3DJSBaLZZdw/syknobOJOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnIf98Ep34mMnqMfPyZzdY+7jAXtBvi+7SB2CcuR+sdkr7lwWLZRkVE7FSLBydfaJOhaamQAozX4ejKV9AfKXdn1gAWdyVp38VcBS5t+fwCPGoI2qPsmvVsXoKmGLAY7WTmpif7/sWCkh2aC9NbLF6n8sy5J0NYYU0F97CH/uvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBwoagrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBwoagrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03173C2BCB0;
	Tue, 12 May 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609450;
	bh=EQoPxhIvZCdYPCNpfrqEO3DJSBaLZZdw/syknobOJOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBwoagrb4535rNtZZ/YagD0BO30lLsp+68/lqp/LlrWa70+t/77eBhsySYhBNFBc7
	 oYCHAlqsFyXFpgMZI8ZNnkPplpurjDHPvQ4L3Bqjydtz4btBs50CyaR0X5tv38iNgY
	 D0tgSQjupfvegpMrcYeMnltrabRtukjuCd2uyfwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 198/307] libceph: Fix slab-out-of-bounds access in auth message processing
Date: Tue, 12 May 2026 19:39:53 +0200
Message-ID: <20260512173944.298605062@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


