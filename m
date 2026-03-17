Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B552D5940;
	Tue, 17 Mar 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767984; cv=none; b=KPpFaCHxM//3pbY2W/h/BBmZYHwiCm8vg1adkBvvzdd9BZpvMxhaOef1AkVnywnz8LJ9iT96T7XXnXBQC4U9I2gby819YRPnC/cDanRndFPlvMudAmovsABMqUuHCvlztpfokK+bYwSuqqw8oFr/oMAITy5SIeuvQ6nZVI/2tSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767984; c=relaxed/simple;
	bh=3sUQHDlffL/NO6K8ZQJKwwDGz8sU6riixgEy6njWVS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px/MFd2gHMGyCXzZUIagsTLQ6+NfA+xWSv47Q+pcydg7EvYW9DPtwjzyOrq0OkPXtb5Y2SUjhZ94s12Ysn2j4CWoUo1vp/h0/yPXzgbp6HB0IWpuVRCrG4gk9d4kezP5Q2uTpo4YsuXBtZ4jW66SuYNPzqDk3DqW7GEsM+zYY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSBoxlur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSBoxlur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C9BC4CEF7;
	Tue, 17 Mar 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767984;
	bh=3sUQHDlffL/NO6K8ZQJKwwDGz8sU6riixgEy6njWVS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSBoxlurych6ssc5IsgqOrXMYvOH3bZRKWhRxahVz/CPZlKXvUFTyZhyoUNkb4B/4
	 w+oesdjAgFCZarV+OOo+NCARqKc4AjcvJh2K4VBvUHYf+7L0DQxsBs9EN5GdCS6R/U
	 FMom4a2389nr2TcxV7FHjJ24AUgVpy+kJ+d7Eb20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 204/333] iomap: reject delalloc mappings during writeback
Date: Tue, 17 Mar 2026 17:33:53 +0100
Message-ID: <20260317163006.923016024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit d320f160aa5ff36cdf83c645cca52b615e866e32 upstream.

Filesystems should never provide a delayed allocation mapping to
writeback; they're supposed to allocate the space before replying.
This can lead to weird IO errors and crashes in the block layer if the
filesystem is being malicious, or if it hadn't set iomap->dev because
it's a delalloc mapping.

Fix this by failing writeback on delalloc mappings.  Currently no
filesystems actually misbehave in this manner, but we ought to be
stricter about things like that.

Cc: stable@vger.kernel.org # v5.5
Fixes: 598ecfbaa742ac ("iomap: lift the xfs writeback code to iomap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://patch.msgid.link/20260302173002.GL13829@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/ioend.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -163,17 +163,18 @@ ssize_t iomap_add_to_ioend(struct iomap_
 	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
 
 	switch (wpc->iomap.type) {
-	case IOMAP_INLINE:
-		WARN_ON_ONCE(1);
-		return -EIO;
+	case IOMAP_UNWRITTEN:
+		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
+		break;
+	case IOMAP_MAPPED:
+		break;
 	case IOMAP_HOLE:
 		return map_len;
 	default:
-		break;
+		WARN_ON_ONCE(1);
+		return -EIO;
 	}
 
-	if (wpc->iomap.type == IOMAP_UNWRITTEN)
-		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
 	if (folio_test_dropbehind(folio))


