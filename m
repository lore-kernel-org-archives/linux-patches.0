Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE7538AC99;
	Sat, 17 Oct 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254014; cv=none; b=S2W7DK5A3cmx8dD4C22Ji3dji14sjdBvopXyBaqcJddu1wxwCUY+YMDv4QMN6fnStuGOMyRkKUxvucFPBic0ELnvvmAln8PlC2H3u1Y5V43O2WeyxWFSbVqjcbz/0VXRvJY0g2sA/ReOJVeiM8W2MNmT3A2rwJGNlSwF61PIu5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254014; c=relaxed/simple;
	bh=gAYnX7rvSP0IE6hCNNhGTfpxX7u2OAbMOkcA8WpRXw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmgnXUgSB9sJh2qL0k8ELurIyCbJ71hVI1CD8g4pepAV9v/u+DY79edKsVV8PHlqIE1SLZlpNXaZAekE5FOS9mBW1Zsprpbrw1w6Bj2rRh52ThcJuwFp6kLDOXN7Zpe0REca6QHyrKzRZYjqFH2KCB8E1GNjA9YZdgvmEXp+JMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/4ytB2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/4ytB2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC62C1F000C5;
	Sat, 17 Oct 2026 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254012;
	bh=6JQOSm13ErPW5aa+YYbslCFw9kphtc7Y5OBbGRiVFrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/4ytB2JIWuQ2wMoa7XLkqd72TGDGoRd94CHHL+bYNXQees7WXt63QHYnznTDZEq8
	 jSUZAE02svithpVL1P6qmjN3BgWBy5BsOp86LWE0flA5xEpYQyngKgtl1Ptxet7CrH
	 to3VMisx2zbT7flIDk9cCl4usYJyf5Ud93/wFcv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/869] libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()
Date: Sat, 17 Oct 2026 17:52:28 +0200
Message-ID: <20261017160044.946013972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



