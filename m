Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446A538C2A0;
	Tue, 21 Jul 2026 20:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667600; cv=none; b=dsFONxKPiPQodS7rLEbDTOabO9mJYKMED+fXgMXDucyBRdPS4JThCEoyoFJH5athxACLBoMsknTy1+9Z+hPJY7i9h12rGGuxli4a9QJF5eQ0HvrscuoDefDTty83AEkwRP/TBlSApoR4LH4HIR6vVhFh7cVUjA7xGqTZ3J8HZqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667600; c=relaxed/simple;
	bh=T/5wfewYTophPrDDbPQ2H/t3bgPAZmgo14xK/YJcKGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4MvbdoaMzd0g2F/c5Z81BvtA3bWm5MqzyaYajUx2eYMSb8N9lFpLLN26GUpqUwgIgaengAISuZaJtxs6V0rGwVysyqVIe6kwSkFb2qDYF+wfct9ZeSkkZJMYT06D7smXnY4KDi0X1xbgIP1bO6sxvPBtuug96Jokv3z259Q1hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxEsctZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxEsctZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA12B1F000E9;
	Tue, 21 Jul 2026 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667599;
	bh=QthZun2RwboafNYqd9smFj5d6gCF8PX6KNV7JmarM4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxEsctZ9co8rzv9I6MVVZrKerIcAdOkCErAiiFr20Nvsl9COk5VqoWG2EUIOVKsYl
	 D5MNkgdYCw7xVMcNZ7+7RhFLOglw9nGss34lUBVj9LJXOG4hchiIYz81LFHRdtXD+Y
	 r+fQm5TO+ewMEdXJ0wWRLkVAxNtfje9kGbzteZ80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1105/1266] fsl/fman: Free init resources on KeyGen failure in fman_init()
Date: Tue, 21 Jul 2026 17:25:42 +0200
Message-ID: <20260721152506.530362326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d288efa2b94abc2e45a061fceb156b4f4e5b37be upstream.

fman_muram_alloc() allocates initialization resources before
initializing the KeyGen block. If keygen_init() fails, the
function returns -EINVAL directly and leaves those resources
allocated. Free the initialization resources before returning
from the KeyGen failure path.

Fixes: 7472f4f281d0 ("fsl/fman: enable FMan Keygen")
Cc: stable@kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260625004834.3394389-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/fman.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1995,8 +1995,10 @@ static int fman_init(struct fman *fman)
 
 	/* Init KeyGen */
 	fman->keygen = keygen_init(fman->kg_regs);
-	if (!fman->keygen)
+	if (!fman->keygen) {
+		free_init_resources(fman);
 		return -EINVAL;
+	}
 
 	err = enable(fman, cfg);
 	if (err != 0)


