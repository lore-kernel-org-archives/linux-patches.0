Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D131D401A18;
	Tue, 21 Jul 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654400; cv=none; b=MR3D+3cCfKzlHsQ9+Ik9KoLzLP2SQWmVOndwnDD79F+3lBfkHdogKHwiaaQfV8fs0jUKz/xG5iJ46zvnZiE+gheopvFVAiDjPjahdhiZtxCXFFrX9awA4Iw11sW2vnj/0ABGztQSZs9SUW95E59+kOM57LavHXSetzOGvpelhLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654400; c=relaxed/simple;
	bh=Hsv9U0gC4MPWqifvG0IwN58QhkQXeCOVljfJR+dWqEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBQgF6NaS6+4eCgEycgvN/PXchmKa2Vt+pXoDYDXj2UHLHXs0laNtfBVhXyzhHueLnMoFgQ7ZPS5CmUSy3nv0/lmYZgi49O9fRTh29n8/1/DbfPFHiovzVeDtBZTbwdzdf7ZzWG4fm35CI9lWjVbLzYPi8jbwfh4qvnRM6rqnZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtV+sof0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtV+sof0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF061F000E9;
	Tue, 21 Jul 2026 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654399;
	bh=Rmn00pUnwmvK1K4RrkCSdJ08SzcdPxH+xyE/kYqz9uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtV+sof0sUcncRWuNA9wNohAozyRpdfVMMiI9NU5TdeWIypYfNJKWCx4ApJLnBood
	 Nn7fhNfRNoMT9EUa2vcwxXkSp8UxDNXQ2oV95Z8AnqWfi1HjcXaH0AMO9X0Sj/6CH3
	 e411xPx4KU0OorikMheiA2YNwwBhp4Stp1egn3Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1689/2077] ntfs: update index root allocated size before shrink
Date: Tue, 21 Jul 2026 17:22:42 +0200
Message-ID: <20260721152632.590194168@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit e782ca90ceb798bb1811b214bf814216f11aae6a upstream.

ntfs_ir_truncate() currently shrinks the resident $INDEX_ROOT value first
and only updates index.allocated_size after re-looking up the attribute.
During that relookup, the resident value_length can already be smaller
while index.allocated_size still contains the old larger size.

That leaves a transiently inconsistent $INDEX_ROOT layout and prevents
lookup-time $INDEX_ROOT validation from being enabled: validation can
correctly reject allocated_size extending past the newly shrunk resident
value.

When shrinking, lower index.allocated_size before shrinking value_length.
If the truncate fails, restore the old allocated_size. Keep the existing
grow ordering because the old allocated_size remains within the enlarged
resident value until it is updated after the relookup. The shrink path is
safe because the new value_length still covers struct index_root, so the
index.allocated_size field remains present while it is updated first.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -1342,9 +1342,16 @@ out:
 static int ntfs_ir_truncate(struct ntfs_index_context *icx, int data_size)
 {
 	int ret;
+	u32 old_allocated_size;
+	bool shrink;
 
 	ntfs_debug("Entering\n");
 
+	old_allocated_size = le32_to_cpu(icx->ir->index.allocated_size);
+	shrink = data_size < old_allocated_size;
+	if (shrink)
+		icx->ir->index.allocated_size = cpu_to_le32(data_size);
+
 	/*
 	 *  INDEX_ROOT must be resident and its entries can be moved to
 	 *  struct index_block, so ENOSPC isn't a real error.
@@ -1356,9 +1363,14 @@ static int ntfs_ir_truncate(struct ntfs_
 		if (!icx->ir)
 			return -ENOENT;
 
-		icx->ir->index.allocated_size = cpu_to_le32(data_size);
-	} else if (ret != -ENOSPC)
-		ntfs_error(icx->idx_ni->vol->sb, "Failed to truncate INDEX_ROOT");
+		if (!shrink)
+			icx->ir->index.allocated_size = cpu_to_le32(data_size);
+	} else {
+		if (shrink)
+			icx->ir->index.allocated_size = cpu_to_le32(old_allocated_size);
+		if (ret != -ENOSPC)
+			ntfs_error(icx->idx_ni->vol->sb, "Failed to truncate INDEX_ROOT");
+	}
 
 	return ret;
 }


