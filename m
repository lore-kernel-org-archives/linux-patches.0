Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA152BEFF5;
	Tue, 21 Jul 2026 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667205; cv=none; b=eUrAgAh8D9/mK1kW4NNgeGbn9ECyyZ82odcKZehm6jZjYZMMJ7bfR/cZb97t0O2UypJf25BTYQ9P1dixCSHWK7b3wkBL561IwxXSRXBF7z18zRZdT96AoMdl3xXchwnbaY6Tt5XeorlyAwDajWrJ/COtb7kBhfMy4dl/0MqngKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667205; c=relaxed/simple;
	bh=8idR1m3zbdJY8DR89IJNwiJC/6tLuKAt3j0GTWHJ9XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQxZpAe1rypBGUD7BkzEENwvNVDrp6VJDxcH92JmkK8J6C8Qs8u5LO/5xOmbqMuv1i2jtAbyDLlONkt2OICotsOYtqGI0LyPFAHsBg9Sj20wAyr/Art+vVjDp+Qy1iaxILt5gP235zEcUDAuzdZODg1pZ8w6kKlIuZV/6mpFeRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z78mcLl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z78mcLl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D771F000E9;
	Tue, 21 Jul 2026 20:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667204;
	bh=4vyb/6/rBwh29LY1vhZdDDC3PtlDwWE7FeFLaX+sP3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z78mcLl7Y110L6ZuxxYMlW2daCAvxqu1PrbmntFEE3iKIdo4YmaxMj8XjVQcmgcop
	 Fs7QYVIRgdtpKQ8duAIIPAB2JQ1Ip8SHKlNWwTPA2MuJRwHGmTBOJnalr96EPHYdV1
	 teH5Kqgas28mVUAOmBGPmF6xlESS3b8aGq533cN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0966/1266] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152503.446657107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -139,7 +139,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


