Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B070329CE7;
	Wed,  2 Oct 2024 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876892; cv=none; b=c4V4v87ZH1Ihp/9KMtJVycHZxdcfgIMLLF6Gbsohh2og3t6oYxqDE9Agkuj1/65hycenZyCU7ZSeJtcaaxOaBcpajZiFDDaLxtVsLlcFMvXetLVHLxkm/MrNXepix8xChmQQ6sLjjZbvwfUBFjdW+pzAiwMoopbOHB8M9UYmoww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876892; c=relaxed/simple;
	bh=Wh7XjSRBXGXPVkhQQWskJ3a3J76AmdBcrUbcQGhlwTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsFYgum0LTUqs/7Gdc2t1rkeBhzZj9+pl6DWiKUGAQTgeqrkcjC8XmgjgpCba+A+/dN3twdnlyVZftadcPpunxqF7vtxbVvERGJtXleSRV25FyWXjwaHc7CzC74MZ/qwagbYlcamying1rVG9L+cIvOKnDuIOVMvd7feTh6KHcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Myrf1JIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Myrf1JIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3809DC4CEC2;
	Wed,  2 Oct 2024 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876892;
	bh=Wh7XjSRBXGXPVkhQQWskJ3a3J76AmdBcrUbcQGhlwTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Myrf1JILCAAGAYcxIXyYFupp2ECTFbs18mu6+YRKkBfnCPqSp3u/9UcY1a8e5SJCb
	 OgGVC3kHb6QSqcRCijsdR5Vy1sUV+O3GUIdwzLdlTlpTHUivu7/qF7MJN9EgPOtDb7
	 XVJnenIwrbOhtPKQu2uZdonFoeCy/QNyme7+MEag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.11 564/695] KEYS: prevent NULL pointer dereference in find_asymmetric_key()
Date: Wed,  2 Oct 2024 14:59:22 +0200
Message-ID: <20241002125845.016977078@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

commit 70fd1966c93bf3bfe3fe6d753eb3d83a76597eef upstream.

In find_asymmetric_key(), if all NULLs are passed in the id_{0,1,2}
arguments, the kernel will first emit WARN but then have an oops
because id_2 gets dereferenced anyway.

Add the missing id_2 check and move WARN_ON() to the final else branch
to avoid duplicate NULL checks.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Cc: stable@vger.kernel.org # v5.17+
Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/asymmetric_type.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -60,17 +60,18 @@ struct key *find_asymmetric_key(struct k
 	char *req, *p;
 	int len;
 
-	WARN_ON(!id_0 && !id_1 && !id_2);
-
 	if (id_0) {
 		lookup = id_0->data;
 		len = id_0->len;
 	} else if (id_1) {
 		lookup = id_1->data;
 		len = id_1->len;
-	} else {
+	} else if (id_2) {
 		lookup = id_2->data;
 		len = id_2->len;
+	} else {
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* Construct an identifier "id:<keyid>". */


