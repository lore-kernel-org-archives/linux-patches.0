Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680992AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD581C433C8;
	Wed, 20 Sep 2023 12:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211323;
	bh=mgpqCkwpTV99KSFGcW24etN+To1a4T4UIqCCosUvrbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au6I1xbPC/jKrSkV2bfX7Yk4Yk0sGsHLMbKpB8vMPfeyYA58Y49tXovpw+wErkLOo
	 94YheOsy5VvgHJfviVqQg8laQhqcBypn25D3v6RzNMkirgEPLjrsEeweTT/coAhxrZ
	 mBqodQCO1H6V5QFQ4XUjr7gKSrwwKbl51jjUh7DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 014/186] 9p: virtio: make sure offs is initialized in zc_request
Date: Wed, 20 Sep 2023 13:28:37 +0200
Message-ID: <20230920112837.379095182@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 4a73edab69d3a6623f03817fe950a2d9585f80e4 ]

Similarly to the previous patch: offs can be used in handle_rerrors
without initializing on small payloads; in this case handle_rerrors will
not use it because of the size check, but it doesn't hurt to make sure
it is zero to please scan-build.

This fixes the following warning:
net/9p/trans_virtio.c:539:3: warning: 3rd function call argument is an uninitialized value [core.CallAndMessage]
                handle_rerror(req, in_hdr_len, offs, in_pages);
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index c6a46e8e9eda5..25f5caa57289b 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -401,7 +401,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	struct page **in_pages = NULL, **out_pages = NULL;
 	struct virtio_chan *chan = client->trans;
 	struct scatterlist *sgs[4];
-	size_t offs;
+	size_t offs = 0;
 	int need_drop = 0;
 
 	p9_debug(P9_DEBUG_TRANS, "virtio request\n");
-- 
2.40.1



