Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC69826B096;
	Thu, 13 Feb 2025 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459672; cv=none; b=ifbs0l9lW3zj+d7xTOgmfa17PD/a9AEaS4UcXjkdk26yhHqF9TNRaDnPU90vEYHuzwGbbD810P93gAvv9yLcQ3HIcA5lXFCE/ZEBKPsHGKDtUrB6xZcEUkFJZKsqqpRVzyGWMORRUk0g9J+h/3p0/q7YGotlA0radHmdkx6hh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459672; c=relaxed/simple;
	bh=ZwVauvfcVZlWqebu0zYOoCWJX8TbQTt91INvqPCg1rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQqvuDI2WBxwOE3pRtpW02Lqty239W9Gck/OF/IW6Xuz3TQUQw6kqz20SORAXqH6SgtnVDUeGkgxcAML9hrkT/TkoFj3SARay2jjg4tlpGblndfI0KB3h50JmnQ8LZGXQTEp2zNDHmnTyvL2lK4aG2wlfgIdkotPsH14zbphOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPFZJsr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPFZJsr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4AEC4CED1;
	Thu, 13 Feb 2025 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459672;
	bh=ZwVauvfcVZlWqebu0zYOoCWJX8TbQTt91INvqPCg1rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPFZJsr6oLfOqk8DVgP91KYp6wYyBXjr5Nt+wq7Cn5NvlVKiasEwKeAmOXQiKLfoq
	 EtPgOju2GnwjcnChlen/ul1Q8fkxElu6NetnxNO767Ho9oNgj4OVO9uDWnZJhnFut6
	 AwHPWm/pWi6tzs/KoNGGeaSWu/E5YxkHjhZGDXuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.13 330/443] xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end
Date: Thu, 13 Feb 2025 15:28:15 +0100
Message-ID: <20250213142453.356812377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fb95897b8c60653805aa09daec575ca30983f768 upstream.

In xfs_dax_write_iomap_end(), directly return the result of
xfs_reflink_cancel_cow_range() when !written, ensuring proper
error propagation and improving code robustness.

Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
Cc: stable@vger.kernel.org # v6.0
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -976,10 +976,8 @@ xfs_dax_write_iomap_end(
 	if (!xfs_is_cow_inode(ip))
 		return 0;
 
-	if (!written) {
-		xfs_reflink_cancel_cow_range(ip, pos, length, true);
-		return 0;
-	}
+	if (!written)
+		return xfs_reflink_cancel_cow_range(ip, pos, length, true);
 
 	return xfs_reflink_end_cow(ip, pos, written);
 }


