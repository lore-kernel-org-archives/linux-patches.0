Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA96314D16;
	Wed, 25 Feb 2026 06:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002725; cv=none; b=MdwwJjkbOLBmo8YYMdAkBoQnr1CS7b2Hm8fu0imZB0AMk34bXRr0lPCZmS0TqE5sMi6cmER42UVLgIJWZ5pDIL/ZtFZ6X8QaYd95rLBTUvZzFhffc1j/5WScgzuhKelHIxlx+ur1u0oguFU0FH4UAtWOq4S42qJvShHvP2B3qjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002725; c=relaxed/simple;
	bh=9TnRzfFdLZtcDRcAz9cvVhJ01O49k6Ae/G55rcqMBQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj33iW8fXaD+nMhbkad5m6Sb7efZE62uDt4d1dCtyhc/lfJbPOJKFNR/rBHMouEJpn2qXZKO77DWTqhIX9PnjAPkIswq55IZEP9ZyznYaP0BisuDkxMtS9el5uwXk8WAezy5NxxZ9sdFPGcuzOCJwMa8J0hMW0QRP/r7Za/vZrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=let3yVZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="let3yVZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF76C116D0;
	Wed, 25 Feb 2026 06:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002724;
	bh=9TnRzfFdLZtcDRcAz9cvVhJ01O49k6Ae/G55rcqMBQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=let3yVZwESLQPQMNPKjmvdZ3k3p08CwtdPq6QUsqXmXTK84xl0cJoPJfsOICVyPfU
	 Au2xRGa4jt62aZUTmjVHXi9iRKCqjnpSQHJSp1OACLlkCtOW8Fr70ByaP+HYaYsl6R
	 PvL/1XlFDLEFC3Hd/WndhjB5dgrt0nhsvq4Rrzuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/641] xen-netback: reject zero-queue configuration from guest
Date: Tue, 24 Feb 2026 17:24:22 -0800
Message-ID: <20260225012401.518894915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index a78a25b872409..61b547aab286a 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0



