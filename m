Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AEF1E7C01;
	Mon, 21 Oct 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507538; cv=none; b=EjcVSbPcnOL+K/LsTL80EoTvFnLKuIKCW6efOCQiu+aalYwOiUYbubO+Y6i0A7DbdOGht7kjIbNOTI2eKdZ5Fwk11oy/CzzabhJWHmN6LCfSh0P4FJfg6QQHD/EIF/D7fj4g89+1L8pCAZmNU1V5QMKp+R2K3CV5P1vU2p3agdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507538; c=relaxed/simple;
	bh=7oUO0DBTLzAecv/4aax2CdUb0M/cLEOG/aCmpj/WFzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrTQcjghfw4Q3WIE/QsBmOVe9FkuVAJ7ucBzzAUt/ZIgZU6R7YaAXxCiGGU05IUqqHHjWyNdOhalvPoDNvfxxkY5br5Poe7kYUFO7X1f3WsiMMV5NDj12sajVWY4uHfqi+TxmgeSMKHVno3wHJjs0y6nhRuAbPZdQIQy+sJLreU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxV0h0dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxV0h0dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B047C4CEE6;
	Mon, 21 Oct 2024 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507537;
	bh=7oUO0DBTLzAecv/4aax2CdUb0M/cLEOG/aCmpj/WFzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxV0h0dFK2GnLC9Hpk2ItBNAew4nIUT9hYg45ozNBxYU65Q4ridnl2wUTHZlW7VNE
	 Hid0yjGMG+W1AwZRYwWmfikV5Hgd30TsZEXjAiTWsSSqBzrwEXbZgWpsFqgrmfMPGs
	 SgOs/ePqwZbGNQiP1+pfbo9YBs/NcJqk+UnrS8jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 19/82] udf: Handle error when expanding directory
Date: Mon, 21 Oct 2024 12:25:00 +0200
Message-ID: <20241021102248.000485192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 33e9a53cd9f099b138578f8e1a3d60775ff8cbba ]

When there is an error when adding extent to the directory to expand it,
make sure to propagate the error up properly. This is not expected to
happen currently but let's make the code more futureproof.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -192,8 +192,13 @@ static struct buffer_head *udf_expand_di
 	epos.bh = NULL;
 	epos.block = iinfo->i_location;
 	epos.offset = udf_file_entry_alloc_offset(inode);
-	udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
+	ret = udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
 	brelse(epos.bh);
+	if (ret < 0) {
+		*err = ret;
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0, 1);
+		return NULL;
+	}
 	mark_inode_dirty(inode);
 
 	/* Now fixup tags in moved directory entries */


