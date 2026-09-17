Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00580583ABF;
	Thu, 17 Sep 2026 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660607; cv=none; b=pgEJLx+Nls7lE0kF7u2m/IK4HiU4vTaEZvnnofPB+mbFZkLEw4tn2ATtW0C4bI1BcF7Mk4KKxlvIOpdnG5NCGPDbN8z97hjyJs7Mfb+rN735h/f/M7idlZDU1MtERdBlFGl9XgAy1gosB/FocDdxvqgksy6zX0NnzXa9pHFIIe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660607; c=relaxed/simple;
	bh=l9nshNg0m48j34ibyzys7lYXBHUtWu+gbqT21HLfL68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCN0qGAaDX57zzLYLjxwivbLubvLo1AcZ4z9+bx3GBOZuKfeuy1eAg0ufKTAwnhIXqdLXJGoZDMi8N/w3hV9kDSbqsnOGs8HcaZGsmtpUmmSHbMtBzLWRh8+KjGEIRvMEitNf8y3Y9FrDCpGJvIfFEyjrv5VJsIaXrMlCoPq8Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnv4//n4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnv4//n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555351F000FF;
	Thu, 17 Sep 2026 15:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660605;
	bh=3gbFTMwog/d49SIIQXWDe2ivKEKba2Xa/TyEtStsZ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnv4//n4eLS3RxGWG016jD3lvONTqeiOXQSx7BERphXf2JQy+o6rEjCNM4ZMEIgkk
	 MC3Njax0o5jLr+KquU1CUCWYpj2gCfr93x7ZnA43kSiMiB4mWQcNHUJtbyC32cEujU
	 QmwOFJgM7HBaZwBCO/KyOZwYPpbWWVlHiUZCd1Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 647/733] xfs: reset parent pointer args before each dir tree unlink repair
Date: Thu, 17 Sep 2026 16:15:55 +0100
Message-ID: <20260917151408.732553071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 69e10c2b4a51b4ff3c88a70e90f5180ad58c758f upstream.

LOLLM noticed that xfs_parent_removename only partially initializes the
passed-in parent pointer arguments object.  In the directory tree repair
code, we could decide to remove multiple links to a file, so we don't
want state from one call to bleed into the next one.  Zero the whole
thing explicitly.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -479,6 +479,7 @@ again:
 	}
 
 	if (xfs_has_parent(sc->mp)) {
+		memset(&dl->ppargs, 0, sizeof(dl->ppargs));
 		error = xfs_parent_removename(sc->tp, &dl->ppargs, dp,
 				&dl->xname, sc->ip);
 		if (error)


