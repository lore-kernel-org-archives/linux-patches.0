Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829047;
	b=IGyY9lbmw/sbnOh6kTpvfu4o7h1PUBM73KuxDqdsPWEZj9uwAZ305WOgfF1X5tC7d45s
	 YRrCcAEil6pHekGYTlM5rZ3a/abTnrAVXYFfwUY/PDb2F11SR9vzIuux8jMeN95DlSp4w
	 iVgm6rHe13u0dIsVG0Yxw3wy4D92vzaiVi3hl+ZCCCJesJ5WoS4HENLycwaud8avaZwWQ
	 j+rFd3kfQq/N3X+62aXaqrSkaviwcsiVdW/mhmj0uIm3S6f8ZOzbQZhSemLWaULybnVOv
	 sTVLRYz4VfUtxboVFHzq02DMFT0fA45hoTanEh7NwrNranCdBmeoV4c60KkXAYeR6Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=384s+rSNtMHGR6z3JtzRl907jI1SZVHfXQ2+1mPapNg=;
	b=KHsaXv7rW/sa28kvfqIm+ZmLQzh6YRvduYrEvrb1UUg7M4KqOhsd/s1l918jLyhMQNmD
	 4jOqXLAC1JxJLKTrTj47tm76gPCKNVc7RvIEdR5vx/uNZzZGXuYU40j3VBeX8oNDmVdk1
	 +t2KNTn4OelvpNFYXNxqqKN4vessye474H5tWhscu3DPZmqhNzls+b/arDJSWHfyH0HUR
	 tdf/GDHznLV2U0pbTwJbZKGEDj770JAHVkKFz0W5d/16ywqIuS2w5t+01yUJ8cbzNAlWb
	 b3vqhJyVx+nh0ZGts7vGzq154lnly6oqxpSD9ZhAwS4FWSyUBMXpFlqq999IdBX3sMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uru2qEmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4EF6070772;
	Wed,  4 Nov 2026 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uru2qEmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC6F1F000C1;
	Wed,  4 Nov 2026 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829047;
	bh=384s+rSNtMHGR6z3JtzRl907jI1SZVHfXQ2+1mPapNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uru2qEmTJ3ZZWfeSHyGQiQG4Bjmzu7TrJU6FU0URv0KrZj9hkGlnH1WqikBBbCOBN
	 oI434l/UDSm9/dhDoujRgKc0f4B6XDcDbhZ7n0ki1/ZbwbGp1r6NBM11B4+TVl+Sem
	 oO7SQl+wcvi+gdgk8BE6GZnRiEvY1JLY+dYmOSjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 410/547] NFSD: cap the number of listeners accepted in listener_set
Date: Wed,  4 Nov 2026 16:09:54 -0500
Message-ID: <20261104211049.969019549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9a05e5ee0a98b9550521df86936b5f825bc07ec2 upstream.

nfsd_nl_listener_set_doit() matches each requested listener against the
existing set. The nested loop that does this is O(N * M), where N is the
requested count and M is the existing count. The loop runs under sv_lock
with bottom halves disabled. A userland request with a very large listener
list can therefore spin in atomic context for a long time.

Reject a request that carries more than NFSD_NL_LISTENER_MAX (1024)
entries. The check goes in nfsd_nl_validate_listeners(), before the code
takes any lock. The limit is far above any realistic configuration.

This patch does not cap M. Only the message size bounded N; real sockets
bound M. A listener_set result set is the requested set, so that path also
holds M at the cap, but __write_ports_addxprt() adds two listeners per call
and removes none, so repeated calls can push M past it. The worst case
under sv_lock is therefore 1024 * M, plus 1024 nla_parse_nested() calls.
Both interfaces require CAP_NET_ADMIN.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-1-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1973,21 +1973,22 @@ err_free_msg:
 	return err;
 }
 
+/* Upper bound on the number of listeners a single request may carry. */
+#define NFSD_NL_LISTENER_MAX	1024
+
 /**
  * nfsd_nl_validate_listeners - sanity-check the listener list from userland
  * @info: netlink metadata and command arguments
  *
- * Walk every NFSD_A_SERVER_SOCK_ADDR attribute and confirm that each entry
- * is well-formed: it parses against the policy, carries both an address and
- * a transport name, and the address is long enough for its family. Doing
- * this up front lets the callers below assume every entry is valid and
- * guarantees we make no changes when the request is malformed.
+ * Walk every NFSD_A_SERVER_SOCK_ADDR attribute and confirm that the list is
+ * not oversized and that each entry is well-formed.
  *
  * Return: 0 if every entry is valid, or a negative errno otherwise.
  */
 static int nfsd_nl_validate_listeners(struct genl_info *info)
 {
 	const struct nlattr *attr;
+	unsigned int count = 0;
 	int rem;
 
 	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
@@ -1996,6 +1997,11 @@ static int nfsd_nl_validate_listeners(st
 		struct sockaddr *sa;
 		int err;
 
+		if (++count > NFSD_NL_LISTENER_MAX) {
+			NL_SET_ERR_MSG(info->extack, "too many listeners");
+			return -E2BIG;
+		}
+
 		err = nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
 				       nfsd_sock_nl_policy, info->extack);
 		if (err < 0)


