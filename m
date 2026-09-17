Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F274EF14B;
	Thu, 17 Sep 2026 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666611; cv=none; b=pI+YzwqrUfQeiOf/cRtnbkX6+GLFdJniYIzdcUEIc36Sfag9p+J/CZjytOckQ7uJ4NLiBE0R555/Nj1NnOcrowCAGM6acdsKEOH6QsZWqgCXVuiXQE5zhsCyjLlmCbwWT6ziOjwjZC+VlgIwO9clo+hoW3CdmGaG9u12PKVVptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666611; c=relaxed/simple;
	bh=aUKn6vRBUgHpal7fhIL+1Uk72weoEPAb4n55GzA3Hog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibOxNExVzO0RDN0o9Np2v616Ts12cL2Dh93NUUNQQ/Pymh22+dh0StHRhbC8Od0OI557hJR+s2G8ar/B+LrtClGNjvE4ZLQAwRduGRudgZaGb5dr+ke9IIfFamNAoweXJV9ple/AlVkbgLRxlRy69b+NMbyPFQI/3DNG9nRWOBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPmmfcAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPmmfcAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E4B1F000FF;
	Thu, 17 Sep 2026 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666610;
	bh=Kqhbd3Xx+GwzMcN/HhBxXVVdYgxAl69kY1VanefVfK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPmmfcAoZaGnddtshr+YSIPMLh/NIgW3UQ+p3wotGugGV3NYP/7JoDZlal6iZdJq9
	 m27ACr5HZd8f/pOB1eNBOhf/jiLjGYqmZ5almiZlxOR2zrhcL3q56i2YJYxTgwnf5w
	 TcuzRNCviVSfRTCOcKcLDAdvcnIz9Cry+EJbav2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1094/1250] xfs: reset parent pointer args before each dir tree unlink repair
Date: Thu, 17 Sep 2026 16:14:49 +0100
Message-ID: <20260917151621.821110160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


