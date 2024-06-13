Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008B146597;
	Thu, 13 Jun 2024 11:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279564; cv=none; b=Jz54W/hBmi2de8W0wV6TfUi+xgq0Q/MIhWgZK2hZgen6zndkUjEhsozfF+O0SevoFpx6HCBUkvnM0XTQ1PLATjilWAxwRz0ht2qk3MBuA/DRjpKdlG9/XDxF4v+Yew4JFKnJvyZ6SuHuK4c9XdK2gvdVSQskIvXdfcZRMOv4d8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279564; c=relaxed/simple;
	bh=9vkcsIaETyIiZaIXF/8zWZ5aUIpAfY7Xs2p1SSQNDGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihIdW6AyMT/2nBgtrpFJoAiezUgon+WeagwuTwy36vHUnLImn/OmWtUnrg4QieyxUS0I4hUPTY17ZDezjmicAjM/CW9MyDBktMkp1DxoA93S8kTNBOElY1l4kGb+EERdlc2TyDcUmphhIXeVE9qXipl+NYXmUZDPSL/CPp/IZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBhWPt13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBhWPt13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3980BC2BBFC;
	Thu, 13 Jun 2024 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279563;
	bh=9vkcsIaETyIiZaIXF/8zWZ5aUIpAfY7Xs2p1SSQNDGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBhWPt13Sq6dArAdhN+jjG8mpPswYNXPm39+lo8ujR2Pos0KaRfHdlqPwsqrIY9Q6
	 wTjRW+sTTfsXDpGgVSpiO6fsdJ3nJRg8siahcfjI7oexXhxlh5H95lHbl61gVFnHyM
	 zPaj/yFL0ERF7GseIC2jb6i7zTBmrqHdGvZqRQ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.9 118/157] ext4: Fixes len calculation in mpage_journal_page_buffers
Date: Thu, 13 Jun 2024 13:34:03 +0200
Message-ID: <20240613113231.980946856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit c2a09f3d782de952f09a3962d03b939e7fa7ffa4 upstream.

Truncate operation can race with writeback, in which inode->i_size can get
truncated and therefore size - folio_pos() can be negative. This fixes the
len calculation. However this path doesn't get easily triggered even
with data journaling.

Cc: stable@kernel.org # v6.5
Fixes: 80be8c5cc925 ("Fixes: ext4: Make mpage_journal_page_buffers use folio")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/cff4953b5c9306aba71e944ab176a5d396b9a1b7.1709182250.git.ritesh.list@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2334,7 +2334,7 @@ static int mpage_journal_page_buffers(ha
 
 	if (folio_pos(folio) + len > size &&
 	    !ext4_verity_in_progress(inode))
-		len = size - folio_pos(folio);
+		len = size & (len - 1);
 
 	return ext4_journal_folio_buffers(handle, folio, len);
 }


