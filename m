Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE8737C925;
	Thu, 20 Aug 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238555; cv=none; b=XfiGKvhNtGcpWDj8Yq8Ykpvs0YFB3C5mdWcy/Z4VilyFQ9RCCcXSe6BWDDyFK4fXsKDeaa9rzO2/Wp7ER1dLQfiAjd27eZ/RrScE36l2+bkHKrc6zd4MvYej1UDUPkDFTJLl3Dm4LkOlx5J3EfqxLTPKsEQlZZcJeTeJ6UPNi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238555; c=relaxed/simple;
	bh=TIHidSA2rKB1tFM5FHoJFNXGCdtd6IZQ3lXxXlRuwYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmD398IRV0Zez8A8Pyg1g6l3RIqgoeeiJadPglEa4mtUd/SjTG4OWJuVZMGsS+rNbYAip4kDWhf9rnDQguKPtrkmwrDdftPqyHmOHWWB4Gx9BDgQQv9z3CPxNtA3IwsMWS5Y7JSWwBlB3Vvp+TPo10VovBsEbAKEVoESO/xJX9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvQ0C+Iu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvQ0C+Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EA1F000E9;
	Thu, 20 Aug 2026 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238554;
	bh=HS77LZgh6Ryh5jgavpLpQBRPWAencJrYql5YyaDHtK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvQ0C+IuTFndDLY6XJF45nE4lEqv0mJm9ddaYxetKAcs7ZjhZn2hqYw2iIj4qijOK
	 yhAkWxc3N4aCT93FX6AfNLz1ia0xNWC2iBjT7PJVR+BPP6fLMojmsPOGu6Ph4q5mp1
	 FmPmiqjo0YJvQdJfBmm6D1+WMNUGWXvyU44jETPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 149/228] xfs: check xfarray iteration errors when committing unlinked inode lists
Date: Thu, 20 Aug 2026 16:54:51 +0200
Message-ID: <20260820145249.153678027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


