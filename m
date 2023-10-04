Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F01D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPaVAX/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B75EC433C7;
	Wed,  4 Oct 2023 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444080;
	bh=MBZyKVU761WTgHRtp6DaWG8R1Peu8kRgNfgiBYSUqNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPaVAX/Dfm4X01jdsRZZIU3U4bQc1q6uLH0uVOIsuEPkWDFsmwvFQRomUyhncX0xx
	 fknTAF1Q6TRD/Va/EnwJI1j0lBdCI25x4sJ4PL/zN2fMmbQmny4iDvp+UkEGbaR0e+
	 yAvoQsFZyJeRtgxoWQTzss9Bmp5GQeLZ2JJSJCaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 116/321] direct_write_fallback(): on error revert the ->ki_pos update from buffered write
Date: Wed,  4 Oct 2023 19:54:21 +0200
Message-ID: <20231004175234.607370122@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 8287474aa5ffb41df52552c4ae4748e791d2faf2 ]

If we fail filemap_write_and_wait_range() on the range the buffered write went
into, we only report the "number of bytes which we direct-written", to quote
the comment in there.  Which is fine, but buffered write has already advanced
iocb->ki_pos, so we need to roll that back.  Otherwise we end up with e.g.
write(2) advancing position by more than the amount it reports having written.

Fixes: 182c25e9c157 "filemap: update ki_pos in generic_perform_write"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Message-Id: <20230827214518.GU3390869@ZenIV>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index 5b851315eeed0..712c57828c0e4 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1646,6 +1646,7 @@ ssize_t direct_write_fallback(struct kiocb *iocb, struct iov_iter *iter,
 		 * We don't know how much we wrote, so just return the number of
 		 * bytes which were direct-written
 		 */
+		iocb->ki_pos -= buffered_written;
 		if (direct_written)
 			return direct_written;
 		return err;
-- 
2.40.1



