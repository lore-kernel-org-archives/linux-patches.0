Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CBD332604;
	Thu, 16 Jul 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211560; cv=none; b=i5+FxsLX671qbeNfZm00l5CC7QYta4zoRqKu4bn50bOT7M6886/NFTcUYSHJTe2ivmUPVRmwlK0OoZj7IYKFMGaojlIcZ5eS35C0P4ru9W6rOEKfH24TiiwcOnkm2I8zmDIwu36RpuqgidhrWmZ0N68tm3Q9xpr08+26XyQ2HG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211560; c=relaxed/simple;
	bh=x/K2LYtRnRmFddtLVSLjX879zHxx/fGGAgDj6iMTGuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0nOiy3y+CQCfiC23hQ6XvcgEqEo8fPZJRIF7DONcBAU3/WXbnnkFlK4z4y/HynL/MYg9Cw8wpJsJs+l8gexAV2pqhSpgTgB1z+Zp6JWQ25egrUPcqZj11mCk57eadAtE5wja4oRhiHUqeBLMu29K1x9ccUGL0rQLoqXNoTBqiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUPw6BS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUPw6BS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C461F000E9;
	Thu, 16 Jul 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211559;
	bh=vL+fnuCImJD/lZFPXPoVCpafmZiwhGRa5YPDE6OPHRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUPw6BS5etUUNPKCPfXlpMbes+5CNOO+jQkkSGYfeWtwgFcaAKr4k77yl+SbwVA8P
	 xlKZZG0RKIvtjnPGG3s7zyyf0yg/MuIzm4E/4PTJANsoQSQAWju643nfo2Nbb1tnF3
	 hz1FpmoXRszpw221iJmK6+LjI0UY1gOrtm5ulfhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 475/480] fuse-uring: remove request-less entries from ent_w_req_queue to fix NULL deref
Date: Thu, 16 Jul 2026 15:33:42 +0200
Message-ID: <20260716133055.098338638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit 1c57a69be962d459c5e705f5cb4355b841b3461c upstream.

If a copy into the userspace ring buffer fails, a request will be
terminated and fuse_uring_req_end() will set ent->fuse_req to NULL but
it will leave the entry on ent_w_req_queue in FRRS_FUSE_REQ state. This
can lead to a NULL deref if the request expiration logic scans
ent_w_req_queue in the window before the entry is moved off it.

Fix this by taking the entry off ent_w_req_queue and changing its state
from FRRS_FUSE_REQ to FRRS_INVALID before terminating the request.

Fixes: 4fea593e625c ("fuse: optimize over-io-uring request expiration check")
Cc: stable@kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -710,10 +710,20 @@ static int fuse_uring_prepare_send(struc
 	int err;
 
 	err = fuse_uring_copy_to_ring(ent, req);
-	if (!err)
+	if (!err) {
 		set_bit(FR_SENT, &req->flags);
-	else
+	} else {
+		/*
+		 * Copying the request failed. Remove the entry from the
+		 * ent_w_req_queue list and terminate the request
+		 */
+		spin_lock(&ent->queue->lock);
+		list_del_init(&ent->list);
+		ent->state = FRRS_INVALID;
+		spin_unlock(&ent->queue->lock);
+
 		fuse_uring_req_end(ent, req, err);
+	}
 
 	return err;
 }


