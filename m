Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67846360EED;
	Thu,  2 Jul 2026 16:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010152; cv=none; b=usd0faV3YatR+4519h5Jp3g0+gY8Z6DlytivUv8TlD/5YED8xadeGqPbm6T8mCnSbzFdz8cKwSrs2jXgMJYMw4be/xmfdqLRLV4gukhT2EX5AfYphdr1VhycwkzwMATDWaWMXlIRgztdXzWtdmoMDXIZmkAqRBGih0CcqrYLzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010152; c=relaxed/simple;
	bh=bq+CBrXBrMbggaBVYKMhxtxfIY7PR+2K0Y2tc6qCbI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SitSV6hsT6JUw44fDQZdSBqtDYF3GEzCQRvR5nTwUeI4s0ZQD8cx0eGhw4Sh8hXyaIQiz6aVPWzK1jmWFE9e5OPhZ8BtognQMPxqHVeIFTYV5+A2UGWLJFJxNeH0QHD5pukPvQliQzlpVV/Mx+ucIZ2hutipdPOgd3/BrKY8Tnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyQRU3Ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyQRU3Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C51F000E9;
	Thu,  2 Jul 2026 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010151;
	bh=abVcqInh6YQTQZPseBtqdiX6y1Kwo4mcvnW+CMJYjQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyQRU3Vep8uLugXNRXXVZFYVnZaOpJ89DFJAuBDdwdTZD8vUfeXChCdLw+8O0fhDS
	 Y1/sOkh/gAmEBOiqYb/xFrEhNPnYzDJ5YmloVkP6wvVStrNglT6if8/0l2UtHtsYTz
	 kwyGFllBl4nCFI4s5Lmh0LJG/CINnOh7IFc7PCG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dominik=20Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 108/129] nfsd: check get_user() return when reading princhashlen
Date: Thu,  2 Jul 2026 18:20:27 +0200
Message-ID: <20260702155114.378926050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Woźniak <stalion@gmail.com>

commit e186fa1c057f5eccb22afb1e83e34c0627085868 upstream.

In __cld_pipe_inprogress_downcall(), the get_user() that reads
princhashlen from the userspace cld_msg_v2 buffer does not check its
return value. A failing copy leaves princhashlen with uninitialised
stack contents, which are then used to drive memdup_user() and stored
as princhash.len on the resulting reclaim record. The other get_user()
calls in this function all check the return; only this one is missed,
which is most likely a copy-paste oversight from when v2 upcalls were
introduced.

Mirror the existing pattern used a few lines above for namelen.
namecopy is declared with __free(kfree) so the early return cleans up
the already-allocated buffer automatically.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Cc: stable@vger.kernel.org
Signed-off-by: Dominik Woźniak <stalion@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -815,7 +815,8 @@ __cld_pipe_inprogress_downcall(const str
 			if (IS_ERR(name.data))
 				return PTR_ERR(name.data);
 			name.len = namelen;
-			get_user(princhashlen, &ci->cc_princhash.cp_len);
+			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
+				return -EFAULT;
 			if (princhashlen > 0) {
 				princhash.data = memdup_user(
 						&ci->cc_princhash.cp_data,


