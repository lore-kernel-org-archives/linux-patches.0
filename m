Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828967;
	b=n6jZbu5UsAYUrBUcRl6uAF1W3jUFMN3d7FG29PJunOhQe+9C3cLT3b+fHpVnX3r4CL19
	 /LIYwc3V+00URaH+HVjorMwFhCp/UcDQ8uuLAuEdYXFYjkJX/UvC/sYY1nySXx5wpytIq
	 pNyojOp0+peOdDmeC3tmrRsqjJc0CBMxfkinjA9mIcPx6Mcxn9M6Jz/LluwSRm+RjoBgE
	 3nrbxUDLfOFkE0z8R5tDrQ3bKrVe6+AEIcecBlivz7gGyebNzAp9a7kiHY+56hy2liWVT
	 TxI8Qu6R6n+ie9AsHCFcLskY5tr48kqY5hY5cMTSesWRvO3mqqR42slfyTg4krPTrkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25XPbZKxcajfInbNNhESqNHvSOubLZbDO2a5KG5hmaQ=;
	b=zyAOPkZA8BodGdwi1ryX3jEgh+P2hFVoMZdFKzGxPSocOa4Rqxw8AjquGbsYNIWo9wci
	 iqym2aJotY68rAdEhWgMlHXAhClJeTMUCWFiqXph5vzyoycgTIMRZ0ZdjfVvSh/zxJ2xb
	 WXBP1jorOBWj24yd9xaX58c9AiMMPLmw9bWQ1aF2huUZ1iennoakCCUlEJnoRiWNLlMKI
	 CRTjnBs1PMa4CV/NzhoGJx299vwM+cL9yJoSmltWMzjjXrW1zh54C09kDBX9BaR9gm4lo
	 Qhy/S99zTEi+hsDA5Y9ASmgUDU3f7Xw9P+ZyQr50WrUMl0b/FPCmTrUwt/XyIY2NpRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O15l/waM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65106607E922;
	Wed,  4 Nov 2026 21:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O15l/waM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039FB1F000C1;
	Wed,  4 Nov 2026 21:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828967;
	bh=25XPbZKxcajfInbNNhESqNHvSOubLZbDO2a5KG5hmaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O15l/waMX2ttWEERNB/4+ESCRJCrLIO+F5liKJBhzJrYJpzEi9Hg+n4kira12oOJ+
	 2G9zTVK5cSkJO5Z6m6FUvxxTEJQiULZ/g5rlDgjU1J7TwovZTdwABXSfF6ONKicTMZ
	 5/lbhKxasw+vfxrIHafo/9g1oQDtXrm3VApQ0U0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 359/547] xfs: dont rescan ifree and icount when frozen
Date: Wed,  4 Nov 2026 16:09:03 -0500
Message-ID: <20261104211048.487712878@linuxfoundation.org>
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

commit 18028768415e3c05ab7edb22d740e2f4dc52836a upstream.

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -384,6 +384,11 @@ retry:
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;


