Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D793351E424;
	Wed, 30 Sep 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790300; cv=none; b=Lwr/hNyE1LpEitXUf9nIKIcipQVWcAvmLZv5w8vYwM7PdXhrhFu5oghc16v74miJK0XUvc2K4/PAdSJTBQku6qPbF5LGGbU7xivPCq7+d/uXZnKNvEM/cuT6/fReXCqqAkoC2cZjpqqDO4i4enMLbz6sYDEnW4l3YzWrPd8jfLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790300; c=relaxed/simple;
	bh=wgnqVHGp6jTEbX2A7FggLfFtnTv/CJtocJ/Ws7S21Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+xXD1aCTjsamaOjhVIRUGMFbN58GIGJEbNl5WBqZLljLr7UsuHKmrgLTT3jjUC/TUP0Yz7oEG7T2vaDa7rO84d9XAcdGTZEvMNXBKvv8SViY8B1wQALaMzTixLR7bKvZGmZT8vmwZV7la6PYvBHjt3ZIRyBOcu3ejkFxsM4zg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xJO7huWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJO7huWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8221F000FF;
	Wed, 30 Sep 2026 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790298;
	bh=wlrlxewsk2jwMazMgl1ErhKom0G1a7IidLpVEOz/tUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJO7huWq+Sl1eoa3A4xftWquumFyBG22TR5815niwKGAbxBaadxtrUbp1PhtHAtNC
	 QXM0JlETgS8sXYDzIHE+/v54ROteFz6QUv5lp2ma/bOK840AxAHd7BSNdmbEb/0aPX
	 DYGbzsMbVBWpwCXvhiCLPfHCNBHKyCi+3/u2buKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 778/877] xfs: fix short ifork reaping computation in xreap_bmapi_binval
Date: Wed, 30 Sep 2026 17:28:09 +0200
Message-ID: <20260930152431.502437334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit eacb8479507756c3305994e87fb2fb1183827e98 ]

LOLLM got really confused about the update to imap->br_blockcount in
xreap_bmapi_binval if xreap_inc_binval returns false.  The intent of
this code is that we shorten the imap to whatever length of space we
invalidated so that the next iteration through the loop will start
wherever we left off.  Unfortunately, the calculation sets br_blockcount
to the amount of *unfinished* work, which means that we pointlessly
re-scan blocks that we already reaped.  This is benign, but we should
fix the computation anyway.

Cc: stable@vger.kernel.org # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Adjusted context to retain `invalidated > XREAP_MAX_BINVAL` instead of `xreap_inc_binval(rs)`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -861,7 +861,7 @@ xreap_bmapi_binval(
 			 * much of the mapping we've seen so far.
 			 */
 			if (invalidated > XREAP_MAX_BINVAL) {
-				imap->br_blockcount = agbno_next - bno;
+				imap->br_blockcount = bno - agbno;
 				goto out;
 			}
 		}


