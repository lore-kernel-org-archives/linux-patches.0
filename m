Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A513921FB;
	Sat, 17 Oct 2026 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258730; cv=none; b=aPJsgAyk4RxH22Hk+ObU+lPEmjZQrXYmi+owPWFzaifYw6veVeBv3M4Y3I4ULMuzqimHKOgJJnmYZhj3k4Q7i0nxPh/B8ouMuzgn3Lc3fzqZn7Auwjsv08Q+vwDHwq2DD0XEknFAsKLSNQID4fMEMJcOKS0l7tSdFtlbRy9oKoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258730; c=relaxed/simple;
	bh=W93VKC0fi+UBoLVG4CBtF96UghM2VEOyF3+gWsbDn2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrYu12NE+gMLaJ6aMhhR6GfdhVc18NdWLEfrJzXr7O+0FnAye8DGbrU95gPVldNG6URMAWz0KIUxqKKg5FGxGCUbnMNjfAzY5uHUu4idhZ2Rjvt2swcwcGqzwZszggatkXeImkPrLnv2GbIqxhvCf/z1chss9UpixZJj/hF/Q64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=av1M5WXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="av1M5WXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC711F000C4;
	Sat, 17 Oct 2026 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258729;
	bh=k7s/SlYYzN/iHv/R7W5wU28pSvYB5f9bLzG9eo8a2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av1M5WXJ9Si8WKg/KM/KUuFQGrKLTN8x55G17VLcDGpzxdwO2yTdg0qf27OnpODCu
	 PSkJHSsFnc6Q6VwwVIK3gslualjKIkgB+P6gHw1967duxcC1cUR8151nWwjmeBv4Hx
	 omZd9TD/WI81w2TdE6SoLkdy+ECt8uzTcnqUoxrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0981/1674] libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()
Date: Sat, 17 Oct 2026 17:54:13 +0200
Message-ID: <20261017160456.306189844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 821365487aa58d06bda65c676ba215d506ba9768 ]

In __ceph_x_decrypt(), a part of the buffer p is interpreted as a
ceph_x_encrypt_header, and the magic field of this struct is accessed.
This happens without any guarantee that the buffer is large enough to
hold this struct. The function parameter ciphertext_len represents the
length of the ciphertext to decrypt and is guaranteed to be at most the
remaining size of the allocated buffer p. However, this value is not
necessarily greater than sizeof(ceph_x_encrypt_header). E.g., a message
frame of type FRAME_TAG_AUTH_REPLY_MORE, that is just as long to hold
the ciphertext at its end with a ciphertext_len of 8 or less, can
trigger an out-of-bounds memory access when accessing hdr->magic.

This patch fixes the issue by adding a check to ensure that the
decrypted plaintext in the buffer is large enough to represent at least
the ceph_x_encrypt_header.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/auth_x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index c83559f015e46..f805a813308fd 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -86,6 +86,11 @@ static int __ceph_x_decrypt(struct ceph_crypto_key *secret, void *p,
 	if (ret)
 		return ret;
 
+	if (plaintext_len < sizeof(*hdr)) {
+		pr_err("%s plaintext too small %d\n", __func__, plaintext_len);
+		return -EINVAL;
+	}
+
 	if (le64_to_cpu(hdr->magic) != CEPHX_ENC_MAGIC) {
 		pr_err("%s bad magic\n", __func__);
 		return -EINVAL;
-- 
2.53.0



