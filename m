Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B6344CF39;
	Tue, 16 Jun 2026 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624245; cv=none; b=H8KQXrJ0pO2k9+GP4HO1y7QHBDvwF799agYpLgMBtRdNR/ozqCXzas+sSeZETq5N/dWYuemWf7NN9LzHP/6iS3MeGWPzgEzdkiEG6F3Bv6x9q6kpFcpLgNqbG6UNUZpaAM+RD661vm5wMsTT0csPKbnKzSAP2tM+intAW+dce3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624245; c=relaxed/simple;
	bh=kkVfh2A4c4pdmV8WgtrEIo/HW1HPpzUmgyV5+BVzR68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY4+rrt+3MLbK6PSIOq5HjOw3WQaK3Jo5kpb4A3kaLaMPRKc/Zm50LKpBy3AlMAzNzjtlRO+Y7oy760Pph7irBq1InKFv9nZ8hfeaXxkkgnAotAYKiyAMGkRxWVoCu+mqHR/9/Weqo/jOsQdvb41uQVmMbs4B2bY04Btr34fIJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqxRHnTC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqxRHnTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1691F000E9;
	Tue, 16 Jun 2026 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624244;
	bh=s1iJLS0fn04HFCXhAMlhv+PDv070P+52DGV5XGPJifs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqxRHnTCcLTwQ3Ag81QNqpv2Cc5JhaakBLc3oAtFEnxyTFrmxSgz/v3ACVhZwCqXA
	 Lo/5FeHsE5YcyO8qJ7v6G+Nf2UTKDgoRiJ5zyuMqkTq93+ksMVJtmaTMIC9FKa+A0d
	 5Z+3Ksh9qGk3kpN7XQ8Km6RW33fvlmErhSMJKNh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.0 267/378] fuse: limit FUSE_NOTIFY_RETRIEVE to uptodate folios
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145124.152289312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 4e3d1b2c48ca6c55f1e9ca7f8dccc76f120f276c upstream.

FUSE_NOTIFY_RETRIEVE must be limited to uptodate folios; !uptodate folios
can contain uninitialized data.
Since FUSE_NOTIFY_RETRIEVE is intended to only return data that is already
in the page cache and not wait for data from the FUSE daemon, treat
!uptodate folios as if they weren't present.

This only has security impact on systems that don't enable automatic
zero-initialization of all page allocations via
CONFIG_INIT_ON_ALLOC_DEFAULT_ON or init_on_alloc=1.

Cc: stable@kernel.org
Fixes: 2d45ba381a74 ("fuse: add retrieve request")
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260519-fuse-retrieve-uptodate-v1-1-a7a1912a37f9@google.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1927,6 +1927,10 @@ static int fuse_retrieve(struct fuse_mou
 		folio = filemap_get_folio(mapping, index);
 		if (IS_ERR(folio))
 			break;
+		if (!folio_test_uptodate(folio)) {
+			folio_put(folio);
+			break;
+		}
 
 		folio_offset = ((index - folio->index) << PAGE_SHIFT) + offset;
 		nr_bytes = min(folio_size(folio) - folio_offset, num);


