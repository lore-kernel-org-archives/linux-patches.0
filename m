Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA4B409605;
	Thu, 28 May 2026 20:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998680; cv=none; b=qhtXKlGj4dIYBtMrbMBKUKE27+mPJ7J4X7lvicqf8UCTZ41MFRtEIZ0erPa586rmQeXoRYilgFXSPh+YSNEIbMjzyo1k9eONIs4gX3jcQsmhThA55MvDyJfUk/ciEjnq6aV/LJwiSSxE1+UJ7BJrWOMP+SwXxUmS3YFw0sSJeL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998680; c=relaxed/simple;
	bh=gdAyA1MIGXA7UoLkv1DARhJD4w7cAio48Cck3x/tIOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNL/OVZ5cmfgCw4oX2ngaj2m/RRWYx4lqcCV+BTTTPZkFT84+W25hxgOgtXvJuSJvLp4MADC6GupRiBrQgaQX1xWS+pm9GHXrFMAk5V7NwSdevWcu5rpEMoSeYLZWOZGASlEaqgeydnUxazPbQK1aQQgOct3B9FlnL1dDj5lYZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa/fmxqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa/fmxqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A4B1F000E9;
	Thu, 28 May 2026 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998679;
	bh=GdPPDIHlk45WOBUc6jEgU4nKZPLNzgIH8RQ/Elyv4uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sa/fmxqQRrZLDzI1jPEf1iYxuUaUvDDKLAiijEFNVSBhCat408+bFvJ5LO+cdDGSh
	 7fHU70ajTfFeVt6sTCQlOlJFdRNsCRNfsCg+8O5OjXDJ160BB0WmSzUJp6ReOCnkQb
	 qaQ2c21mZMsBPUQOAHHjG1kuU9c7Qozu7SlF1MLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 259/461] netfs: Defer the emission of trace_netfs_folio()
Date: Thu, 28 May 2026 21:46:28 +0200
Message-ID: <20260528194654.653091995@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit daeb443b92817021c1234e8eded219e164b7c35d ]

Change netfs_perform_write() to keep the netfs_folio trace value in a
variable and emit it later to make it easier to choose the value displayed.
This is a prerequisite for a subsequent patch.

Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-13-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7b4dcf1b9455 ("netfs: Fix streaming write being overwritten")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index c887a30c14d91..a695d5168b2fc 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -150,6 +150,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	do {
+		enum netfs_folio_trace trace;
 		struct netfs_folio *finfo;
 		struct netfs_group *group;
 		unsigned long long fpos;
@@ -223,7 +224,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_folio_is_uptodate);
+			trace = netfs_folio_is_uptodate;
 			goto copied;
 		}
 
@@ -239,7 +240,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			folio_zero_segment(folio, offset + copied, flen);
 			__netfs_set_group(folio, netfs_group);
 			folio_mark_uptodate(folio);
-			trace_netfs_folio(folio, netfs_modify_and_clear);
+			trace = netfs_modify_and_clear;
 			goto copied;
 		}
 
@@ -257,7 +258,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			__netfs_set_group(folio, netfs_group);
 			folio_mark_uptodate(folio);
-			trace_netfs_folio(folio, netfs_whole_folio_modify);
+			trace = netfs_whole_folio_modify;
 			goto copied;
 		}
 
@@ -284,7 +285,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_just_prefetch);
+			trace = netfs_just_prefetch;
 			goto copied;
 		}
 
@@ -298,7 +299,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (offset == 0 && copied == flen) {
 				__netfs_set_group(folio, netfs_group);
 				folio_mark_uptodate(folio);
-				trace_netfs_folio(folio, netfs_streaming_filled_page);
+				trace = netfs_streaming_filled_page;
 				goto copied;
 			}
 
@@ -313,7 +314,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len = copied;
 			folio_attach_private(folio, (void *)((unsigned long)finfo |
 							     NETFS_FOLIO_INFO));
-			trace_netfs_folio(folio, netfs_streaming_write);
+			trace = netfs_streaming_write;
 			goto copied;
 		}
 
@@ -333,9 +334,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 					folio_detach_private(folio);
 				folio_mark_uptodate(folio);
 				kfree(finfo);
-				trace_netfs_folio(folio, netfs_streaming_cont_filled_page);
+				trace = netfs_streaming_cont_filled_page;
 			} else {
-				trace_netfs_folio(folio, netfs_streaming_write_cont);
+				trace = netfs_streaming_write_cont;
 			}
 			goto copied;
 		}
@@ -351,6 +352,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		continue;
 
 	copied:
+		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
 
 		/* Update the inode size if we moved the EOF marker */
-- 
2.53.0



