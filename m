Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A19322301;
	Thu, 16 Jul 2026 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211665; cv=none; b=ltoHSYAbAhKGQeKKPVphpYM3ldeDeG4flm7vgOJ0mhaSWuv2Xbll+rSDqy2fHZXCAUnHobR6p2Pl4BjpdAoEe44oLjP8jBC7DJEOP2ljXoCVVBKCWy7iFm45AQvQ8Mt0r9ZDkz0lHeBEKMCmEgGU9buEX8plF/q2ajgU1kfnhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211665; c=relaxed/simple;
	bh=jjt7qrxuFvg97VlgQSyRRxwPcCUoLGrczcJlc8xRYfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MI1CasVOmhQ4al8Pyq5e/eKGjubPujnrBFwnRdnPZXm+5mgzMta4kZAbOIIOhVo6jKPnAW3Z0B08f+2zJTJrMbPxWiIrC/T1DLrH62BxICLFCdz3CQO0mg441xBLcUmmkdP+IxpAWYdkuLxhDP70q0VHLYvZMlNtkLU1npTwmic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy/ys1UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy/ys1UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9371F000E9;
	Thu, 16 Jul 2026 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211663;
	bh=mYtAhoz1Nj02MRoxz7akLB54501otlF0/s6f0y5CmjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qy/ys1UU6Zfhv5o9kJhbHC44XolvcQMcox/n0f9IKpyNGjls171+PcuKetOXm0gZw
	 S198N/1RBg6Hc+bG9DjdUcQ9svLy2KuHJYr3ncdgApq7Pps2D0hsgGD1vXleFGi9sG
	 QavN7H705wsGBRBif0QYVhZ2PEwrP0b1AXeRUXvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/349] bcachefs: avoid truncating fiemap extent length
Date: Thu, 16 Jul 2026 15:29:00 +0200
Message-ID: <20260716133033.430994445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>

No upstream commit exists for this patch.

bkey sizes are stored in sectors as u32, while fiemap reports byte
lengths as u64. Shifting k.k->size before widening performs the
conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
it is passed to fiemap_fill_next_extent().

Compute the byte length after casting the sector count to u64 and reuse
it for all bch2_fill_extent() cases.

The same issue was fixed in bcachefs-tools, but there is no Linux
upstream commit to backport to 6.12. The affected 6.12 implementation lives
in fs/bcachefs/fs.c, while the bcachefs-tools fix touches
fs/bcachefs/vfs/fiemap.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-bcachefs/20260610105547.129545-1-mdmitrichenko@astralinux.ru/
Link: https://evilpiepirate.org/git/bcachefs-tools.git/commit/?id=6d9a895ed00d4b3868312df93253d2a817b0c6a3
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bcachefs/fs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1184,6 +1184,8 @@ static int bch2_fill_extent(struct bch_f
 			    struct fiemap_extent_info *info,
 			    struct bkey_s_c k, unsigned flags)
 {
+	u64 len = (u64)k.k->size << 9;
+
 	if (bkey_extent_is_direct_data(k.k)) {
 		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 		const union bch_extent_entry *entry;
@@ -1212,7 +1214,7 @@ static int bch2_fill_extent(struct bch_f
 			ret = fiemap_fill_next_extent(info,
 						bkey_start_offset(k.k) << 9,
 						offset << 9,
-						k.k->size << 9, flags|flags2);
+						len, flags | flags2);
 			if (ret)
 				return ret;
 		}
@@ -1221,13 +1223,13 @@ static int bch2_fill_extent(struct bch_f
 	} else if (bkey_extent_is_inline_data(k.k)) {
 		return fiemap_fill_next_extent(info,
 					       bkey_start_offset(k.k) << 9,
-					       0, k.k->size << 9,
+					       0, len,
 					       flags|
 					       FIEMAP_EXTENT_DATA_INLINE);
 	} else if (k.k->type == KEY_TYPE_reservation) {
 		return fiemap_fill_next_extent(info,
 					       bkey_start_offset(k.k) << 9,
-					       0, k.k->size << 9,
+					       0, len,
 					       flags|
 					       FIEMAP_EXTENT_DELALLOC|
 					       FIEMAP_EXTENT_UNWRITTEN);


