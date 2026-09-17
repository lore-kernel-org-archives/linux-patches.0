Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D86A4E020A;
	Thu, 17 Sep 2026 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660684; cv=none; b=EuaIvTS5Vm5l42GGJn1ZZ9TbUI79i6sWXVQMaAgpkEgSXIejjSdo40lOWd7GEgeeE3oA/N/8CpCmH73PYR+dH06qAqSOgxPQMdEofC9K65ycPyjzbFf7dT7N6Yd+QwFtJda/wc5fqvwhIk2xho2OukOlvKG44IMeKRZfHn/gdpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660684; c=relaxed/simple;
	bh=dJTFXcSfBn1tAP6rRmR4oVCC8/w2HTccBlHp8opBSeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoxbzkKX+866svX/OGY2ZhuRWGyO+9SimxZv3/LvgB2e8VMI5I3vfYQEdCf0T6ZOvK/0Bm94BlZaRVRRsECcIlfFX/WqFB6Bn2ub9gFMEHiKA87g+aJbnekQtNI69X949qnTd5/YezosGet6gA6pyXjKJ8v+eHa6fnp7aEeAS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uh0SfGcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uh0SfGcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1EE1F00893;
	Thu, 17 Sep 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660683;
	bh=/VNO0OBwxmevI+rRPZxHmVgUZdwfPJaTkiPak7VcJ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uh0SfGcDQdcFSfvLK3g28neacNL7LUNlwsfOhrA7vlbOQiuOgQdPxxnkJh47d+Pkq
	 CiZh6lcz21pZGkuvy4T5x8YXBEK+cX9d7Qt7quaeHN++1ZyHFPnjv6YtQWoC2JDJ8I
	 C19YpfblCSMYI6tMQmS5wD0KO1dPBxpg1OKJRkXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 675/733] xfs: dont modify file attributes or poke fsnotify for dry runs
Date: Thu, 17 Sep 2026 16:16:23 +0100
Message-ID: <20260917151409.563216758@linuxfoundation.org>
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
@@ -504,6 +504,9 @@ xfs_exchange_range_finish(
 {
 	int			error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	error = file_remove_privs(fxr->file1);
 	if (error)
 		return error;
@@ -783,9 +786,12 @@ xfs_exchange_range(
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
 


