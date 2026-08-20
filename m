Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1469A380FC7;
	Thu, 20 Aug 2026 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239148; cv=none; b=fWwyK+jJvZHw/HvhaftY4OJT0AHXLDDLOgMpp9B3G2ZlKwaAzZpYJAQTMnEO9smxV10u4f16Fbjj6GNK6Oj3QOJZ1WdIyCZ1kcAt2QttiwB/R1G4OBLTGlQKhx457oDJ59U8NUOy67wawtodITDkLl7WTUieK50UknRkWtc81z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239148; c=relaxed/simple;
	bh=UZWbngSBzCwHBxb7w4/+ucwfrBW20v0BjdERzK1e9J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb3pVxCAAfqC77KABuJxvaBayFyAVSe4r6iI3yN69lT/ysofEAtCTiAiig4kzWChQa40dYYvdKFwO5CuKSyis7KIYc2wzKe3oFAeQHAoJhiJIYXTu/SMr1T0rA/PR8riVMQt4HeZlC2WtBsyQZc9pFnxqB8JNSrv8mhCSeQr+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE3vz/xm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE3vz/xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5A1F000E9;
	Thu, 20 Aug 2026 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239147;
	bh=j8aP47XdphdEb5Xjqawq+Qqpgt9DZ558U20zG16PWyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BE3vz/xmZaHgKoSBhTQ4njCd2I8fJ4n5rdOdiofbfNMGhy7w/HP+oBhh99099w+cZ
	 T8hVSk8eB4fyFomDUaLKcuEYRr8eLLDGLSMU2OcWRLLg4kqRYPdqcV6yrUskQvqhGo
	 VCrixOAaGfOvy26quiFH6X3vfNalSn6c6YaTb4kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 127/217] xfs: check xfarray iteration errors when committing unlinked inode lists
Date: Thu, 20 Aug 2026 16:54:55 +0200
Message-ID: <20260820145241.555137624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

commit 2daf3ed5d059dec79c123aec42eb8d28e0c016d4 upstream.

LOLLM noticed that we neglect to check for xfarray_iter itself returning
errors when writing a new AGI.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1752,6 +1752,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Fix all the back links */
 	idx = XFARRAY_CURSOR_INIT;
@@ -1760,6 +1762,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Copy the staged iunlink buckets to the new AGI. */
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {


