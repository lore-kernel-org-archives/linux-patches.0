Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032317;
	b=uZqzoSlfafZiXv51d/DSNija9pDcwRqpstENeCojdhGa0e9ECZwKopoNot8G1tvK0P36
	 4qhki7PQx9ub84dXj+q0HH57AjI5pFSqN55DCFiYvLpgALxew9XCyurkiMoPuOmPcGVQt
	 C/58H277HU336jp8KukuhOT4a6/19uyC6rfcCRjKixS5T7L2RvhQt7uui6uTFbwGkCVIi
	 wwbU4m2erxdtbAalFyxe4C4Fbwfi/vop0lXrbLiUi1Skg3PbXMHVFy//adeD36s464div
	 QIWPGY96y71p+8WG31ddkcOfQBLdnKqNZn3hZ8Drc+v/85YF2QAUWkGCHyTKkE/GuvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9YXbUdf0fF8NXjbTiol6OAshbe4LxJ2BNODzsBKneo=;
	b=hI6Lim0NLPRG9iCk+n68rEn2EcClm2lgUE0DpwpKDRmb/Ot2D0MZJb6lcrCyg84cPhf6
	 1oLYdYcBxudfE+Zz7iewBUKqBEBDpvj/+QvqJg1KnzEhdBql1FWoUm+nQxyxOOGxwCLBi
	 hEHK3ir4UYb8yrbf8le9+ybZltN07GtC9VhgWLvm7p8Ox7UpypX3r7MVfPcNhKKoM8QhL
	 /t03EEgJD5OneBF1CNk/0c1GZwhvqGFQ8YSzZQoxpX3/eq+rJDHnzWyOjqpiWr4uoLiOz
	 yi11K/bCp5b6luXaqwNheBNVwapW8/6DiWSTEgl9ofwOFL2ngBVSbNG6vEuR0ZyJ9sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgrfHhfn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDAE606A337;
	Wed, 18 Nov 2026 20:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgrfHhfn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318C31F000C8;
	Wed, 18 Nov 2026 20:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032316;
	bh=E9YXbUdf0fF8NXjbTiol6OAshbe4LxJ2BNODzsBKneo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgrfHhfn12wCkk93g+q0ZWO+PY7N9BBkSFL9GdDl6z4wHHYAdQobm6RF7OhqFJmwN
	 o4z1c3C343lpvntIbjgxnOJSBIGie/CMNc2gkJ7y/K7T/lRtrCa1HmMbbmZfN8qX9J
	 9DSRPf46jkBf1RJXDIHbddJbSyCGYJYjJxoz1vXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1367/1756] bpf: Update the SRH state if End.B6 fails late
Date: Wed, 18 Nov 2026 15:58:14 +0100
Message-ID: <20261118150103.667607668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 427e751a231aa781441d51c42e716905ee348099 ]

For SEG6_LOCAL_ACTION_END_B6 and END_B6_ENCAP bpf_lwt_seg6_action() looks
for the SRH again only if bpf_push_seg6_encap() has succeeded. That
function pushes the new header, for which the head of the skb is
reallocated if it has not got the room, and then looks up the route to the
first segment. If there is none, it returns an error, and the pointer to
the SRH in seg6_bpf_srh_states still points into the old head, which has
been freed.

The program goes on behind the error. bpf_lwt_seg6_store_bytes() and
bpf_lwt_seg6_adjust_srh() read the SRH through that pointer.

Look for the SRH whatever bpf_push_seg6_encap() says.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 64fb3b3b03146..1dc436c4e0f8e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6709,8 +6709,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLINE,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	case SEG6_LOCAL_ACTION_END_B6_ENCAP:
@@ -6718,8 +6718,8 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 			return -EBADMSG;
 		err = bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6,
 					  param, param_len);
-		if (!err)
-			bpf_update_srh_state(skb);
+		/* The header can be in place although err says otherwise */
+		bpf_update_srh_state(skb);
 
 		return err;
 	default:
-- 
2.53.0



