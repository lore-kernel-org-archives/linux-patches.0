Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75A135BDCD;
	Fri,  9 Jan 2026 12:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962321; cv=none; b=PNA/RccnED6PlJWrfLVn8OkaEJuUR6uRGUAjvLyEBA8WJ8L9uCFxCDSZr4JXfVt6SkQSQnkqFV4ym2dOKunVovDmo7LF84wWoV6eRzNojOKVGhKs6FqmlcxwHRtWVUlquaXGczYeVIVfxBtnUOUNxc0yS/hFjnz5QnEMY+xlymA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962321; c=relaxed/simple;
	bh=1g2NddAGXXUxaixU+zYrPhAWUdLt1QAT5KHrENJxK+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2snJ16pxahCBhAv9i4qclNmMONxIgZ+HpyOxEv2UZWFI/RtaPQhK82OvbBe7DSw6ASxB2fiklH3S41DFmQrRMi0dc3iYa96gimwj+L02bxsyklTh6uoxTnT0RzsytLGmF+QcWk0wrFF5o1yaGuxULD/A3ENHdT//7km1G7vkl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPK+66Km; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPK+66Km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4290DC4CEF1;
	Fri,  9 Jan 2026 12:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962321;
	bh=1g2NddAGXXUxaixU+zYrPhAWUdLt1QAT5KHrENJxK+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPK+66KmumLH/eX6ZSndrJ2EMWzPjegJGd48Kf7zxSeLQzm2vX5uw+vww0o9YdRfZ
	 83EVbDrTuue1MgJIq1QAHpKAg5ECcWy88pfKywk7/Gu1tLD8DqQZB+UJLaXLajoYtA
	 07AZXNeDSLd7iC9TWloTuIl1V0T5gFPRkpxMiEB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 325/634] fs/ntfs3: fix mount failure for sparse runs in run_unpack()
Date: Fri,  9 Jan 2026 12:40:03 +0100
Message-ID: <20260109112129.758149513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 801f614ba263cb37624982b27b4c82f3c3c597a9 upstream.

Some NTFS volumes failed to mount because sparse data runs were not
handled correctly during runlist unpacking. The code performed arithmetic
on the special SPARSE_LCN64 marker, leading to invalid LCN values and
mount errors.

Add an explicit check for the case described above, marking the run as
sparse without applying arithmetic.

Fixes: 736fc7bf5f68 ("fs: ntfs3: Fix integer overflow in run_unpack()")
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -984,8 +984,12 @@ int run_unpack(struct runs_tree *run, st
 			if (!dlcn)
 				return -EINVAL;
 
-			if (check_add_overflow(prev_lcn, dlcn, &lcn))
+			/* Check special combination: 0 + SPARSE_LCN64. */
+			if (!prev_lcn && dlcn == SPARSE_LCN64) {
+				lcn = SPARSE_LCN64;
+			} else if (check_add_overflow(prev_lcn, dlcn, &lcn)) {
 				return -EINVAL;
+			}
 			prev_lcn = lcn;
 		} else
 			return -EINVAL;


