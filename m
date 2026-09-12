Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A5737CD32;
	Sat, 12 Sep 2026 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204645; cv=none; b=CAkEXkKv2JQ+BkK3ZDWNVNVeRU1pf6OL9wwiT3g4OfmBYDdSF51nf9I1SU9E+ejBLoXGDBetryuORtN0NeuL/YlLgKKX8LebcVD0lzAVX+RT0v9iOzR3PRjausH+dTYV+fZtctyUOkKnaTCFzUFSD2pS/omC7tZky9mvd7lA0VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204645; c=relaxed/simple;
	bh=7ittm+pmzhvMrpgzpolPhrEbD8xzCo/t3JsdnMv2GtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxd9ZDi2pmyGzZXSTzSHyfv9zsGHapN6sUF38hlfrQR8LAsNRsQBptaxH1yjWTgu+rFM3dboryx+TAcoTxSPvSf2hcECdJX/rwve6PU2eEVD90Uf0aJ4HnysR2sBOM/1i2iaIfVZcBS3s2IZI4SfJ7T0gUyH/GUXh7NzZu3Pp0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSZgPgLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSZgPgLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82EA1F000FF;
	Sat, 12 Sep 2026 09:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204643;
	bh=bdX8Jd7Nx25T24thRjLWqWHLSbjLa5o7qoxi7QJ8VUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSZgPgLKG2SFaBDpdI2AXQ9aSk2H9Ll4lDSARoRFc8oVW7q6cyB1GJ2xLfxMor4Cz
	 AbMZ5c16vFN21gcwnHFKolu1YjZrUm5X1A4fD8Ca9UlIWFbvM1+cOm1chd2siffFvt
	 77dx98pl3qN0/Q417jAebwDLHfwbUY0H/9zwWsKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Tighe <dennis.tighe@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1656/1815] ntfs: validate usa_ofs before preserving the update sequence number
Date: Sat, 12 Sep 2026 08:56:46 +0200
Message-ID: <20260912065727.869594806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Tighe <dennis.tighe@gmail.com>

[ Upstream commit 81684340963da2e898eabb8c1e274433d9375bc6 ]

When ntfs_mft_record_alloc() reuses a free mft record it reads the old
update sequence number straight from the on-disk record:

     usn = *(__le16 *)((u8 *)m + le16_to_cpu(m->usa_ofs));

Here m points into the raw $MFT page-cache folio, which still holds
unvalidated, MST-protected bytes: the folio is read by a plain
iomap_read_folio() and neither post_read_mst_fixup() nor
ntfs_mft_record_check() has run on it (both work on private copies).
m->usa_ofs is therefore an untrusted u16, and a corrupted record can put
it past the end of the record so the two-byte read lands outside the
folio.  Reading such a record while creating a file gives, under KASAN:

   BUG: KASAN: use-after-free in ntfs_mft_record_alloc+...
   Read of size 2 at addr ...
    ntfs_mft_record_alloc -> __ntfs_create -> ntfs_create -> path_openat

Only preserve the old update sequence number when usa_ofs is even and in
range, mirroring the check ntfs_mft_record_check() already applies;
otherwise leave usn zero, which the existing restore below skips.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dennis Tighe <dennis.tighe@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index fd20d7abd6f5e..271a265491280 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2333,7 +2333,17 @@ int ntfs_mft_record_alloc(struct ntfs_volume *vol, const int mode,
 		 * wrong with the previous mft record.
 		 */
 		seq_no = m->sequence_number;
-		usn = *(__le16 *)((u8 *)m + le16_to_cpu(m->usa_ofs));
+		/*
+		 * The mft record still holds unvalidated, MST-protected on-disk
+		 * bytes, so m->usa_ofs is untrusted here.  Only preserve the old
+		 * update sequence number if that offset is in bounds; otherwise
+		 * leave usn zero so it is not restored below.
+		 */
+		if (!(le16_to_cpu(m->usa_ofs) & 1) &&
+		    le16_to_cpu(m->usa_ofs) + sizeof(usn) <= vol->mft_record_size)
+			usn = *(__le16 *)((u8 *)m + le16_to_cpu(m->usa_ofs));
+		else
+			usn = 0;
 		err = ntfs_mft_record_layout(vol, bit, m);
 		if (unlikely(err)) {
 			ntfs_error(vol->sb, "Failed to layout allocated mft record 0x%llx.",
-- 
2.53.0



