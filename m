Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF626B096;
	Thu, 13 Feb 2025 15:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459675; cv=none; b=IwSD9pQdsYQA1xq93B7aUi2CYp2dtx4Qdeldo0tEEYUmc9wJyBSaf1lU3/Y8KL9mcy5lfONESsXfU5szwHe8colfNk5C2bGZI7O67xN8plQvwtfWctdC4k7IREvTPQXNaE+pZwybQFerSzCP7AxvOLZuFxkklxmJ0Fppu1TMn5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459675; c=relaxed/simple;
	bh=w6mJBbT5e+x8oE+ZfQbg+/UIE1A7gl34cHRN1r0WUoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUMuos8HLJmsmMBngLNQZSOAyAh1Ct0HnfRdkZgz+uCR6ybJ3Tma8A1F81liFMAijtRAuUhGFGeVUBbzC5D+Io/WKRNy7y5+FW63qm6JK1i1HiMbLlYlCwIZrLsB6spVo+XH0UsZqNmHuGL7OHL1fOw8nsKpBjVLJObY7SVvNeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BP7l6BtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BP7l6BtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E047C4CED1;
	Thu, 13 Feb 2025 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459675;
	bh=w6mJBbT5e+x8oE+ZfQbg+/UIE1A7gl34cHRN1r0WUoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP7l6BtB4K+owrqd3XBEFP5qd6dqlefpbdpR2I3bf5RapEr8GfwjJHdeWDEmWL+LY
	 x3m6bXGTxLiG00X9QhbFpbIEjWAZUviMWABaBlo5nP/96dJmrW3gskAWH94zwgo0FP
	 3xqiaid9k1fcoMsVz8J0dNDKBRyk3gk2n49lMDBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.13 331/443] xfs: Add error handling for xfs_reflink_cancel_cow_range
Date: Thu, 13 Feb 2025 15:28:16 +0100
Message-ID: <20250213142453.395978939@linuxfoundation.org>
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

commit 26b63bee2f6e711c5a169997fd126fddcfb90848 upstream.

In xfs_inactive(), xfs_reflink_cancel_cow_range() is called
without error handling, risking unnoticed failures and
inconsistent behavior compared to other parts of the code.

Fix this issue by adding an error handling for the
xfs_reflink_cancel_cow_range(), improving code robustness.

Fixes: 6231848c3aa5 ("xfs: check for cow blocks before trying to clear them")
Cc: stable@vger.kernel.org # v4.17
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1404,8 +1404,11 @@ xfs_inactive(
 		goto out;
 
 	/* Try to clean out the cow blocks if there are any. */
-	if (xfs_inode_has_cow_data(ip))
-		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+	if (xfs_inode_has_cow_data(ip)) {
+		error = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
+		if (error)
+			goto out;
+	}
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*


