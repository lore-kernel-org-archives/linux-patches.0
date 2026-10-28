Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211146;
	b=gV9TgGXC2VA4jY9aYiTJo6mJmifRLoz1YQucd4NgBPSBStogEWHSKjQfq6oahOCx1suc
	 rdx/aRVF6UqI0BIXEGWb/uLxBvDJVAUy+bZh5KZ7cOmPlmALjOpNCUI71Lu+q4Hj3fivg
	 c365g1U4HxekFeU+LOX5sxuu/ci7XmRSmNPY5vPhE9fSZoZNr8OR3E471k5TQPwh/KLCo
	 yxVrIK6b0DEPTEUjZrL3Iz7oF6dvCLP065EpLCy5GLHPVvfI1aVhOVdnEjxhs76YyTmh9
	 JVI1hPXUtoBkGS/KMMgDr5+gDDu+cHw5hjtReCVBt2NVx5ielpQ0QyKE9CWVLxTpy4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LSY8iA0NAg3NJoQFFPWZxz8Lq4eGxyka42PYhVKz+bM=;
	b=vJiR9sUDtIXuTLhKV4Zo2jA1wqv1EYueqfM7W2howG/O4qvi7cnQr0qN7TPF+torlCV4
	 IeiQNu3z5oFXgyj10U2R63Da1hFgTulu77VhGNqOIA/CWp0Z5QSck+YSSTlebj62icGgB
	 EP4Zo1d9F3wVEOy48orJwFgAW69GpcOAepU4ceLstroh32WtWyMUBycFut7DBPEL6hbLY
	 /4pE8ocLgSsMMjXy33mDKyA7nRKIm66KNtIDvYNG0JUNwqUweTyi6EM8EeZ6NlWncV5nf
	 57qUub4qHPa8SfZMIP4eZMuSrjAegZdtdZJWBDVwnbeaZJs7luhLIrcOhqd1JaSnAjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TegdULJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48D606A973;
	Wed, 28 Oct 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TegdULJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2891F031E5;
	Wed, 28 Oct 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211145;
	bh=LSY8iA0NAg3NJoQFFPWZxz8Lq4eGxyka42PYhVKz+bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TegdULJaJIIRTH+E07rd/ULMEz3M/AOb2q4kNwkY/zfkpVJf0o6elroB3Owjqw+aq
	 Ys6oKOZoAmKj8JxOaguesJejjJPtoxoXUMxHGD/dRp2fNYyDGHCh1AE1jiGEsHRjce
	 QPVf7Y9xcLK3OSz9s5c5axJjM/0i1EAE/QAVKeLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 231/571] nvme-multipath: fix underflow in ANA log bounds checks
Date: Wed, 28 Oct 2026 17:56:18 +0100
Message-ID: <20261028170013.486121867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,7 +548,8 @@ static int nvme_parse_ana_log(struct nvm
 		u32 nr_nsids;
 		size_t nsid_buf_size;
 
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size ||
+				 sizeof(*desc) > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		nr_nsids = le32_to_cpu(desc->nnsids);
@@ -564,7 +565,7 @@ static int nvme_parse_ana_log(struct nvm
 			return -EINVAL;
 
 		offset += sizeof(*desc);
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - nsid_buf_size))
+		if (WARN_ON_ONCE(nsid_buf_size > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		error = cb(ctrl, desc, data);


