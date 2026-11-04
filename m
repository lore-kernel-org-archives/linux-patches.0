Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828987;
	b=aBDRAw4bSeQmajlY6J7vru6CSC1Nk4dmVDAHldOnhaD9sl8Rtye15lZIkiO4XxQk5SSC
	 eWXppmcgNQNOMUYp+CEUd7N9Gomz5hCgHx2SW3RhRVR6AjJ0/7ICW2a6NJMhruYI7oGMT
	 jfShy51mlHwKysYjdGLOU3X47sUIqMrqFQzDdH9cKdNcwBOR/4hyB/exP+TXd+9VwT+Zg
	 dCvaX8mpDv7rS3rWcEasB10cvmqrwZiwNjxDlxwX1eq2SsKNuiNuRrAy+f3HAzROo40Rl
	 hOx6BnDcMTv5u2KQN/ntPNbwyH97qGFhgrsTEJ0HGivt9y8q5bciVuspoAkLRm7Zghg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzsI+T5PnSrxuTsKJDajUM6yU8Q9edS/nGr+j5gQREY=;
	b=oLPwH5vo4UibPidu17RpX94Kqe1DzJbmmHPkRPTctgZtO1G9uexMM18HSjHQYRCGvkvQ
	 BzcIZ79nmBPPYaU73pvv7y5rnyJ+7BV3WQnN8X1NBYeSDi3oPxxgmDmgKEDeRCDkcKRmQ
	 49tDmsOt013AsHxHhc0ZNlku7yoqUuQ/kTSpzDba79flKP+FtNspvoSJqrCUCuc/DTilX
	 Z1/W8Lm7L71v4RIu2oVbdsGWyOVJiTKvtc5scUfO4krOw+Z2DDbV+6hQB4cxxAAYjD7Td
	 KuemZOQFBaAJwVbTsgQyFd2gibPMLRbzg2+MAwzR2mG4vmSKtpVZAMfq6TOs6aEUItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EskhZr+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F0607F281;
	Wed,  4 Nov 2026 21:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EskhZr+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D9B1F000C1;
	Wed,  4 Nov 2026 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828986;
	bh=GzsI+T5PnSrxuTsKJDajUM6yU8Q9edS/nGr+j5gQREY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EskhZr+WVWEHhRxkI9wc5q+hGM2g8Z6IAlyroSg1wY3KSouBwL5hgvanmA5UoyiBT
	 tN+KH8MdIj4BKk957kERpl6YMQalsR1ia8Dsj/ph1Ig7izQheDSo/sXpdlXSPtmmnI
	 W7LDLXt/JKwk5YG3fQIUwAqt6H+m9euKKF3k5PrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 371/547] xfs: propagate errors while checking null siblings
Date: Wed,  4 Nov 2026 16:09:15 -0500
Message-ID: <20261104211048.840989488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit e5bde75a816b3549942f4b09a8bf09006b7ea9de upstream.

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -257,9 +257,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 


