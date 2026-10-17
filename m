Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAF2E8DEB;
	Sat, 17 Oct 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255738; cv=none; b=RhK2Gh+vWXcYYX7YfcXERXTia+/N+i7jv9XQY/EKrAuTN3pSbMu6S7UM29ZNC2Gqsrbuuqv6tJjYwR39gpi3o/NQfQEwTgjYpdpQKOqe7ZUbEyJN+57CDW6BpZfdgAoUxUr+kUKva4Ug/34tO8J+7yca0bHuKXszcxglYwOAqLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255738; c=relaxed/simple;
	bh=n2zWxjRNZapciPmjHtV1wXbgopsMdsISR4ejSAWqMz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiLfT5ZzkaPSDzLhbqLXYQXz3LK1CWvVape51w1VPkIA7BfiL/NqiblSjuXIx14AucdESc1lW2R5fiSLeXyIGTxds20pkNWR4Qg0khM598b8IgtEH+8pJip9wljywdeSgaTW4TtnjgqKUZkw29FWsumj8rfE1TN5tc8JAxvySpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cw2uGd/J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cw2uGd/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1737D1F000C4;
	Sat, 17 Oct 2026 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255737;
	bh=MgMNHNGj6yBjWrm1PYETG2nJAlcfGfSwmB9Tx3xM8Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cw2uGd/JUl5zv/9gOE+26xEw3ac+zoS80lPy5vo/XB5Gygq1n4o0moh8/7CO6YVZX
	 GtUlLj9ncyz+jvIC+4NaRNeefIHFLFRv1mHu6DOquCp3T75/NVrpOKNexF7bWUSgZv
	 edRdjUOh1foCMtnVIGpuCY+UW/Zv+2RO6jgHnJUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 845/869] netfs: release readahead folios on iterator preparation failure
Date: Sat, 17 Oct 2026 18:01:26 +0200
Message-ID: <20261017160058.530478982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 87eb3d272dcbcbbfe5c1576c10e5dc72810cf1f6 ]

netfs_prepare_read_iterator() batches readahead folios in put_batch so that
the folio references can be dropped after the I/O iterator has been
prepared.

If rolling_buffer_load_from_ra() fails after earlier folios have been
batched, the function returns immediately and leaves those references held.
Release the batch before returning the error.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260727130716.1099906-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 23235e62f33ec..68ad1ece65a03 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -101,8 +101,10 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq)
 
 			added = rolling_buffer_load_from_ra(&rreq->buffer, rreq->ractl,
 							    &put_batch);
-			if (added < 0)
+			if (added < 0) {
+				folio_batch_release(&put_batch);
 				return added;
+			}
 			rreq->submitted += added;
 		}
 		folio_batch_release(&put_batch);
-- 
2.53.0



