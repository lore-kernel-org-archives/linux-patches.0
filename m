Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208710;
	b=k073XHhgH7k/2p5IbvX0CntbLbnZyZqTrk09Kq+uaBAteVfFUniyKV0dzH1NLE4Ot+z2
	 QMX+aQnbKi7XE2QzQ9s4FgMIMTacdeWeC4fw7ps+RWQ7iJ07Np8kmSylqApYynmqzKE0V
	 0ZRceocWymgYfKkn+HI+Wv3DaTf/xrBfVeGC9jlc7U8eKdlX6I4fbBok7LOPbSZqHzF4g
	 CghcBwMfbfcMsqmJnLfDU5D+M6dmxyYjaCfScvp9S1KDhlrQX/1bBFNGjJ7xNwLZs8BvM
	 kUKN/jp4yuNyUpKrDk9o7DHhyp6oOIY8l8xZQ3yEuDDzVVOz5NMGZxGq7IzmkAXrB6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7WBsGmF9EUwE1d8BEUu91LrchBdhkrI1u1zUqBX/G8=;
	b=XF2TxltpOVmoROwcSKgiUrjDIbHRHVbODDeHuo2Iy6o23JEVw8K8NBixcrmsylZ3ZlDy
	 9/PLpQTo2GSLLNGO2ag3EJdx1SsJ/i4fFUbQ4t0DrL/vzjGFf2Wq5uzCUjPGhIXRL+8bm
	 s+0asG6gOkkVFLvSRQ5cgHsW8spYqzIkiGTqzqLYBiJT4eeBb7UgvDebL7Sbk3YHQMibY
	 jCceRvd8lBI00ibhkFUww+ZGdXp7SoZXf+PCG6XiySD+ANRFjUOiuPlI/oBxrCJ0EQ2n9
	 NpD5cHwjvKZWttX3ojwq3WDxGxY4aD76Wxk73wGG0XmG21lqHGjPhvkwYMnyiKKD5PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ5rg3L7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB0606A31C;
	Wed, 28 Oct 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZ5rg3L7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00DE1F01825;
	Wed, 28 Oct 2026 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208710;
	bh=y7WBsGmF9EUwE1d8BEUu91LrchBdhkrI1u1zUqBX/G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ5rg3L7wyJgNRbgKLZ04T6sOeD6LQlcp/dRKLXttOGVss3kJjg8LIoR5EyTyt5+7
	 +qRQb2tm7lLg2ATFeo4lJJqid2WglOKFpLFg7sI8/+DE69dATABWb66Fa0vBpyTzZZ
	 dMX3r73RlM03nbjOuqK/gHklRg/nu5aF74VcluMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 215/516] nvme-multipath: fix underflow in ANA log bounds checks
Date: Wed, 28 Oct 2026 17:56:07 +0100
Message-ID: <20261028170008.593539439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 63fa2d9c9c37020bd2703fe2a6a38027b5abeb15 upstream.

The number of ANA groups advertised through Identify Controller sizes the
ANA log buffer. The ANA log header and group descriptors independently
supply the number of groups and namespace IDs to parse.

Both bounds checks subtract an untrusted object size from ana_log_size
before comparing the current offset. If the object is larger than the
buffer, the size_t subtraction underflows and lets the parser read beyond
ana_log_buf.

Check the current offset before the first subtraction and compare each
object size with the remaining buffer instead. This rejects inconsistent
ANA data before dereferencing a truncated group descriptor or walking an
oversized namespace ID array.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -445,7 +445,8 @@ static int nvme_parse_ana_log(struct nvm
 		u32 nr_nsids;
 		size_t nsid_buf_size;
 
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size ||
+				 sizeof(*desc) > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		nr_nsids = le32_to_cpu(desc->nnsids);
@@ -461,7 +462,7 @@ static int nvme_parse_ana_log(struct nvm
 			return -EINVAL;
 
 		offset += sizeof(*desc);
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - nsid_buf_size))
+		if (WARN_ON_ONCE(nsid_buf_size > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		error = cb(ctrl, desc, data);


