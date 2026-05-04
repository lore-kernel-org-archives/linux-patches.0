Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50F3DEFF0;
	Mon,  4 May 2026 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903634; cv=none; b=gIAD9XF1DqLaCKBjd7MiBecnQQobYcyQHuj5GlAKADuGomWVUok7RQA5MkDwzZo489k/L5Z5h9cEbUyWj5J4etK+dgsvFzi9M/ysQoQwjNk3MrVW9EwIG1AiKa1HZWJ2/rtN1PGOGQDd3P0GL0O9l4s6SiWiQySFiSLo5AgridE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903634; c=relaxed/simple;
	bh=afXRl8ES2Stzpu0Y/WyTuYF7NMKUJ6Z29I4JBq+UTls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7OLSqsTwsiqpiqAr55e8NPyVIZ8M2q61cPqSF/WQo8bxr1KwIlo5ljB8CUWRj7gRXR/vZ8RXUclNCwL/tw+myNchSiR7SOBSftUUev76+4Y7Ey0c5hS+0GYC0vufzUP9SDop8fB09w6Hmw+3oE2Ioc2vTpIRwNJA5luvfcMG4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHr71sku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHr71sku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065A2C2BCB8;
	Mon,  4 May 2026 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903634;
	bh=afXRl8ES2Stzpu0Y/WyTuYF7NMKUJ6Z29I4JBq+UTls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHr71sku0/kmhmnG6hVQaJYkMz3IJ2lLgjQwIf0HpUw7cSnUwjVXDm/Pv5UDXszwc
	 XOaColERtG6PV0sFB+4btNMpwjsd7ZFfVUpR2Jo+73TIRTWS3Mv21jekOhx/qlw7OS
	 Jz9lOaRhThZuBQ14XgB3X7cAbCnLStt//d2K7Hl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.0 279/307] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Mon,  4 May 2026 15:52:44 +0200
Message-ID: <20260504135153.292282871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1065,9 +1065,15 @@ int run_unpack(struct runs_tree *run, st
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


