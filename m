Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D1035A3AD;
	Mon,  4 May 2026 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904244; cv=none; b=Aoq0sFbkTgUv5DRLhd16BWeUc+WYM6rA+zb83l/d2dl7ejpBDjq4hSKwK4jrsxfKUWVSx4CJv0mhzIzWvr04xeNOiqHNTkXm6Y6VqVBSKneXln0+Y7Nr3CJKTD0y/IfpWrtQjsaZlUQQzSrBXkpH+TP/dU6DSleHtLzNUvlDqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904244; c=relaxed/simple;
	bh=ZYTVfYKgsAHV+s+sEvEfJPgOd1ogVwomDKMnGtwZVuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKuMQQK3QXt0sbR4dWufYcQnwcbLQFZZq8IUO/JRQHSppm9+6rVASxCyYLgE2G4wTd7NoQ9EZ+guFD0yS8vYTCPf7uiacuKAizW7jJdLAvuHCMBU5N2CZB+i7R0je7z2Pd0Wgxn81hop4o5C5qpQXmp1/Sd6PzpEDU0Xyzs0IuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWaMS7S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWaMS7S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D29C2BCB8;
	Mon,  4 May 2026 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904244;
	bh=ZYTVfYKgsAHV+s+sEvEfJPgOd1ogVwomDKMnGtwZVuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWaMS7S4RL4m2RN5bKGr49o1Pc2OYZ+I1N6ReGTl+2Lny1fxcQVrq130qxFW6DnoZ
	 KUqGVo33JWzlUctSDRsUG10oaZDLGYVPzdlb9CZ35UjUaFUYqg735b2bf13OuwwFLS
	 F4KLkaHCrSdpfAg7kM77Jdld+HVtmCt3MDlqaud8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gaertner <tob.gaertner@me.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 240/275] ntfs3: fix integer overflow in run_unpack() volume boundary check
Date: Mon,  4 May 2026 15:53:00 +0200
Message-ID: <20260504135151.960389471@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -1020,9 +1020,15 @@ int run_unpack(struct runs_tree *run, st
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


