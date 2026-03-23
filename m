Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DA4283FC8;
	Mon, 23 Mar 2026 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282921; cv=none; b=MSJnA6kK8rXLWfPO/OMword3MbdUMfyZBupZtgtVj9DYqB189yullLR5zvmhjr54h17fhj/LyvlSMx8EWRtNeYijRUCipNsucWIHxt9vxAQXX50SAuRya7/w+jCRDbiIk5Ta9hDYIx55Zn5MsJmJw1pkFN0tcQNxpD/p3xijSrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282921; c=relaxed/simple;
	bh=/PhyHL0bf6odIHSTAm3+zQjU2k67DTfROaczDiYFL4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRIbVz92TS7w654TdltPlGLVRpCXQmx9wk1taXSmjhYCxUJWOmDnanjKKrbyhalRZhGi+ksw+gitR/V2AwjtJr5A+8x3F8aL+MQRID+Kjs6ykAt0x9j8ug/bflHfX8gEknF8drinHiKrLVsUlMXxlplP7FQ0r0HBeUoXEJM0AeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muJuwdIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muJuwdIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD63C4CEF7;
	Mon, 23 Mar 2026 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282920;
	bh=/PhyHL0bf6odIHSTAm3+zQjU2k67DTfROaczDiYFL4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muJuwdIT9SuPMo6pOd3gZ+KbaSr2Vpz39nQIX6aIOr9twnp932E6Kn0t8JFmiSrIH
	 2S+2SEPh/Gj7hxoSwQz8o6tQcQObwS+OpCnRuWjMxv/7seZK+szK+THPEr74XQ1Z31
	 0JX0pNgQ2pvXW9f6GvHVzSxEcRiStDyMZbOxAKuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/481] iomap: reject delalloc mappings during writeback
Date: Mon, 23 Mar 2026 14:45:18 +0100
Message-ID: <20260323134533.282877639@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit d320f160aa5ff36cdf83c645cca52b615e866e32 ]

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
[ switch -> if ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1620,10 +1620,13 @@ iomap_writepage_map(struct iomap_writepa
 		if (error)
 			break;
 		trace_iomap_writepage_map(inode, &wpc->iomap);
-		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
-			continue;
 		if (wpc->iomap.type == IOMAP_HOLE)
 			continue;
+		if (WARN_ON_ONCE(wpc->iomap.type != IOMAP_MAPPED &&
+				 wpc->iomap.type != IOMAP_UNWRITTEN)) {
+			error = -EIO;
+			break;
+		}
 		iomap_add_to_ioend(inode, pos, folio, iop, wpc, wbc,
 				 &submit_list);
 		count++;


