Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EFF4E4306;
	Wed, 30 Sep 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786198; cv=none; b=NewYr6Ls4EYPJsh73cBjOy5oXUfGPRo7CZk14WDMwO3WhYSK8UkLYrUZ8tQIgSJ4veTKYPY2oi+tEV33nnE1vPRA91Z0W+x54nEaOAa4QryfBdLBRi2ju2RHiEWnWvbDP/fOkpZo0qdXqQ7KGCr+/F920qLazYYT7LYuoOa+Dho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786198; c=relaxed/simple;
	bh=FBWvkbaA8hcUf61SCsi2QbsqKeJYrjysnE5OQyvv1mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVCx9miqTF2deF1reiqIKlcIXrbF0S1VLEcBStMnw7YmjZt2B+CWTKUN2w2BcHrnU/uIgiXH8VkwVzWbYXyTCHbUsHL3YOp9Rg6Fuo2Qek/+D/YqWu8bQTKO3YSY8HvDAwrOSuDDoOEzDIFv4wq5CvBEWlcqu6gaCiHLJmRwQyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxIPVUKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxIPVUKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE9A1F000FF;
	Wed, 30 Sep 2026 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786197;
	bh=hTExEzn4nqQ3c2GsuW0hl3R8TAo189XF0lfoLf8Idss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxIPVUKC/B3EVyKktlFb2RK7D/7Yq2LiX3Hgsh299kooJ6ZAvekDFvg2k1X0Clxme
	 c3OpMTJ1KzsW7vQRCQWOaLD3ayseoKu3HwtARmbsfyV5mGa35EGD2PpvQpIPioO6VR
	 ZBwB2kqNOaW8Sz/B3KpJvuOVD9MrRaxX+a2rj+Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 775/982] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 30 Sep 2026 17:25:11 +0200
Message-ID: <20260930152433.399641424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 1b3221bb121079ad79a1f3c3aa360ba649832e7a upstream.

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -736,9 +736,9 @@ next_iface:
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}


