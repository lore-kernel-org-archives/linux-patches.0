Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8F346EF88;
	Tue, 21 Jul 2026 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665404; cv=none; b=DmGB1FbIo0H9VFyKjg9xpXtc8JFt5JQMqBQRkd6cEqcSuW1ceYk7IjYUVagT+FzoPei9MCq7ASPSYTj8vzP2w/XbhFf6pqE5dxBCIgG/vWfzPIQJwLJPHrh8Zd18MBNRQKIl/ltWwFOyElRWohEcleWn27oFyy1aGAFhJU3dIs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665404; c=relaxed/simple;
	bh=YsA3/0HP9N2Snc+EO7kjYwitnTGugKDLHLhm63vd3vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk36LbYuc0HnY0jxJCFFQH4GAgu9grCBSNMwLWjcbF5UBlemvvJRPlv9WvGFfc21EMjGXQN7PBTqMRzOBsSA7D8QKppV1v04ju6wJ33iXKSeknd16p2EIynte3p2Ozjq1IwltH4n+UVjkFEKaEsAiW1CzEFeBo/T7a9kDY5m4BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtSOrjLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtSOrjLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3D11F000E9;
	Tue, 21 Jul 2026 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665403;
	bh=4MmX85C+gD/2JRhIi08aPnVG7EEO4MkwuurJvxTHFb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtSOrjLeL71AAO9Oq1eVnlvxPopFyFtJtRIoUtsBgVVgXHMCdu2+YnZ0Voh8ldRgr
	 BVPYm20OqrBVUQwuwCc3QHKTTJRgqZKsks8HXu9y4Bb4D4EhQezI5vGuQi6CgnHSQ5
	 l8mXk9k42jxkr00+v5d+JKW5OQi7yIEqkcXMVTco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0274/1266] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Tue, 21 Jul 2026 17:11:51 +0200
Message-ID: <20260721152447.952884684@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 39a31ad9e2a5ed7e9c9c6f711dca96c8c8f5f26b upstream.

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -603,7 +603,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */


