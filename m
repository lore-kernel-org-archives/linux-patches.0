Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631944E50CC;
	Fri,  9 Oct 2026 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555701; cv=none; b=CTVWpZ2Bx7Gw4QC0/sqXSBIPuUHz3tZ9o04FFum6pAE9/x6IIQ55BOnIFVmKNeIrdU46zpUZHHD+d/iiJA6WNOpW8JLosvHxF4O5mK1/e6iZylEclrGxcWR3aFmcJzj6w9Cl8SH8DAQdAzlGSxi571OcDRy/0Ev8Q0NYYaGg2Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555701; c=relaxed/simple;
	bh=SMKlheObTu536tA7hgxxI0Ur5MIw47ch2t/HW70/6dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyyoVLMwFSxqH5xHiNeOfco7MsOytZLDmYAFh4mHjGz9hdA5D5CVECEzdLj784PdCps2MiwmzQ+RGZV3ZX8jGnn9EtrmiawVJo/PhmUmm4w4r4Xp+YzCmNOOLwGVzUzOM0sWJW4yXbLSIHplHBvsgOf6QMtwgfm1d3sSF3FGPm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLmWyZlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLmWyZlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865791F000FF;
	Fri,  9 Oct 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555699;
	bh=537bWLYqvyoaYnWVE06YbMJvvPxkeXO6z+gOSnZSf6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLmWyZlHrI2sSeSRHKMhBy4l3jA8Re+/7EeHDLs3WrHHbBK4KirsP5AHE3qqTUod/
	 W41uspxsb9uGL6gTfJk2jNcYmhL4mx1niFFK5yHyCAptuIMofpg1tK0o1orIDhwJmv
	 pxxDVOIW5Jeid+chkMMTMXAdqWXn0CPKdcCHokpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 051/428] netfs: zero the tail of a short DIO/unbuffered read
Date: Fri,  9 Oct 2026 16:06:28 +0200
Message-ID: <20261009140947.241361101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit dd05add7b2b6004c5fa3a1f276f56d8668f86b65 upstream.

The buffered read collector zero-fills the tail of a short read that
stops below the inode's i_size (netfs_clear_unread()), so a read that
races an extending write still returns the expected number of bytes.
The non-buffered collector path does no such thing: it just records
how much was transferred.

Add the same zero-fill for the non-buffered case, gated on
NETFS_SREQ_CLEAR_TAIL: a subreq's source sets that flag when a short
result from it is known to be safe to treat as a hole, as opposed to
NETFS_SREQ_HIT_EOF, which means the read genuinely ran off the end of
the file and should be reported short as-is. Only CLEAR_TAIL should
zero-fill here; a real EOF must stay a real short read.

No source currently sets CLEAR_TAIL on an unbuffered/DIO subrequest,
so this is inert on its own -- a following change teaches cifs to set
it in the one case that needs it.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_collect.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -33,6 +33,22 @@ static void netfs_clear_unread(struct ne
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 }
 
+static void netfs_clear_unread_dio(struct netfs_io_subrequest *subreq)
+{
+	uoff_t pos = subreq->start + subreq->transferred;
+	struct netfs_io_request *rreq = subreq->rreq;
+	size_t fill;
+
+	if (pos >= rreq->i_size)
+		return;
+
+	fill = min_t(uoff_t, rreq->i_size - pos,
+		     subreq->len - subreq->transferred);
+
+	netfs_reset_iter(subreq);
+	subreq->transferred += iov_iter_zero(fill, &subreq->io_iter);
+}
+
 /*
  * Cancel the copy-to-cache mark on a folio.
  */
@@ -311,6 +327,14 @@ reassess:
 			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
+			if (!(notes & HIT_PENDING) &&
+			    front->error == 0 &&
+			    transferred < front->len &&
+			    test_bit(NETFS_SREQ_CLEAR_TAIL, &front->flags)) {
+				netfs_clear_unread_dio(front);
+				transferred = front->transferred;
+				trace_netfs_sreq(front, netfs_sreq_trace_clear);
+			}
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 		}


