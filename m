Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D33F54B6;
	Thu, 16 Jul 2026 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211578; cv=none; b=tn5eUv6FvLJJV/6qoJYIvIIkmbx5pqfVVpx5BIQZYiiaj/P5uurQJ/RgRKIQ81sZ6RKNggabPtwSLo/9BTH5wtvrVj8dc7jxURqppEBjeK3KjISzSp6T5HUs6SOEAbiUhbj+voJs2c6Lq0jelUXFGLzoSIsD4c1EdOo05uCCeBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211578; c=relaxed/simple;
	bh=E+Yw5ziz/LxYopiJ7hURMFEhF964kEUInqQ1XOj/8dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUf2W5S0VuQlSW2vueGNdnwXNqG8FftJyzUAwlvfm12B7MPcDh20MiXKvVelm7OTMbSVUu3vshZuPSmGomuBzFbkne1CejG+QbRSlXN6mLa2vNP9WBoV/IA6Exn+3mlshkZ5LwL+49HNSN6eV2R0Bh1DEKL/je0+AOJt2LLaYmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q77t6/sx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q77t6/sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D111F00A3A;
	Thu, 16 Jul 2026 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211577;
	bh=ksvinN5DtStTTTQuhUvBgTiQ5A/b+1sNITx+3MX3Akg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q77t6/sxi8TJFSDfAeASsdABJPCy8x3egGAVCiOkwkcbtobhbM3auBDIuOi/SpqIs
	 BkkJdxguhyGiYmJU2pzp4IwcGS31hS1Sq/o7WKqiuEW6gQwYkox5JAcqa0Ca1yJC6b
	 2qaERl5XY9j8BWQW9mjmf7DRzW6f9CKyC4Eston8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 465/480] fuse: re-lock request before returning from fuse_ref_folio()
Date: Thu, 16 Jul 2026 15:33:32 +0200
Message-ID: <20260716133054.882679756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit b5befa80fdbe287a98480effed9564712924add5 upstream.

fuse_ref_folio() unlocks the request but does not re-lock it before
returning. fuse_chan_abort() can end the request and the async end
callback (eg fuse_writepage_free()) can free the args while the
subsequent copy chain logic after fuse_ref_folio() accesses them,
leading to use-after-free issues.

Fix this by locking the request in fuse_ref_folio() before returning.

Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1106,7 +1106,7 @@ static int fuse_ref_folio(struct fuse_co
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


