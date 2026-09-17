Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5418E4DDB45;
	Thu, 17 Sep 2026 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660683; cv=none; b=D24ZueXj6jqHYSTZmQ4ExYxLr16sqRfUPC7jlqGlVpuHHzHFRu8z/GQ3M4KW3alp+u/xOk1zGyRaXSJ/BBPDjqOjQavlkOm331NajA+iXHpVo+A4cugJ97mpBsBmzcj7YEoGekSJxhTcKmt+L5PsmOj2RR7mCvYdgMdNErpbOyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660683; c=relaxed/simple;
	bh=GTA/KRq2eOzi8SzTJyR+q7B6yPJ2wnMKoF2tTbC3+wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XShqxfy/2guhU/WcdEzgKuNL9prXI6eOiPHq7fuY4yfY2yNAC8EKjoVzb1t15l09A5FxFWP8mmEQlw7HiIw+B72PHX+wjuFIUUeo0n5q8ElSh3LKvrUTPSj51Gi5+s5Vy0i7J9PVmlJY/5vRPVWVLKm/YmbeMuE6mPx5tkEZuDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgAU6VDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgAU6VDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2F61F000FF;
	Thu, 17 Sep 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660680;
	bh=mkiYQlqpitaiq7Sx6bOMfJhkK7fVb0YK2mw2YDJQ7jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgAU6VDDCdp0qLhvVA1/KNXqzb9JgCgxF9vZYpzyV7XB8/QztVwfjFL9AjDMxJ5TK
	 laz1thOg/gOE5oyysMvm2LsVHcKmlu1YHkFODoAF4T0u85cy4sORK6LDt/jUbGd93k
	 fuvUkYintqAo6Oqnw0BzYbp0mrw8230X7xHt+mrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 674/733] xfs: dont spin forever on zero-length dirents when salvaging them
Date: Thu, 17 Sep 2026 16:16:22 +0100
Message-ID: <20260917151409.533055729@linuxfoundation.org>
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

commit 9f84792b40d0c96833341602144574bf0bd14a6a upstream.

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: stable@vger.kernel.org # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -484,18 +484,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 


