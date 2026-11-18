Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031473;
	b=nwiQjTCJlLwAki1gBfsU81hSYFxEeEdsj/E8j0uIdWjO6/+P7UzdPTApwNXTHvZV4yM4
	 YjJPSBnEGu40RFj9ppXKYtLjn3gP9MnqoJzbqqheMd0MipODJcWNbWFZm+3dn0dHMiBIn
	 mg81dr49WbrGuUtWtB2cgwPL9Mb0Bx3j14cSMZQHC9kicZQH9wrEc8ZuGMRn5VBtHl21B
	 7xcDhZGJuZrK5ioDuXwGzW4HdK6zaySNFYtpcEZ0qQQkowSP/AivqG5cHDfQ01AEYP/Ty
	 Z+gz39vUSrZhlfTInuIuadu66c+WvpQ2cwgy/7bQ+JcOronXf3XZgODAs2ogSsgmPgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbgl/c2dalmAYGb0img46ePFNJlqAGcZEco2LU8Gc2A=;
	b=S5viD4it/NoXfLO5Qw/Y2h60wurjjTCfdFvLLDKxNiHMhevuedGcR5MF3MczodaEm5h+
	 O+kLFiE8PcttlFEttcT7FftAZVF/49mS3D9E4wJwk+j4j6YUGQhWbnj0v8M1du8F0Br5T
	 abgu4YtksXXZ0BP+EYXgEmA46DXBqo3wI5dF4XLq8YNUHZ9vHkG4hc3od3WxE1ae8uyrx
	 RshtyQfmBvbUDDSA+10c0R4oPWd3npmfIltq1M0EI7vQjrxDWuFRKCtkmpPxJqdjilq0a
	 hnEJ7r22G9Tc6I+oyKelzMWE4zunx6UqDkXNiz7aAnLlxNNkk4v2ObIasfzbqdvv5SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPvwkNi0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B612606A320;
	Wed, 18 Nov 2026 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPvwkNi0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0881F000C4;
	Wed, 18 Nov 2026 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031472;
	bh=mbgl/c2dalmAYGb0img46ePFNJlqAGcZEco2LU8Gc2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPvwkNi0yEZRG7aC+qksyt4l3UG09Gxp4FQM5CtZyyhu/d5svupJOFcMbCtAFNhOW
	 OlHbB65fEI4FkUC70wV1JmPF+2IRxIBJqHLQJLSghZOogjm9X6CpCfUOP+neSihuru
	 IBhK6sUl26PprO90EsY0XGC2WAFZEsaJ5daxIWg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1072/1756] btrfs: accessors: simplify folio bounds checks
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150052.921290694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 00c0cf844465139ee6d9b271549295da3c7822ca ]

As we can a have non-contiguous range in the eb->folios, any item can be
straddling two folios and we need to check if it can be read in one go
or in two parts. For that there's a check which is not implemented in
the simplest way:

  offset in folio + size <= folio size

With a simple expression transformation:

  oil + size <= unit_size
        size <= unit_size - oil
    sizeof() <= part

this can be simplified and reusing existing run-time or compile-time
constants.

Add likely() annotation for this expression as this is the fast path and
compiler sometimes reorders that after the followup block with the
memcpy (observed in practice with other simplifications).

Overall effect on stack consumption:

  btrfs_get_8                                        -8 (80 -> 72)
  btrfs_set_8                                        -8 (88 -> 80)

And .ko size (due to optimizations making use of the direct constants):

     text    data     bss     dec     hex filename
  1456601  115665   16088 1588354  183c82 pre/btrfs.ko
  1456093  115665   16088 1587846  183a86 post/btrfs.ko

  DELTA: -508

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index 5cfb0801700e6..b54c8abe467a0 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -59,7 +59,7 @@ u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 	u8 lebytes[sizeof(u##bits)];					\
 									\
 	ASSERT(check_setget_bounds(eb, ptr, off, size));		\
-	if (INLINE_EXTENT_BUFFER_PAGES == 1 || oil + size <= unit_size)	\
+	if (INLINE_EXTENT_BUFFER_PAGES == 1 || likely(sizeof(u##bits) <= part))	\
 		return get_unaligned_le##bits(kaddr + oil);		\
 									\
 	memcpy(lebytes, kaddr + oil, part);				\
@@ -82,7 +82,7 @@ void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
 									\
 	ASSERT(check_setget_bounds(eb, ptr, off, size));		\
 	if (INLINE_EXTENT_BUFFER_PAGES == 1 ||				\
-	    oil + size <= unit_size) {					\
+	    likely(sizeof(u##bits) <= part)) {				\
 		put_unaligned_le##bits(val, kaddr + oil);		\
 		return;							\
 	}								\
-- 
2.53.0



