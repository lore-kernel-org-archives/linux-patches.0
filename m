Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067D340244D;
	Tue, 21 Jul 2026 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654377; cv=none; b=N8qLeIHJe63DB0okEkfugpOXoR168eTxYk1wzqxEFfts21BloP54vG6hled9OWGKW+EDfxfTRx5qz27rgnNK0TH1AgKEdcB4fa+THAreHk2aVSggPrOE84or5glvRUkWAPqIA+/Qw1V4s6TUrXiv/D94I1fEs+5lKKn52B1gIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654377; c=relaxed/simple;
	bh=kGL5tS2DC15khi9C8ACRLL0XAuP77Z7s3VFHtRmh7Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqfOf3IYM2iW+zv5esINMxMRYhbCRyhevb56oEhJ0WBrHW5Ll+ILSDH7N32slfbUbZ7STz3AtRJ9dmpMB4lBVF3YHGye4DbscwJ9trw/Njtu27o5iWpMh4A+PfFHLwcr48Ly1b46YI3wmzf2EzpGz6tijh7y+edsC8wIzGLSTKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw6mFVW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw6mFVW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8401F000E9;
	Tue, 21 Jul 2026 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654375;
	bh=AqF1D7YrxumoXkD1+7Bt8qzyMytzcTaYydKqQEiJWcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw6mFVW4Pr2/FuKy1YRgSNnJrnjd8w6NFpkRhAYPmrilG4upi9UDxaerWgDgU+ybr
	 iSeTnKiuidssVb+mmOxZftRg1fDFBGH19CJhQ50NBlYWSLjspo3jFITNnx08spd7xE
	 I7bqvFsh2eavlNEhLllAavb7sgopjXXcI4Gvl2PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1681/2077] ntfs: fix incorrect size of symbolic link
Date: Tue, 21 Jul 2026 17:22:34 +0200
Message-ID: <20260721152632.397812651@linuxfoundation.org>
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

commit 05a5ff86a7f12c861e3516d3dc4d092ce620742d upstream.

This patch fixes the issue where a symbolic link size is displayed as 0.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1201,6 +1201,9 @@ no_data_attr_special_case:
 	else
 		vi->i_blocks = ni->allocated_size >> 9;
 
+	if (S_ISLNK(vi->i_mode) && ni->target)
+		vi->i_size = strlen(ni->target);
+
 	ntfs_debug("Done.");
 	return 0;
 unm_err_out:


