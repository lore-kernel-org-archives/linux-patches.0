Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1344A3F23B3;
	Tue, 17 Mar 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766416; cv=none; b=TTyP+nIQOUQP1fQoRgRB22poFpGXrrMJqqptT0CLz+3tAV5/eGW1M0g74hY1Zp/G765l0peQyAj6yYVeJAFqplZSD9zBXbXJ2ZLoCZdyrDwnZTD/YIkVS6IPHdluETICcHl0sFcWKbE2KOyyKwPPKUw6s7Js+TSSNtAlEKi1UU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766416; c=relaxed/simple;
	bh=gg35ijGjjfzG+Ra+9O2J1+eWkB1YT7MYfsIYexso43k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQPvlQ7FC5VRdbbIdfNdJ8/L/85T5ygLCV73UwwKKiIpx9pa1Xu6xEsta39MqEhUcn0fdeGSr0dPH7Y1R+bgFUB6dXn00Qh/HknSBT3UuAJmd4jSjW8H9UUFS64lyxbrlecNO3hFijGwvQBIWlUZBrg2Hioobz+U/myRRrepw/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcI3dEV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcI3dEV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC14FC19424;
	Tue, 17 Mar 2026 16:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766416;
	bh=gg35ijGjjfzG+Ra+9O2J1+eWkB1YT7MYfsIYexso43k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcI3dEV/7MwHrWDky1kl3p4GA9ErVuIWjoAKy8+iXavWqRT/KJ2jCQaK8RHkaUY0I
	 4wC9bRaFw+IfmYLiD2oU597yhDSLtDTuorfrT9kB5h4WFgkm4a9nR6ft5w1+puCNra
	 dJ81J3ZM6hIE4AT89cFHSFoWMBwPSd2+f65eEUJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.19 242/378] iomap: reject delalloc mappings during writeback
Date: Tue, 17 Mar 2026 17:33:19 +0100
Message-ID: <20260317163015.920291346@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


