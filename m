Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AFA2236FB;
	Mon, 10 Mar 2025 17:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626793; cv=none; b=gmiAMOir5BUvCIKx+JLMTYmSjX/TkENnudPkX0A7O0M2ftxkMjaEdzZaEuR3znQXAuMs9kfsF2APaCr34CChgrlmMJCmCD77X5zPkqN2bWlyOdTEp2smki/jUhGnpf6ZtiWPnqCTmpHH3c0YUBlsgxLXjIzM8FOy6Sc9JwRxdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626793; c=relaxed/simple;
	bh=7LzbM3UV+RcA80JnfMG/jGbucYIgaDGxHfhbrQaYN4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C15f5XrEqH8du2a0zJSXLWah2KIM9oWhZg/avrDtFDZFz1VVcni6B1unrTBIZqT0TyW0ELDR7+Y5RyhseCpvoL2X10HFGjkfBHwjRjgk4JAiFdjEMn7azEq8TFkWWTFgS6kREpCOpKwW1SyoOawUYD0DORZDMmjooLqaoXh7Khs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10p/hUdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10p/hUdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F94C4CEE5;
	Mon, 10 Mar 2025 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626793;
	bh=7LzbM3UV+RcA80JnfMG/jGbucYIgaDGxHfhbrQaYN4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10p/hUdTxUlTJRGlHoLbA7YJQEH5SuFcaffI6ukTo3F7l3wPyn+bglX0aYYyo5t8a
	 WIQUNn0jn88TjnL5pvwf23WYVjNUvBt+3AR2DcU8tnH4ExCoWKreN5/KYsjUdgFJYj
	 R2+lfy4y3YDBG0SgVe9pSzHW1k3k1E13KHJVx5lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 115/207] cred: Fix RCU warnings in override/revert_creds
Date: Mon, 10 Mar 2025 18:05:08 +0100
Message-ID: <20250310170452.383376333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit e04918dc594669068f5d59d567d08db531167188 ]

Fix RCU warnings in override_creds and revert_creds by turning
the RCU pointer into a normal pointer using rcu_replace_pointer.

These warnings were previously private to the cred code, but due
to the move into the header file they are now polluting unrelated
subsystems.

Fixes: 49dffdfde462 ("cred: Add a light version of override/revert_creds()")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/r/Z8QGQGW0IaSklKG7@gondor.apana.org.au
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cred.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 382768a9707b5..1e1ec8834e454 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -179,18 +179,12 @@ static inline bool cap_ambient_invariant_ok(const struct cred *cred)
  */
 static inline const struct cred *override_creds_light(const struct cred *override_cred)
 {
-	const struct cred *old = current->cred;
-
-	rcu_assign_pointer(current->cred, override_cred);
-	return old;
+	return rcu_replace_pointer(current->cred, override_cred, 1);
 }
 
 static inline const struct cred *revert_creds_light(const struct cred *revert_cred)
 {
-	const struct cred *override_cred = current->cred;
-
-	rcu_assign_pointer(current->cred, revert_cred);
-	return override_cred;
+	return rcu_replace_pointer(current->cred, revert_cred, 1);
 }
 
 /**
-- 
2.39.5



