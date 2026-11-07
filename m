Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061715;
	b=SSOFrO9bpS88yX1rXZazI959rtbwfDm7Tmgjm/uWBBPFppZ/28NaRBx99xJT8qoouLHf
	 yFckJfisXURxfkC70uo9z2tMxFgGXVWhux8sQqPPq9NeX4GUsI8aVNn8O0a1E6PhTdEQZ
	 QrJ+BbZborU+CQjodcv3oBLaC4N9/23vWIhsYCYAfelPf37PFAEMM1rhpnKe7tKR4YXxE
	 s0OeKY08nVYu/r6XJ8DajLJQZm8IX4vT3JDZVoalAk4fwTN6YXiahgCJf1o4/YHKjA3Tz
	 rrLQcx00L07Lzn8G6vevdV5Z5SUerXvx7yFgStyAqpE5PAupBO9GSOsAkeRpwKQ/GFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KIAsBTwqvvbnrmgtvq85OSM9LXbQgvsHkJjNuW8P15Y=;
	b=XJ1aTIlkQM7f7ESWbO+vUZnGa3mIGavt+PPPgB2SvEeJ9/UTCqjaFaJq7GXT0bQKf+Ej
	 ONOQ+BqAVyNG32FnP53TGuxihfqGtdRLTVNBAEr2w/xAPgm8/wmoQwyhBaZnRorECvp5H
	 riLdA51BndXbiUQdSTEDDON6S6QAl0rv8OzDLDJei7bMYiPQUCa3NcZ4s/u/jhe32/DcC
	 oA4EuRLovk8O4/XZbyh5dMm6jSJB9j4K8S7/ukJwEpbQg5VnxduUUKXL+Jid6rbVIADe9
	 eG/2QK4oAtjEIdAZHS5bm+EaGkbMKUnQZnE+Dkm4H6Dig6Ga0QZ1mvLbxHar3xd/gaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n0+D4/46";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DF606A32C;
	Sat,  7 Nov 2026 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0+D4/46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6091F008A1;
	Sat,  7 Nov 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061715;
	bh=KIAsBTwqvvbnrmgtvq85OSM9LXbQgvsHkJjNuW8P15Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0+D4/46XjZ29ea3eIFTpc9SbqbTV/1s4h2mPQH75xkKKbouRizvN013SMQbQIn3J
	 cLzIyAsSVEc6DsKQaXSSr860HtEAoYsUiM99irpd7fS88K+JoQgmI+OkZ+5JFTy1Ek
	 1bHU4h8IXf2gmr89uKRyt9MazBBVmKbMqEEQCEqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0744/1536] xfs: opportunistically skip btree block checks
Date: Sat,  7 Nov 2026 08:46:00 -0500
Message-ID: <20261107135018.424857074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 4ce244b234c251963fca6dff9de6edf26a209d08 upstream.

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: stable@vger.kernel.org # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -608,6 +608,14 @@ xchk_btree_get_block(
 	xfs_btree_get_block(bs->cur, level, pbp);
 	if (__xfs_btree_check_block(bs->cur, *pblock, level, *pbp)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		/*
+		 * The btree block fails basic checks, so we know it's corrupt.
+		 * There's no need to continue looking for corruptions, so we
+		 * null out pblock.  If *pbp is non-null then it's also
+		 * attached to the transaction so we won't leak it despite the
+		 * 0 return code.
+		 */
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)


