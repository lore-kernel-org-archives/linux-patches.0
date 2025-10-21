Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3881E350A39;
	Tue, 21 Oct 2025 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076581; cv=none; b=S2h463ImvdIASABuW2IOoMHezT/EHUnTK8/Nu9QG9OhX2a5rRof+YAcBD/kJZ2AOQQkmhpudIH/z4O83E4OuuYLUeKp8NbnngPoYUEvBsGCquD3/BiR77iyz/JhjLh6msxSfSRgXeX6DnqsxcoI0IdAuGvYDW5aXMiiGsUsOuNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076581; c=relaxed/simple;
	bh=0dB62Ns56rxduhCNVD/tH3XdpjVxapTFHXMzwxcpR0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSdk+JxYua8c/bmM/UO5lZ2MjnYsDNhTTLOlieB3zM8tksONeQL8YCn/FsJEY766DPWnWvHwnByaEv9OQNMz6p7jC+/9qs7bM2GQScUwo5F234iJeztwNZwlTgrF4214nqAo0hgFfiVDe8As3V6ON26H/zWwcc+5hmkCWhYgGgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSc9nV92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSc9nV92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973E5C4CEF1;
	Tue, 21 Oct 2025 19:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076581;
	bh=0dB62Ns56rxduhCNVD/tH3XdpjVxapTFHXMzwxcpR0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSc9nV92w/tOEb0DJjEwRcUz7idGSRceaUpGWgL027jL/BvXBbkzLf4mONSRPfV8b
	 ZWnRpyzv8XIRFhx7k2uhALHtjqXTe4n1fc0T7ZrJb+hAU6BGE5P35vDBU4l9Q4sv9j
	 OyTKVofoIGtI79cUdj95ux2VWzdIDk4ZoMiTZTAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/105] xfs: rename the old_crc variable in xlog_recover_process
Date: Tue, 21 Oct 2025 21:51:28 +0200
Message-ID: <20251021195023.527664682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0b737f4ac1d3ec093347241df74bbf5f54a7e16c ]

old_crc is a very misleading name.  Rename it to expected_crc as that
described the usage much better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: e747883c7d73 ("xfs: fix log CRC mismatches between i386 and other architectures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2860,20 +2860,19 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	__le32			old_crc = rhead->h_crc;
-	__le32			crc;
+	__le32			expected_crc = rhead->h_crc, crc;
 
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
 	 * Nothing else to do if this is a CRC verification pass. Just return
 	 * if this a record with a non-zero crc. Unfortunately, mkfs always
-	 * sets old_crc to 0 so we must consider this valid even on v5 supers.
-	 * Otherwise, return EFSBADCRC on failure so the callers up the stack
-	 * know precisely what failed.
+	 * sets expected_crc to 0 so we must consider this valid even on v5
+	 * supers.  Otherwise, return EFSBADCRC on failure so the callers up the
+	 * stack know precisely what failed.
 	 */
 	if (pass == XLOG_RECOVER_CRCPASS) {
-		if (old_crc && crc != old_crc)
+		if (expected_crc && crc != expected_crc)
 			return -EFSBADCRC;
 		return 0;
 	}
@@ -2884,11 +2883,11 @@ xlog_recover_process(
 	 * zero CRC check prevents warnings from being emitted when upgrading
 	 * the kernel from one that does not add CRCs by default.
 	 */
-	if (crc != old_crc) {
-		if (old_crc || xfs_has_crc(log->l_mp)) {
+	if (crc != expected_crc) {
+		if (expected_crc || xfs_has_crc(log->l_mp)) {
 			xfs_alert(log->l_mp,
 		"log record CRC mismatch: found 0x%x, expected 0x%x.",
-					le32_to_cpu(old_crc),
+					le32_to_cpu(expected_crc),
 					le32_to_cpu(crc));
 			xfs_hex_dump(dp, 32);
 		}


