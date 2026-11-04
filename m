Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829017;
	b=V04c45+VcQoxrOaLkbkQn3/VS7NO/BC562OpgcEGlrgJbC2H8AWsir+tt9LSCEPjUo7O
	 fh+4jaQ53q1v0LrE4zUQKjYmjpTkPUy95xowQj+rfLck3UN8THUb5iQ+r8xSZK+jfrOO2
	 zaWRoP48uBhM4R1atxa8rYbcyIU49VND39m2GCt3CjCjAV1U4TK+FqGV+dH1oGdXbDJJR
	 fVGrSN9Vh3BbILDaX+X1vQOgq+7+rITmQYU7UAvH62OPq05IUM6pl1q+SgWpv/ruiveOV
	 T+2WXnLOhlBzmcl2rrmxrEXn6j/IPxSmc9YGABTnmZAkTyg/vePsPqVhqyljdRF/Jdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u4NFEFHTUENFy5tUjmpOLbJTR/m+eydB7KiJcPOkBHA=;
	b=0LT2UmM7RThf0GFRhzGfzPfTlSEKzLSn6hF25dOwU77Ig2AKW+l7CRUlf0BAWDnCXRhg
	 jr/JnwGZqXS90N08uqEgopse4NeqS+xZdW8tNJqfi/p8gmftS7nGhAKIs9FxbvompyukO
	 ygdQS68DqFQYwoyDvZbIv7/nJHwdwd7tgT5xXKiILMfhvE5LHPW1BmAtkKZ9b26cXOO5S
	 dFnLGfTQZzzCM43aSvxmM+C2NKU4texH+8if2AZ8YpgA2mv5359+nW/p4nvjyeKMoFGvJ
	 qKoCDVjSnaaNOr0RgyFFlDmmHNsuomuqHcKUiSxwtrsRbm+AzLN4cpA3BRg7n2KcOXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YP2M/riv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E6F607074C;
	Wed,  4 Nov 2026 21:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YP2M/riv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAB91F000C1;
	Wed,  4 Nov 2026 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829016;
	bh=u4NFEFHTUENFy5tUjmpOLbJTR/m+eydB7KiJcPOkBHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YP2M/riv+ROuSSHsO0Zwg6MAIyaer7nizNjYPCwjoU8d4xh8YSOZFXFeNIfIX9xQP
	 rWCDmvdPZvyu1qgH8lxNQwICJ8wWkkrITb0K3AjdPiF/sajf6AthpZSy6+jUDwj7YP
	 cfwnLhEQe9IgS8AXCnfRnCXwxbKrK7bmUI8cWKNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 351/547] xfs: check for termination during rmap btree walk
Date: Wed,  4 Nov 2026 16:08:55 -0500
Message-ID: <20261104211048.246072704@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 1fc241cdeab276dc6c3ec14840faa706ed7712ff upstream.

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -227,7 +227,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {


