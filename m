Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7839F4756BB;
	Fri,  7 Aug 2026 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115065; cv=none; b=R4n1RM7Ap5m1N5jqVkip+eq/k0wnywkIwy6tfp8c4KFcwFlGu6IecJcc+KWrNTm4OZSk3KDMBG4UQYExpHfIEv4kZzlbYynjhHtgT2udMKDsWWJFybORiSfeC8UBuY9+eFH3sKkhdkU2AgpkhH8kec1ac4BPC7k6FUo0VHHdEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115065; c=relaxed/simple;
	bh=G3PgBkegK14GkvDauW/uoxilVyPrVXhreZit1IpmSro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTdtCygogUxmMifR0nj5GzekeCIdh5jWOKd5ybKH3tPrc4ThBXw5rUoUv6QJBWIeZNlb66Nq+kz7O6wTSHNChmRpETQeDMlPmPrRyfqE+sTUqXTLfidK/O4F2InpFaoOdxTIlK7WCKP4KZjI7ounCnw7sc7K71ogmigtuPkRZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoUEFQJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoUEFQJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AA81F000E9;
	Fri,  7 Aug 2026 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115059;
	bh=2yyd283gN0ssyFozjAP6TltQzeMkybBTvH25YghcAoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FoUEFQJCdalw7WbQERg/qTBCHeGmO74yO9XMnJ2TMFpp2IgYwlMtP2BszqMxY13vi
	 p7Tyjdj3fAw71s0mPknXyuCCNNS+efaBL+WXDqxkdRK4yjPowZTV8i21VKZy9/mwNY
	 E2z9m/iXLKnluO7MTMxh1oDvdaxdcZYDCJA94aPQ=
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
Subject: [PATCH 6.18 099/396] netfs: handle single writeback rolling buffer allocation failure
Date: Fri,  7 Aug 2026 16:34:19 +0200
Message-ID: <20260807143426.427241025@linuxfoundation.org>
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

[ Upstream commit 37a1c535c80c67d98668d190c7432f9ebda43310 ]

netfs_write_folio_single() takes an extra folio reference before
appending the folio to the rolling buffer.

rolling_buffer_append() can fail if it cannot allocate another
folio_queue. Check the return value and drop the extra folio reference
before returning the error.

Fixes: 49866ce7ea8d ("netfs: Add support for caching single monolithic objects such as AFS dirs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260727130716.1099906-3-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 76614339554ea..5f216907b1e50 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -730,6 +730,7 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 	size_t iter_off = 0;
 	size_t fsize = folio_size(folio), flen;
 	loff_t fpos = folio_pos(folio);
+	ssize_t ret;
 	bool to_eof = false;
 	bool no_debug = false;
 
@@ -758,7 +759,11 @@ static int netfs_write_folio_single(struct netfs_io_request *wreq,
 
 	/* Attach the folio to the rolling buffer. */
 	folio_get(folio);
-	rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	ret = rolling_buffer_append(&wreq->buffer, folio, NETFS_ROLLBUF_PUT_MARK);
+	if (ret < 0) {
+		folio_put(folio);
+		return ret;
+	}
 
 	/* Move the submission point forward to allow for write-streaming data
 	 * not starting at the front of the page.  We don't do write-streaming
-- 
2.53.0



