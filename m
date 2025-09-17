Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5A01E1E00;
	Wed, 17 Sep 2025 12:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113751; cv=none; b=UDz/ajwne1buTW0I1Rr7IfkrYUiSF3FvuAH1Wr5MpCkKF54paZFtoTybmRDCRAF3NyEzhf8uUn4ty5bj/pYPVkNxcy4ivtrsV5EuVDzxM2TTR6XVyPc7nFZicOR11tHSuLh7a/WSOaGXxVC9dvpBZQiGVRbCfCDH+57BJOrfhJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113751; c=relaxed/simple;
	bh=modgKuK0F4c71qIpc/b1V/RSChU2BGNll+rbvneGFvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB3V1esrhoheP20Piw733fB/xzkQ8U2yff+oDgbobVAPYn2UyScFtOi4BfDuDAr+CVjrPjk0Rc+WJCoFhHaJIS8EBfALFMLGQf4hLwZHzU3BOn/p/OoiPU2qwyZyQqJxRRzLISC6w3U47wE6kG772bMi8USx/bRiQclksKjNDD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KuwxFgX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KuwxFgX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC53AC4CEF0;
	Wed, 17 Sep 2025 12:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113751;
	bh=modgKuK0F4c71qIpc/b1V/RSChU2BGNll+rbvneGFvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuwxFgX9xVk026u+QeHQtTD0Vmk28k+MK4XsYjqL1CNnSk9SDHPg0NU1T/6Hl5qIp
	 JIkovH78i9jQQ09fteMF5244ksgWbrZfQrNA4eR//tfboG3LaWWZbVMGV6K5mSW353
	 IAFFCAojMur8PE+wcoW+gJKE6jy2Ak+qmSpEdBdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Weimer <fweimer@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 041/101] fuse: prevent overflow in copy_file_range return value
Date: Wed, 17 Sep 2025 14:34:24 +0200
Message-ID: <20250917123337.839203378@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 1e08938c3694f707bb165535df352ac97a8c75c9 upstream.

The FUSE protocol uses struct fuse_write_out to convey the return value of
copy_file_range, which is restricted to uint32_t.  But the COPY_FILE_RANGE
interface supports a 64-bit size copies.

Currently the number of bytes copied is silently truncated to 32-bit, which
may result in poor performance or even failure to copy in case of
truncation to zero.

Reported-by: Florian Weimer <fweimer@redhat.com>
Closes: https://lore.kernel.org/all/lhuh5ynl8z5.fsf@oldenburg.str.redhat.com/
Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Cc: <stable@vger.kernel.org> # v4.20
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3106,7 +3106,7 @@ static ssize_t __fuse_copy_file_range(st
 		.nodeid_out = ff_out->nodeid,
 		.fh_out = ff_out->fh,
 		.off_out = pos_out,
-		.len = len,
+		.len = min_t(size_t, len, UINT_MAX & PAGE_MASK),
 		.flags = flags
 	};
 	struct fuse_write_out outarg;


