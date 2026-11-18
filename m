Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020976;
	b=sIp02kowJNXbFBCTS2HGy0Fesixqq/q5482hOzIahi/hBezfwr6Y5PRkQ+M/4wLaqadX
	 Cos0JjNKi8AqKLXrMJ8eXHdzhTK8Tuwr1smmw230lF36CWBmhcnyXLXe3kJ1EgJ4bpPSm
	 PQiPVwedLO59Wn0J9Ck0JWWOMlOyH9Ypwg+KBrk5AsTGFxL7g+lEU/az5g+GVrGTK8j7L
	 n6SXC8P418+HemsUvqTyy8s7w6vBoL6onQtMT0v0iqc0OYRpx6K9PYIRoLxqMpCIhSKcQ
	 fistYi0FoDK9q+nmKFtPktMRbRKRWo0NDImuK7kOgKVDmXGp0DFUadcJdyo98TqZRig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxZeJctNodOemr3M0bWAwlFHaYqS5rvzZvUa0h0j3iw=;
	b=pcWWTWD9NeUi16g0GwIkHXuSWAR5rRaX6oQGyvuIKPReKRYaaaKQvv780KKTamOyGMKj
	 6vxIWQ1XDGBHJCuiYd/vuHvZVIKBfc0tSvUDlmMMVjhM4Dn2nFIsKvTBiaDLN18sZ//k4
	 vcPUgPBoz2zlibRUPLUBvkoa0mwqi1iOV97iO6OONcWkOnqWPdcbH1CcFaHd0aTQB32ep
	 vvk5Gq1SXpiyvMu2yXy1YXLwXFhePnwJoBfho5R4utHzEL5EERSOw6FoGHLE4A0Vjgurb
	 +GlTSOiWRJnqujjQp9lGSemohLVvSStd1OHeSB2nBPZqTuRHzNL23rtkzDv3sxr7DDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLsw0z+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AF606A31C;
	Wed, 18 Nov 2026 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLsw0z+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38F51F000C4;
	Wed, 18 Nov 2026 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020976;
	bh=KxZeJctNodOemr3M0bWAwlFHaYqS5rvzZvUa0h0j3iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLsw0z+jh8CIXg2+aHZSJbPkEDFN9ak0VcCi3UCrBfnCtQ4h3LO3puAw9mH0R1+ZA
	 BfqLh64zuL5fNcFZFmKW9+81jFdbEMK5wrFmIOJP4O3y1idL17E1xF+wS4DUofFWmh
	 LREvU0ulGNcILUPx4NWWHX0Kv373ANvOmVQ5zBKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2103/2651] bpf: Fix NULL deref in the sk_storage map iterator
Date: Wed, 18 Nov 2026 15:55:43 +0100
Message-ID: <20261118150401.687605298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6186c9711ac6fb984f6c2093c52bf4e827cc50b1 ]

bpf_sk_storage_map_seq_find_next() hands out an element only if its
local_storage pointer is set. __bpf_sk_storage_map_seq_show() then reads
the pointer a second time and dereferences it without a test.

Since bpf_local_storage_destroy() unlinks the elements with
bpf_selem_unlink_nofail(), the pointer is reset to NULL when the socket
which owns the element is destroyed, so it can change between the two
reads. Reading the iterator while sockets with an element in the map are
closed ends in a NULL pointer dereference. The sockets need not belong to
the reader: where a program gives every new socket an element, an
unprivileged user who opens and closes sockets is enough.

Skip such an element, as the TCP and UDP iterators skip a socket which
has been unhashed.

Fixes: 0be08389c7f2 ("bpf: Switch to bpf_selem_unlink_nofail in bpf_local_storage_{map_free, destroy}")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index b5349bec56957..aea67b446c7c4 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -813,6 +813,9 @@ static int __bpf_sk_storage_map_seq_show(struct seq_file *seq,
 		ctx.map = info->map;
 		if (selem) {
 			sk_storage = rcu_dereference(selem->local_storage);
+			/* reset since ->next() looked: the socket goes away */
+			if (!sk_storage)
+				return SEQ_SKIP;
 			ctx.sk = sk_storage->owner;
 			ctx.value = SDATA(selem)->data;
 		}
-- 
2.53.0



