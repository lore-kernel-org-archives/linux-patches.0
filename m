Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7F399D0B;
	Thu, 17 Sep 2026 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671245; cv=none; b=rUBtSVS33xykHtImGeQT7BZIIBSCTuD9IQbx+X/oc35Ox9OamXjB10f5o9jyzQfEc1Z6s0EsaAXovmfzeaRRUlkYAqzdQrIUhfNJTC9kg1hMsF/Xspkox/atekokVHGJf27z42ZlnQv01mH6dMA4EzNzLoYmnjwR3LkX6MkStJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671245; c=relaxed/simple;
	bh=+DX84dhFw3DNANcPe2wisHJhotT9IPIsiQ6TYgyi8mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R33t/mLdKN2Mwy0Is0RKJK2PRuFDaIFVEc20DykCsQMNoh0LMAMSpKIH+7kCmNSjETkvaIV74vQtlL1qGfP97lCmbzDVbTn18+LtcV4ezM573hVzLZCrW7xq55MA8UeN7qC9SGS0u3YtjSO/J8fOWJrIF/e+nsrJLENaTXfhoVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGDtzGnd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGDtzGnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E891F000FF;
	Thu, 17 Sep 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671244;
	bh=9f6BBxVUkQ8O4sDsOueJwX9f8X1ODgFXE2v8gTL1Zwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGDtzGndeqN7PaqqOPijHGX9vW5O18Fg0htrFlT/gHBofH1XYZVh9yY5cyiTBmauO
	 cE/ndapBRonDQTY1nIqDjsTIzJKiw8hveDMLUfAgYSj/+cfEjmCQXhb0YoG4s72JTO
	 f2eUaCZ2ct/yUolFxNa7eVZdAb5yHHYgm/yKRLY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0912/1102] xfs: dont modify file attributes or poke fsnotify for dry runs
Date: Thu, 17 Sep 2026 16:14:15 +0100
Message-ID: <20260917151603.508611561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 365fe37e10ea75840165f13322aa8481ea11dfef upstream.

I noticed that we shouldn't be removing file privileges when doing a dry
run of an exchange-range operation.  LOLLM also points out that a dry
run shouldn't poke fsnotify because we don't actually change the files.
Fix both by gating them on !DRY_RUN.

Cc: stable@vger.kernel.org # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -501,6 +501,9 @@ xfs_exchange_range_finish(
 {
 	int			error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	error = file_remove_privs(fxr->file1);
 	if (error)
 		return error;
@@ -780,9 +783,12 @@ xfs_exchange_range(
 	if (ret)
 		return ret;
 
-	fsnotify_modify(fxr->file1);
-	if (fxr->file2 != fxr->file1)
-		fsnotify_modify(fxr->file2);
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		fsnotify_modify(fxr->file1);
+		if (fxr->file2 != fxr->file1)
+			fsnotify_modify(fxr->file2);
+	}
+
 	return 0;
 }
 


