Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52834223708;
	Tue, 21 Jul 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654837; cv=none; b=ibbPXeHOv0NNbYD88H2/9Y7ZmbL3iaYeVk+usBqvY4FyqrQMh/GWMoujrTL1vvXrQfRqXKsYQooUJHkVkKWm434wds60JXkdEfbYPgG2/5/SYjw0c455tpsMvYCT9rbWg6rghYpbtIFm6TB8Ok4Cgn1A5prvB5Y2dzZEB77/yIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654837; c=relaxed/simple;
	bh=5CVFTr9ylqCfQmm4+qjICioHoJYiGjrqy4ee2f0AQX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKhmua7vYl2wu3HD92cdYN0jTUDwHMsKORwSblBLl964IlNu6Z3LZadBpd48KEsgC2ewHI3KofEdig/uJTNTaMvXso2/2RTSN0aFFC+Ljk57agzURllLJyedkCoPHTRbLf7lYsbF7X0BYW/DrIhrRdOO1/lydh1R/UoPtSORA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9P+teLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9P+teLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DC91F000E9;
	Tue, 21 Jul 2026 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654836;
	bh=wdfaQGs4TLVP1Q5wdEL4olYfuu1quDHKsXi7HQP5tb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9P+teLj1wKDEovguQjPj0q6ya8b64d1sMoeE5TOuznNczjj6MTladKDj0xNhystM
	 C9DK8FHO1YnwLdVbgriselWz9rC9KvDvqXbMpRFyrrFC6IB6/mxQeLAo5qE61+cIHk
	 4Oak3UTtFZfOlVkwlI41iZ4NjDfMgyPgszrT12MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 7.1 1857/2077] dm-verity: fix buffer overflow in FEC calculation
Date: Tue, 21 Jul 2026 17:25:30 +0200
Message-ID: <20260721152636.536268979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e upstream.

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    4 ++--
 drivers/md/dm-verity-fec.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -220,7 +220,7 @@ static int fec_read_bufs(struct dm_verit
 				     PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -238,7 +238,7 @@ static int fec_read_bufs(struct dm_verit
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -47,7 +47,7 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_MAX_ROOTS]; /* erasures for decode_rs8 */
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
 	unsigned int nbufs;		/* number of buffers allocated */


