Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912E919DF60;
	Thu, 15 Aug 2024 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729354; cv=none; b=ZJID6x64vf4QfB3lIkKh32zbBipzZVRXX8WUcbrXtyzc8p1JrYEqQFKzHyUg8TA0AcRkvARffqwVuKD6Sr/JqScRV8xuDkAzEpfFHvC4iAMlXbJiZsc6Z++0YCjQSzN3SJEm/ZE+a03jQ5d8I6B9+eZJ1tHWUpssLX5gBY31FbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729354; c=relaxed/simple;
	bh=1yatg7eTf6MWbxgc/PDg+UMah8UFuLQWXb2f3Yn5ZqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7l3yH/+Kxq+HGvATNRugXKV+Y+Vg53OI92EQwi4v37tAODgX3jr2rxzoMgemBW55b7pe6CzqLapAAxK6o3VE2+815w7iZiP+8b+jDLtEQM7e07XOnJhx6KcsQ++v7ukpF94cK96M73O96jiBRjMK2VMM392MEfzcJbun20SIz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5wnXa9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5wnXa9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EBEC32786;
	Thu, 15 Aug 2024 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729354;
	bh=1yatg7eTf6MWbxgc/PDg+UMah8UFuLQWXb2f3Yn5ZqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5wnXa9xnNZ50rPABCoUqPdDyLCwseP38Hh9GtgSBKNhKMBsYRqIYI85NycXJ6/4e
	 wpAlW/Gk4O8G6bKmFfmvGpVjEQZEiDW2ZdcPnOCjEWQ4HlQzNIOFAPeVwW0sLfKAF6
	 bcmSZuLOY5sVNUXPFqQkHCvu70UhnoBYs2z3srzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/484] gss_krb5: Fix the error handling path for crypto_sync_skcipher_setkey
Date: Thu, 15 Aug 2024 15:18:50 +0200
Message-ID: <20240815131944.066616106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit a3123341dc358952ce2bf8067fbdfb7eaadf71bb ]

If we fail to call crypto_sync_skcipher_setkey, we should free the
memory allocation for cipher, replace err_return with err_free_cipher
to free the memory of cipher.

Fixes: 4891f2d008e4 ("gss_krb5: import functionality to derive keys into the kernel")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_keys.c b/net/sunrpc/auth_gss/gss_krb5_keys.c
index 726c076950c04..fc4639687c0fd 100644
--- a/net/sunrpc/auth_gss/gss_krb5_keys.c
+++ b/net/sunrpc/auth_gss/gss_krb5_keys.c
@@ -161,7 +161,7 @@ u32 krb5_derive_key(const struct gss_krb5_enctype *gk5e,
 	if (IS_ERR(cipher))
 		goto err_return;
 	if (crypto_sync_skcipher_setkey(cipher, inkey->data, inkey->len))
-		goto err_return;
+		goto err_free_cipher;
 
 	/* allocate and set up buffers */
 
-- 
2.43.0



