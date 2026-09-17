Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C454E7815;
	Thu, 17 Sep 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666859; cv=none; b=gZBl6S8sCieitek89Bsk4ZLrX+wAWQl8CQyVsoYj/UU+sdafYsIRtLl0lc+gItUGGG5PsyPsyfdJFfyjSyuWQw2KmZ4vyIktuUKnP0HSIt+P+CgWlG+0t4k9q2e82abZsyIOkkAPKZ1hmiWp0xlTxjYFdClSNk72iFh53O7hxeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666859; c=relaxed/simple;
	bh=rVUwpWV72sRjFMDLPSEV0B9qhqeEBZSBXwj8ez4G2bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mItY1H4EBY7Vehko7ZU3z69CK8NRRkt6mV9yOcYkdG8OIYETH8+R3nggk45Nkkuuj6IRfyKoRbep62K6iIUPB0F6lU1bD1gc86oEFH/1TRas6jl7CBlRHwaeXx5/JS6BnRH06ik6EMtE/2PeuoWVh9a3gjtVkJAjFglkWcDEkW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRC4oevZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRC4oevZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C56F1F000FF;
	Thu, 17 Sep 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666858;
	bh=c+oHTXs4d14WQuJdGH1/zMGcNQNE5lwEWCmMG07TqAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRC4oevZztOJAwwG/WKK5LaQr+iN5BPCM3W2SunFq2gcOTCsdMUnFZAyu+2jxIJnw
	 BwYOyAYYHbQVNfSzoKilgwAbdIpM4jtKP2t0q/h0p6dfhw/A++yz44SMSWuJuHQSZI
	 /Eh8t1G/Dl2dpwcqds18Xr/rcCcBhSVqggjNDdJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1110/1250] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
Date: Thu, 17 Sep 2026 16:15:05 +0100
Message-ID: <20260917151622.288720685@linuxfoundation.org>
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

commit cdc4a083adf7bf15a0722c5bd292a35e00112006 upstream.

LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
the child metafile that it's removing, but initializes the parent handle
using the child.  This is obviously incorrect, so fix that.

Cc: stable@vger.kernel.org # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -397,7 +397,7 @@ xrep_metapath_unlink(
 
 	/* Figure out if we're removing a parent pointer too. */
 	if (xfs_has_parent(mp)) {
-		xfs_inode_to_parent_rec(&rec, ip);
+		xfs_inode_to_parent_rec(&rec, mpath->dp);
 		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
 				&mpath->pptr_args);
 		switch (error) {


