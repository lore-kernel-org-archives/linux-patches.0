Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EFA27EC7C;
	Mon, 29 Dec 2025 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025548; cv=none; b=NQ6T+DVD/XfmWreGOBqJu2cj601ZgI/1dis+9ajLmu44LRWyF3TyULPDvAfyuh/rmgXqP4ajcyFtuCj0yS61FCVu5MU7TaC14NlCFLmjk4J7v23ngLS5VTvhsWeA3XwrcY6qaGmpFxTrr1hTJ96Gr1ftIDBFksC2GP9heqAXv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025548; c=relaxed/simple;
	bh=zbUpFm7CWayPQLLPCfVljm8136eaS1LF+Nww4W/t05c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtmDpu5c9nmYPr8Xo5mBWpXL4mxB5YK4Po57D9ZO9/2KIEsuKCd7/rBEkHZ/uHKGD9IyLoHUrn+YnCQwp/g5PvTZdKPkXRZpOBUFw1GwxkoDr4ur8MLSmKHZWwS2UFlcw0xHOPrHE8LNjLbjIa81x38JbpvjblExzvHLe15xPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYWCADZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYWCADZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE77C4CEF7;
	Mon, 29 Dec 2025 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025548;
	bh=zbUpFm7CWayPQLLPCfVljm8136eaS1LF+Nww4W/t05c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYWCADZizO8zpdWXfaesn8c00VgDvHTICroWl1MbI0TyL3mx6nRGwM4J3tz0X5wIL
	 vYU9CkJFdmyj9OW8Hb/NfNaz1VEAydFMphQWjxMVIHq704wJbGAdN0NoHHyEWxMzZH
	 5e8H1/L7ywrT+Z8ftgJC693KI9t4PZFbYErGXNzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 253/430] fs/ntfs3: fix mount failure for sparse runs in run_unpack()
Date: Mon, 29 Dec 2025 17:10:55 +0100
Message-ID: <20251229160733.666203480@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 		} else {
 			/* The size of 'dlcn' can't be > 8. */


