Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A494756C0;
	Fri,  7 Aug 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115068; cv=none; b=FON7hkemTG4/twz/hZ7UA3ZAmbqpHPkD0CGqCBCuHpXB5K5kml53tIcUe/WI55MoUGQuxUjPNKQalwB40ElSk/PuT7jP9Vt+7NuonZr+D0QyO8Lf6Rf8HhSXMhWrPGhWGpVDwQjDxs2NUrJSC5A3d4Zo06lT1hoke4TJDOwvkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115068; c=relaxed/simple;
	bh=zt3Ym8BUVCfs1snCGUHZ8E+Q18k1WIE3DJUgJIsFfWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjYhWES4vlx4G/lC0oxcrUNovnUeZAoIi0EKR+AhMEEi8yS7D4+tk8yTa1bynAaeH3XYlvbFxBEPQBff1Lnafnbp/gUYeluqj5dn/WC8KSGRbu8nruNPtu8aX+l1qsM7aJYO/YnWYC+VSdHFVxfkMJLR3LShpN295Hd5DkDxz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehucX7/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehucX7/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9201F00ACA;
	Fri,  7 Aug 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115062;
	bh=KKwYASy8iEmaggnH4zDEzyn+L5qxUqgfFXeddLXV0kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehucX7/kfKdZoRRbwkyN+XB6UorhN4HexKPW/Nks4Cd67jL9Iflhhef9jCnTa4q+V
	 7NKF/Yl17u4ctxpYkspPaCw9YFOBuQvNAXnYulSHSeqx8KZKvKXawSJl4UuTR0c/sU
	 aQjMmOtUk6CQ+gVlNZeLx4ZBs14azpqUi/hVEXoE=
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
Subject: [PATCH 6.18 100/396] netfs: release readahead folios on iterator preparation failure
Date: Fri,  7 Aug 2026 16:34:20 +0200
Message-ID: <20260807143426.448761635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index fab3181c7f869..221287f8925a9 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -102,8 +102,10 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq,
 
 			added = rolling_buffer_load_from_ra(&rreq->buffer, ractl,
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



