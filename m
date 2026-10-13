Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB14F3EB0;
	Tue, 13 Oct 2026 12:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893520; cv=none; b=Hic5TGwhzD0T2Ae/ATB5ODWxjSR8nGNgpXf9h3JquzBImDs2WAV4MQZq+bpdwy4l02dJg67F9g6zuWgT+Z87SpYD+07+QGEkTrTzHxBNb+WPu1k/Pky1xFE3bUAmYMCrFiGS3RlCOj/E3d1I/Gcycy52MDlVygu7Zk06o93USag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893520; c=relaxed/simple;
	bh=/nyVrhKqaZZ1oYqFGJ7hfKA1qRV6l7TykrnocZ9bhIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgcpgILOFve//YpXMkBH1u60bz/EXtovZt5uF/zuL5eiVomeg4H2JLMUEOkcgzvEfjb7qhl4UIO3ovxQDOwE0n1l6iExEW8uzDMq66QLoR6b8pT3cUXG604puxamHI5FPZs6jjtgRQ5N8lOAPt+GxqOramxQku3QjrwzBkgjZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWTgj5ID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWTgj5ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31881F000FF;
	Tue, 13 Oct 2026 12:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893519;
	bh=oqSA8b5dQxIgI8IReUGJKW39ZqsdqDuKiHgyKMYP24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWTgj5ID428JMQ28D/IGZJmfpK8yQell1L+CdIUzQvM9iO8uPMu5xMQs17t5W8b24
	 60PN8gEY/NEctmo1eUE92P+8sduuueRRLBE0wqYlt4rO2Q4Nk2JilpBx6V2cXWoYjv
	 EcmVKbPqxenA7D/n5PafNGhInQYljaH9BAExyois=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/621] libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()
Date: Tue, 13 Oct 2026 13:33:24 +0200
Message-ID: <20261013112925.821686219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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



