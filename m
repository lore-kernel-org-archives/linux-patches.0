Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360823D3321;
	Tue, 21 Jul 2026 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654390; cv=none; b=fG+M5tHSBIvySXP/B79mHu1ltGohQh81bQW48CYNN/9hgLJ6qA3rJzBDWaA7fDmMmerHN/tmJRxUDW+G9Li9QEe3sJIOZix08pIl5DBkn3eib47RLzYxX9b0JWdBgZfI7PHgavZ7y+d3A0l3wS8/Kq+NyuWV5FrielchKPrsRrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654390; c=relaxed/simple;
	bh=aIoMtj+Ig0FjI3cJ1xJLB1jAOO2EpUubmnKM2Fzhbmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH2gYT9xtmI/O9fyhI0gLK8jLESOpVAwO4NFN+ihk1/lho9e5uMGt4HkrZDfWNmDsaqFjHJjoUS+RNMmyq06vYdfyYY7tuUvUv9FlPiZnygmKyyvzH2aBOs13XQVUQUCQE/JpRptUgn4zlEXkqOjEIhr+TP/JfJogRL9VULZR+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiRJuQMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiRJuQMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A0D1F000E9;
	Tue, 21 Jul 2026 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654389;
	bh=8oO6NWHtGK1oT7lXtAOBn1IakoisDux1xiOkK1Ym4pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiRJuQMQA2MYX7AllTQARMs82+2653VCYMSVvM13JCkZRdSrXi5P9MEYqETDPfani
	 y+mnwKt0bMPKs6BJDAPercZDXwbY1YkOquv+6Ye4i1hSg74KJmK5hV5QiAK4cNotIk
	 8WtQAm/3pvntvrxndFYBCmFh3MlQ3p4q8LPhX6Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1686/2077] ntfs: not change 0-byte $DATA attribute to non-resident
Date: Tue, 21 Jul 2026 17:22:39 +0200
Message-ID: <20260721152632.518871936@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 0aad21570197973af4a1b25b3fb8ed3aeb9e7670 upstream.

When ntfs_resident_attr_resize() cannot grow a resident attribute in
place, it retries after converting other resident attributes to
non-resident to free space in the MFT recrord.

Do not select zero-length resident $DATA attributes for this conversion.
fsck treats 0-byte non-resident $DATA attribute as corruptions.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -4621,10 +4621,12 @@ attr_resize_again:
 	while (!(err = ntfs_attr_lookup(AT_UNUSED, NULL, 0, 0, 0, NULL, 0, ctx))) {
 		struct inode *tvi;
 		struct attr_record *a;
+		u32 value_len;
 
 		a = ctx->attr;
 		if (a->non_resident || a->type == AT_ATTRIBUTE_LIST)
 			continue;
+		value_len = le32_to_cpu(a->data.resident.value_length);
 
 		if (ntfs_attr_can_be_non_resident(vol, a->type))
 			continue;
@@ -4636,6 +4638,8 @@ attr_resize_again:
 		if (le32_to_cpu(a->length) <= (sizeof(struct attr_record) - sizeof(s64)) +
 				((a->name_length * sizeof(__le16) + 7) & ~7) + 8)
 			continue;
+		if (a->type == AT_DATA && !value_len)
+			continue;
 
 		if (a->type == AT_DATA)
 			tvi = ntfs_iget(sb, base_ni->mft_no);
@@ -4648,8 +4652,7 @@ attr_resize_again:
 			continue;
 		}
 
-		if (ntfs_attr_make_non_resident(NTFS_I(tvi),
-		    le32_to_cpu(ctx->attr->data.resident.value_length))) {
+		if (ntfs_attr_make_non_resident(NTFS_I(tvi), value_len)) {
 			iput(tvi);
 			continue;
 		}


