Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A5F30568A;
	Fri, 15 May 2026 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860923; cv=none; b=JmPqQwULwaKfRl5kYLsLipdqFJV3zpPSJ5sHCN7p2yh0tYpklmVxDAsWOUE3u/pJ7A/UhvK/JJO1NrUxksyQjumKNCdZPa7+Y2/2YJQdi78jOU9q0lkZ5vII7np/Dnz3YggjrHWxpAiLcTcHbfx0HTPI20QrDhEPFWzZdLe6eho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860923; c=relaxed/simple;
	bh=ezl4yLPUptX+gUkY0h6Lttk1ZeFN5dccwyu4/otr6KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIBJ9L05RcsS/1l+HJFjBD99TrxrI0l9/c2URXGjI6ZrpvQ1xt9z2Hb0L+zsLbLsTfWBg9hY7PoxVhZctVpm85UXiywNWaAFEalpOTOWTLZc9YAcsLbF+oc5zmxVuidYTlkWwOWzhL1WSJHT3xydXwX01f1LctVjFdgKacaKMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYD8MdPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYD8MdPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D663C2BCB0;
	Fri, 15 May 2026 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860923;
	bh=ezl4yLPUptX+gUkY0h6Lttk1ZeFN5dccwyu4/otr6KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYD8MdPjszRTdmbrXpnvB6fRSXqAx+2jjkJJbZzS3SYQIMg1413rfvCXg5SFPvuyX
	 Db5X2+Ks+LLb8vYXnWq+lrrKxERXlAKKfe2LYN+bCzVgw/jvIpjRAMAt7A7nGE3AjS
	 ZDSZc31vkcrp+BcwXQexIDQXXoljcFE2Va0f6ePA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 131/474] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Fri, 15 May 2026 17:44:00 +0200
Message-ID: <20260515154717.866959897@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Gaertner <tob.gaertner@me.com>

commit 984a415f019536ea2d24de9010744e5302a9a948 upstream.

The volume boundary check `lcn + len > sbi->used.bitmap.nbits` uses raw
addition which can wrap around for large lcn and len values, bypassing
the validation.  Use check_add_overflow() as is already done for the
adjacent prev_lcn + dlcn and vcn64 + len checks added by commit
3ac37e100385 ("ntfs3: Fix integer overflow in run_unpack()").

Found by fuzzing with a source-patched harness (LibAFL + QEMU).

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Gaertner <tob.gaertner@me.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1018,9 +1018,15 @@ int run_unpack(struct runs_tree *run, st
 			return -EOPNOTSUPP;
 		}
 #endif
-		if (lcn != SPARSE_LCN64 && lcn + len > sbi->used.bitmap.nbits) {
-			/* LCN range is out of volume. */
-			return -EINVAL;
+		if (lcn != SPARSE_LCN64) {
+			u64 lcn_end;
+
+			if (check_add_overflow(lcn, len, &lcn_end))
+				return -EINVAL;
+			if (lcn_end > sbi->used.bitmap.nbits) {
+				/* LCN range is out of volume. */
+				return -EINVAL;
+			}
 		}
 
 		if (!run)


