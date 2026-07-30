Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EAF43B492;
	Thu, 30 Jul 2026 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425009; cv=none; b=L12kPBNNBk85RoezYTopbsmpPRHWs6/pqbEJE1hJ1kVZK/BhwXM7/S4TnDIsfRaqLtZ58U+cDR64iclddbNS+6epuhZYZNlydi9s1fdZmLEzl8Em8JoIHuNmbrJLrgR64zdPiaT7uha4R82XP9HSTa8tDttxLkPiDStfLtzyKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425009; c=relaxed/simple;
	bh=GJ+alNvvxJbnzTqynHVDmFAGpoV0uP6pTFMVm99OHHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQCY/7k2nGOgpigCvM/aA7fG+R5P4imWtzByYq7OWt3BijKSfHgph7Y0osOZUNkMI//5FEV9l/54KIPYBLgYgor3fCdGVTPFA3k28xjmet0YjKffFfTy/aDaMjvjc8S3N7i8L0Av6tKz54VCiwvKyLLbEzYgo6g7WmNg1STV1hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMjXgPEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMjXgPEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F541F000E9;
	Thu, 30 Jul 2026 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425008;
	bh=JqI/J7hacUkCO0je69x++7VgG8LhU+gnvcbe/JGzh68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMjXgPEYizcCv/XksTGKR309xIJecjoJSWkq/6Gh9tuRn/b51m5RPRN9thH+N1G6V
	 QBwVbzsnyh+zPgrOO3pLqsVzM3VU7YyXWeE147XkN8fvNnty88Cl/bHP40ajX3tu4q
	 9hd4WvQCDpDZaqBaP/jAbqU+zvPOFiusGEh5fOFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/675] dm-verity-fec: fix the size of dm_verity_fec_io::erasures
Date: Thu, 30 Jul 2026 16:15:22 +0200
Message-ID: <20260730141457.703476280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit a7fca324d7d90f7b139d4d32747c83a629fdb446 upstream.

At most 25 entries in dm_verity_fec_io::erasures are used: the maximum
number of FEC roots plus one.  Therefore, set the array size
accordingly.  This reduces the size of dm_verity_fec_io by 912 bytes.

Note: a later commit introduces a constant DM_VERITY_FEC_MAX_ROOTS,
which allows the size to be more clearly expressed as
DM_VERITY_FEC_MAX_ROOTS + 1.  This commit just fixes the size first.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index ec37e607cb3f09..90a0af3f35d31a 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -50,7 +50,8 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
+	/* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN + 1];
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.53.0



