Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A61E1A05;
	Mon, 23 Jun 2025 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715050; cv=none; b=dwLB+/roap44BmLp3lP2tq8kCE5RisM6VASrzewAEa/YnQulEa8DA75vWteqlRm/ICi5cr4iz3PjdN1m+CwmsMAH5ihea0duXdURFNzcUDxwtForHFabl7aj+fQR7YuwONbOBNERWy7ueubAsayUvCO2kRF6AXMJ9VSQK90qPng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715050; c=relaxed/simple;
	bh=JjyjIm9UcLtZ9ET2H0lUfpv+2s2hAGogGvYDhKGFyJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr6NS/w/GmGptt4BUNVyIkPPCW1nvvd+pxlVuUB2PHIwZUXL24khezDwqx3fEPFghwSSQ98NuL/tOnWTZIy/iR/36B6Y/LxTHuXyonb9OgRGwpjmL4OYJc/64rY4ODlzxF2HSsgf1GrslskL841L0BTC8QcVbCgtcP9/rCGtgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnYhMjvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnYhMjvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC3DC4CEEA;
	Mon, 23 Jun 2025 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715050;
	bh=JjyjIm9UcLtZ9ET2H0lUfpv+2s2hAGogGvYDhKGFyJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnYhMjvnqX7WktD4SPrD0nPu9Y6NCb20/6f2RNf+E22TcyEr7x/gT4hKmFBRXIgV6
	 hOhGECm/sVoyLVBw9NqpgcXC5rVld8lKCEreQrK7yAe5gTOo/2C7PU7EL+BQC209eN
	 eZztfm3G7oxgBwhyS/VZAFWeUqcvb5q2ciVcA89s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/355] tipc: use kfree_sensitive() for aead cleanup
Date: Mon, 23 Jun 2025 15:07:30 +0200
Message-ID: <20250623130634.237863118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c8ef20fe7274c5766a317f9193b70bed717b6b3d ]

The tipc_aead_free() function currently uses kfree() to release the aead
structure. However, this structure contains sensitive information, such
as key's SALT value, which should be securely erased from memory to
prevent potential leakage.

To enhance security, replace kfree() with kfree_sensitive() when freeing
the aead structure. This change ensures that sensitive data is explicitly
cleared before memory deallocation, aligning with the approach used in
tipc_aead_init() and adhering to best practices for handling confidential
information.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20250523114717.4021518-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 3b26c5a6aaaeb..cc409d55e1576 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -419,7 +419,7 @@ static void tipc_aead_free(struct rcu_head *rp)
 	}
 	free_percpu(aead->tfm_entry);
 	kfree_sensitive(aead->key);
-	kfree(aead);
+	kfree_sensitive(aead);
 }
 
 static int tipc_aead_users(struct tipc_aead __rcu *aead)
-- 
2.39.5



