Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E1C2DF138;
	Wed, 28 Jan 2026 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615397; cv=none; b=BarBlKLQC4oXdBHC4MQ0MLI4Pt1XuDrMsFRvzsVq1ZSvado14Grc8iy4+qp9fwkvH20BiC07k8UKB8PI/ypM3HG7dkOrDb+G/bAG6P9QwEnm6vguyU6bFxMz229LSBhz3BYmBBRn3cNZDWT0lAnz4xPadRqgRHC6dYA5vNNfpZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615397; c=relaxed/simple;
	bh=tFGlRD6WbcddGBWcrbA9QufwiuxnE+YBunthxwIDuyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxum2srIMiKbfQI4xSMoiheo2I5+pLCBBX+Cb+rjToxOyfx0FaOBqwOTlh/RvYqfyHxABdE3STKqEFWUZYnHS4wHd0esXNYR46Nc5jWQcIorTpRFfD66TxfIEYJ+sr3o0XYEv2r+VOX5s3yzhmEBnLo22BNYg5+Rq111F6+ce4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzMOLDWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzMOLDWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CBEC4CEF1;
	Wed, 28 Jan 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615397;
	bh=tFGlRD6WbcddGBWcrbA9QufwiuxnE+YBunthxwIDuyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzMOLDWpt8KD1pLlsyVJRSjHDzT8Jkt2+hKE1sOqFpqrZU9ZnmEr9ndU3hRdKzENV
	 S2gp3DRkN5sio7WcH3bHLD1kRC3GMOkwwXw+fuUU117XlmVLMVqzNd8TJy2V3FOXWk
	 oQ6wOaOpMCWfCMNeJNYCxor1OTPeSucZqUqb+yKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 168/169] net: Introduce skb_copy_datagram_from_iter_full()
Date: Wed, 28 Jan 2026 16:24:11 +0100
Message-ID: <20260128145340.074993193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[Upstream commit b08a784a5d1495c42ff9b0c70887d49211cddfe0]

In a similar manner to copy_from_iter()/copy_from_iter_full(), introduce
skb_copy_datagram_from_iter_full() which reverts the iterator to its
initial state when returning an error.

A subsequent fix for a vsock regression will make use of this new
function.

Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://patch.msgid.link/20250818180355.29275-2-will@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    2 ++
 net/core/datagram.c    |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4117,6 +4117,8 @@ int skb_copy_and_hash_datagram_iter(cons
 			   struct ahash_request *hash);
 int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 struct iov_iter *from, int len);
+int skb_copy_datagram_from_iter_full(struct sk_buff *skb, int offset,
+				     struct iov_iter *from, int len);
 int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *frm);
 void skb_free_datagram(struct sock *sk, struct sk_buff *skb);
 int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags);
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -621,6 +621,20 @@ fault:
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
+int skb_copy_datagram_from_iter_full(struct sk_buff *skb, int offset,
+				     struct iov_iter *from, int len)
+{
+	struct iov_iter_state state;
+	int ret;
+
+	iov_iter_save_state(from, &state);
+	ret = skb_copy_datagram_from_iter(skb, offset, from, len);
+	if (ret)
+		iov_iter_restore(from, &state);
+	return ret;
+}
+EXPORT_SYMBOL(skb_copy_datagram_from_iter_full);
+
 int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 				struct iov_iter *from, size_t length)
 {


