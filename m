Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210201;
	b=dFYOL5u9IWsP9GQqMxm5gWMwGD9MlTXdMk8GrtPhEL9Bm+KQwV3+poY+XTYtqgl2SEem
	 ZRrjhd+/uawjrj0uYxpjrsW70Oq32Z3HgkZSjVSYsh2P1OPJAF8sAdTtyDoAECaI2jnjw
	 oC37RFPNS3vVOKlIRiDOH/Odg20iBuoB0U7CnIFpRUFI7l/Q2lALZTutnWMnNpk59EnlQ
	 wa+tWA91IDdyVO7mzerZ7zptNsyPZvs0We7MJq3g3vFIA5W5Yh3H4hxuD/VsLNbKpoRgk
	 diOz0q5rCVElhb/X359iLA7tFMYXCb31UFHIgJ5xdsn8v5mbPJlJg5yn1mv6CoDW7NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q/rfqLkirPmOkKUUnft3OILsul5u8GL1d3fQF1wvp8o=;
	b=ANYYc05Ayro2Bslfpy3dji7W6d20NCXx0zkJgWMjU5ELdZESRXdvwDL/q1QOMTLrdZqT
	 M96SmVGUqk5zfIxyJr/qb7Jq9VLbDvNGnWvXQZ+c8QvRclHHjOykF+ZpmJ+bxGL/BLYBz
	 BC9KnpdbWSDpOSv1gcnxp812nvlhKEU/0e8CBG4JilWBaBChWRHWV74KzqAUzcrObLbDq
	 MTjUVzv3ZWhxGGXAVzHEegRH2/O9rM6WO1Cp+9sSJ7pJL5IzeAhLz3j/9fQ8utYqMzRkl
	 3e3BuO8tASeA5anbYNlauvmkqy5fe89Dq//RE72NeLQw3gkLGsdBz9COToJOF10c9lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBoVwfIF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDCB606A32D;
	Wed, 28 Oct 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBoVwfIF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD82C1F01825;
	Wed, 28 Oct 2026 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210201;
	bh=q/rfqLkirPmOkKUUnft3OILsul5u8GL1d3fQF1wvp8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBoVwfIFY9VCCIPBsTc0X3T7ul3BwJ7unuvThIAhoMF2zxozpT0DRFuOmNmvW7O6M
	 sJdNT3y5eFpE5X73LFuu5UiMJbMTI2Icv/DF62KWV4V6lEbciLyChwteZzk1swLzzc
	 VctG9MnF9vrDynX2MGDAtVynhdESV9CsKsaySLoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/168] dm-integrity: fix infinite loop on discard with large tag size
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028165945.762878814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

[ Upstream commit 18d80c77b4c7dd20699e81cedfbbff4e9d198f28 ]

When integrity_metadata handles a discard, it fills a buffer with
DISCARD_FILLER and writes it over the tags, max_blocks blocks at a
time. If the kmalloc fails, the buffer is the on-stack array
checksums_onstack and max_size is set to HASH_MAX_DIGESTSIZE. So if the
tag size is larger than HASH_MAX_DIGESTSIZE, max_blocks is zero, bi_size
is never decremented and the loop never terminates.

Fix this by using sizeof(checksums_onstack) as max_size. The array has
MAX_TAG_SIZE bytes since commit b93b6643e9b5 ("dm integrity: fix a
crash with unusually large tag size"), so max_blocks is at least 1.

Fixes: 84597a44a9d8 ("dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ sashal: Adjusted context for the absence of keyed-discard support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d66eb4e36811a..a10143b51c984 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1814,7 +1814,7 @@ static void integrity_metadata(struct work_struct *w)
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
-			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
+			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : sizeof(checksums_onstack);
 			unsigned int max_blocks = max_size / ic->tag_size;
 
 			memset(checksums, DISCARD_FILLER, max_size);
-- 
2.53.0



