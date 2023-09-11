Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB19611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD2C433C7;
	Mon, 11 Sep 2023 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444498;
	bh=8G7Avf1NypFZ9vK1dYsZr2oCWOfmBeMX+ygWvs5tgF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrJclz+FwXAsZitfushmBatGwPHKkDkk/ojhc2qYSfTIyRy9H9dqBwjvrjflqS58E
	 Vnn+4ZrvG9Z0dqx/E5CzRci6EARSdVIQVhqofuBbYVrJ5lO5guY4p0+0ZLZE01NgBT
	 q6In245PfifIp3ytHJK5UYCV1fVIlpFXMOxr778Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/600] 9p: virtio: fix unlikely null pointer deref in handle_rerror
Date: Mon, 11 Sep 2023 15:40:47 +0200
Message-ID: <20230911134634.037805470@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 13ade4ac5c28e8a014fa85278f5a4270b215f906 ]

handle_rerror can dereference the pages pointer, but it is not
necessarily set for small payloads.
In practice these should be filtered out by the size check, but
might as well double-check explicitly.

This fixes the following scan-build warnings:
net/9p/trans_virtio.c:401:24: warning: Dereference of null pointer [core.NullDereference]
                memcpy_from_page(to, *pages++, offs, n);
                                     ^~~~~~~~
net/9p/trans_virtio.c:406:23: warning: Dereference of null pointer (loaded from variable 'pages') [core.NullDereference]
        memcpy_from_page(to, *pages, offs, size);
                             ^~~~~~

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 3f3eb03cda7d6..6a4a29a2703de 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -385,7 +385,7 @@ static void handle_rerror(struct p9_req_t *req, int in_hdr_len,
 	void *to = req->rc.sdata + in_hdr_len;
 
 	// Fits entirely into the static data?  Nothing to do.
-	if (req->rc.size < in_hdr_len)
+	if (req->rc.size < in_hdr_len || !pages)
 		return;
 
 	// Really long error message?  Tough, truncate the reply.  Might get
-- 
2.40.1



