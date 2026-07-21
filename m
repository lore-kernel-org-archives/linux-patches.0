Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC12E736D;
	Tue, 21 Jul 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654579; cv=none; b=sOLEGpth4zXUolnTbkcZgjWrFXvpQLBeKO8Yi5itaheSt+b9dENsQbR6VUQO/0PBssOoaBNrw9N8V4DVS+eodq7M5T4xupmcnahp3Vrcj+aq7d86aqcL8ABrRnK0IdwX3HQWk054ssKBcW3HDSCnIejj+FoZn2TTGspSsf4qdSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654579; c=relaxed/simple;
	bh=n+RAd1nTcJoL1CIoKQUIgYRgLjhCL2LlOfZiPIfgOu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyHNJbDE7iYP8BjjgKnqqwrLpijjao5RW29t39naYoUfBOBCic0zNw39IE2G4EP8gB9gxK95Rw6sPjrTdYywDa6qBz+r5OymZVOT2MCpKI4vlohuC6y2HSQzAyGCS4YpsQeWtvb2RUHJEPpgchr3QPQYAAZaKXeRqy0nxVcxSyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiGAI5xI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiGAI5xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9401F000E9;
	Tue, 21 Jul 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654578;
	bh=x3L7GVr+zdPwgS1kjYJSI5pz+sWZ+SqQi+V2PI5FekI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiGAI5xIlVT6IdJwM15lxWmrEJw6jPO5282yWDT77cEI4SPtyKlALLYbt5WNPcGSz
	 HdBxbbiqnYZPcQpkiQPYJd8htRBlQgbDzw4V0yWRb4sEwT8avVjKd2oNuphpMzff0S
	 p+R4LTN1ADd7cGllajqacX5NTEdK7pmYuukvOAOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 1705/2077] fs/ntfs3: validate lcns_follow in log_replay conversion
Date: Tue, 21 Jul 2026 17:22:58 +0200
Message-ID: <20260721152632.974471394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6a4c53a2e26a865565bd6a460961e8d6fcb32329 upstream.

log_replay() converts DIR_PAGE_ENTRY_32 records into DIR_PAGE_ENTRY
records when replaying version 0 restart tables.

During this conversion, the memmove() length is derived directly from
the on-disk lcns_follow field:

	memmove(&dp->vcn, &dp0->vcn_low,
		2 * sizeof(u64) +
				le32_to_cpu(dp->lcns_follow) * sizeof(u64));

check_rstbl() validates restart table structure, but does not constrain
per-entry lcns_follow values relative to the entry size. A malformed
filesystem image can provide an oversized lcns_follow value, causing
the conversion memmove() to access memory beyond the bounds of the
allocated restart table buffer.

The same field is later used to bound iteration over page_lcns[],
so validating lcns_follow during conversion also prevents downstream
out-of-bounds access from the same malformed metadata.

Compute the maximum valid lcns_follow from the already-validated
restart table entry size and reject entries that exceed this bound.
Reuse the existing t16/t32 scratch variables already declared in
log_replay() to avoid introducing new declarations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
[almaz.alexandrovich@paragon-software.com: fixed the conflicts]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4262,13 +4262,26 @@ check_dirty_page_table:
 	if (rst->major_ver)
 		goto end_conv_1; /* reduce tab pressure. */
 
+	t16 = le16_to_cpu(dptbl->size);
+	if (t16 < sizeof(struct DIR_PAGE_ENTRY)) {
+		log->set_dirty = true;
+		goto out;
+	}
+
+	t32 = (t16 - sizeof(struct DIR_PAGE_ENTRY)) / sizeof(u64);
+
 	dp = NULL;
 	while ((dp = enum_rstbl(dptbl, dp))) {
 		struct DIR_PAGE_ENTRY_32 *dp0 = (struct DIR_PAGE_ENTRY_32 *)dp;
-		// NOTE: Danger. Check for of boundary.
+		u32 lcns = le32_to_cpu(dp->lcns_follow);
+
+		if (lcns > t32) {
+			log->set_dirty = true;
+			goto out;
+		}
+
 		memmove(&dp->vcn, &dp0->vcn_low,
-			2 * sizeof(u64) +
-				le32_to_cpu(dp->lcns_follow) * sizeof(u64));
+			2 * sizeof(u64) + lcns * sizeof(u64));
 	}
 
 end_conv_1:


