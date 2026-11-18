Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021745;
	b=K2Te9SrHXnYtp0H/5FzX4JztC3sTyjVkEWZreQs3oNVyE2TDrBEONcImFa2Ierwdhhg1
	 nBgUeW3DKPxhqTFNgr5TI/hLxG/8laT4YgAudGqVzvR24uxIrf/rkyyPFALz7e2ZXO6uD
	 nKFjMhxLJSbnVzyOUNvJQWAVLQA9RzAl9KIml5uWDekzLPXetvfBGAQJwnBVKlYBv819y
	 pnUaXRZW3SVhLHWgaS6hRAWlS1Ko0MbhEa773bU++r2BPgC7ko6otJC2aPE6kpsumr7Pe
	 yVHUc4UJgG3NXQoJOB5pRJ/jAIoYzPPSDcTpQYTrk1HFxAxG2Y44fqXIqo4RhUoq4ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J/7VnSZ2jZ30LfM3AI2XIoFyQcMEvX9V4JzbvhEDFdM=;
	b=vXZe34q9MpK5/PHCYGutSBeerwCrQ4Sre5/mCiFTqZ40PaHoFCMUsGhRpw/O/b8KkHp3
	 U5yESOAwC5CGWX1DPwqhre0690DBzp1ozcZUiwuTnpgUA4IY/QU9/EEEpeIHQIPbZPiNQ
	 EXm858E4fhENW2cZERaD7UZnVHJOqOLb08XYEd4BwEq0nmmpKrIBPhtqH0L5/v3KxmhgI
	 Fb3x+1n0iOm8evc2K6jRpcUiJB3f9wy19ChIEQrXCxPsTFX4pZqsoikanlNwlS6IGYDkU
	 yfqzVwAat4fZx+TlMlw/JMbPuP5wUhCGlfMLLqhjd02P4O88TStRh/euI8hLswEcZZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/4zJf25";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AAC60A2631;
	Wed, 18 Nov 2026 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/4zJf25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B571F000C6;
	Wed, 18 Nov 2026 17:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021745;
	bh=J/7VnSZ2jZ30LfM3AI2XIoFyQcMEvX9V4JzbvhEDFdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/4zJf25d1z/x2V+uAWRWWsBIlgjYxQqbCD8YETU1SmmZiRdC8n/mzmFtqB2c0cXt
	 QOjRQWFfnOtWiPsUIdG4wKpob7URBJt64W8WcCbt0TRZvo5R5ZJLImDajlyr2jG2Qk
	 KK8jMQWXM4RqgJKlyEy+RT9EkAxZZmbvPaHxXuy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2417/2651] ceph: fix writeback_count leak when a bounce page allocation fails
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150412.285620523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 7807710d88ad03e7ca9b5f79f518f040db2a4e09 ]

ceph_process_folio_batch() calls is_write_congestion_happened(), which
increments fsc->writeback_count, before calling
move_dirty_folio_in_page_array(). If the fscrypt bounce page allocation
there fails, the folio is redirtied and never makes it into the page
array, but the count is never dropped.

write_congested is only cleared when a decrement falls below
CONGESTION_OFF_THRESH, so the leaked counts set congestion early and
eventually leave write_congested set for good. Every WB_SYNC_NONE
writeback then returns 0 and background writeback stops entirely.

Bump the count only once the folio is in the page array.

Fixes: d55207717ded ("ceph: add encryption support to writepage and writepages")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902-remove-wait-on-page-writeback-v5-0-0b512e77e75b%40columbia.edu?part=1
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6a61508be17e7..60cf6a81af35a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1417,8 +1417,6 @@ void ceph_process_folio_batch(struct address_space *mapping,
 		doutc(cl, "%llx.%llx will write folio %p idx %lu\n",
 		      ceph_vinop(inode), folio, folio->index);
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
-
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
@@ -1431,6 +1429,8 @@ void ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
+		fsc->write_congested = is_write_congestion_happened(fsc);
+
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
 	}
-- 
2.53.0



