Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81B4EA398;
	Tue, 13 Oct 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892815; cv=none; b=LPUT7NRjAp3n5YsyKlDd/gu/ymhHEEqAI+jJxqx323ss/yaZR4mQgjLs1xB2l+rXMTfe53YSwdqQKL4U3nSkPmLI43b3xxXHmGlOUdgJ4jIbqRPWgjcAK7+hH2LAd1prA8mXWCRKS15NTdq9yBMAhEcO6ibfVPmmkkBwMr/kz7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892815; c=relaxed/simple;
	bh=+8/TCluGKjz3mY8+eHlLPYhywylYLAvRsplvQFyNQyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aeyc37BScUmSwjvMzzlnvlUnURWvNLbB+j5trSSXXUGBJsm0xMhPOwfo6Ww4WkxFir3XGBJs6fFGoyXrpuPPs6U7cT3ZgOZ/GDu73UITqYJZY6bdgIFME4NLW/74SqkUo+7IUa2LjD3jErDV1DBNIHXR6bXjJFY6px+EAK/iK8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwIFYF5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwIFYF5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088DC1F000FF;
	Tue, 13 Oct 2026 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892814;
	bh=kCx/JngA6bx7QVEmlnAXu0tCQKGTKgWhyGWTLp8ywlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwIFYF5Q3qlxB3c5DybDP45c1Vd/U64B9BurT68Wywz54269c3nrkPdFYUV1yfFjm
	 pZeyR/7G8RrsVYy5kSNmW6hJVCZFnMUjUKd4uzkLCl3sOQzcrxnpNkvcWSoe0lLBfu
	 p0xFDyF7fE4h3GZF7VWlSs92dB47LnbQqGvx9LK8=
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
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/621] netfs: zero the tail of a short DIO/unbuffered read
Date: Tue, 13 Oct 2026 13:30:02 +0200
Message-ID: <20261013112921.037576897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit dd05add7b2b6004c5fa3a1f276f56d8668f86b65 ]

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
[ sashal: Replaced uoff_t with unsigned long long. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_collect.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 4c7312a4c8597..8ad06678e6883 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -34,6 +34,22 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 }
 
+static void netfs_clear_unread_dio(struct netfs_io_subrequest *subreq)
+{
+	unsigned long long pos = subreq->start + subreq->transferred;
+	struct netfs_io_request *rreq = subreq->rreq;
+	size_t fill;
+
+	if (pos >= rreq->i_size)
+		return;
+
+	fill = min_t(unsigned long long, rreq->i_size - pos,
+		     subreq->len - subreq->transferred);
+
+	netfs_reset_iter(subreq);
+	subreq->transferred += iov_iter_zero(fill, &subreq->io_iter);
+}
+
 /*
  * Flush, mark and unlock a folio that's now completely read.  If we want to
  * cache the folio, we set the group to NETFS_FOLIO_COPY_TO_CACHE, mark it
@@ -259,6 +275,14 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
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
-- 
2.53.0



