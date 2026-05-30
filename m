Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048712690D5;
	Sat, 30 May 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160490; cv=none; b=D0Rus6YqfmIiIBg3IEwOjLMajKZ+yC9Emrc+NF5IvqwDD7+0Qx/yBFjN+SuYvty2kNmYGA8ajQgerXkXeIAcRfH5soiyHHrcsXFZWNGm0QCXPITW6XQ3O2Yg4ehWotMCZMb3Mys44apeo9uKABjRDn1gHsue61ujRNyURhmo22E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160490; c=relaxed/simple;
	bh=ckuQbup+PGvtei+WIW3TnwAjF3HXuIGWwwK/XSqEYdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiJZs/DzEEP0q+qQIOWDiEDed/0/+2NMT+0iBpRvvd2/ShtM/wwmx+PpKmRycl0BbJbHH9KJdkWQQzrCyO0c84NN+/MhACLrTfv57TfMQZ1FuOCC5rBJp72LtKuWgYYoi3ap42+fGPxtfnoq5G74tc4eT1eFIHpa0xSdBHHFdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALLqcoWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALLqcoWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433411F00893;
	Sat, 30 May 2026 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160489;
	bh=ZCvY0UPojcUN63jDim3jDNGVn5Sp3zsX5xcR3kW+Kl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALLqcoWpZxAaYoL53v0SD7aVVYTBcsvXPdh9awzG9Z8xmyEvDPdJLRVVA36YLanQ7
	 /9kzfatt9ySJ1iJkhptEDTQc2sCv0CIrCdrYh0uqitok5RhkV4DgfZZXyI12LJPJj9
	 1nuwVZXxSOYdh4OgHQatIDQMFnvPB62ht1Y+Cknw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 353/969] dm-verity-fec: correctly reject too-small hash devices
Date: Sat, 30 May 2026 17:57:57 +0200
Message-ID: <20260530160310.096608250@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 4355142245f7e55336dcc005ec03592df4d546f8 upstream.

Fix verity_fec_ctr() to reject too-small hash devices by correctly
taking hash_start into account.

Note that this is necessary because dm-verity doesn't call
dm_bufio_set_sector_offset() on the hash device's bufio client
(v->bufio).  Thus, dm_bufio_get_device_size(v->bufio) returns a size
relative to 0 rather than hash_start.  An alternative fix would be to
call dm_bufio_set_sector_offset() on v->bufio, but then all the code
that reads from the hash device would have to be adjusted accordingly.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -747,7 +747,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


