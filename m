Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9872045B5;
	Tue,  8 Jul 2025 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993140; cv=none; b=mZ0rvvhfudMVXyKbv82r2Pa8L2i0YvGPNhuOVQFXSxPa/dNeqpM/kHJixYES+Ne29n92kLodNA12J2UxwKq7eNjmPi7Uf7OxDhM2hEczLCerXzwXL262A5X5jBho7AnJPrtKl86EW5pC7RhdCrFaAElF/3apQ0P+k1P6VWLrmic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993140; c=relaxed/simple;
	bh=JqmoquB/39mT21yXaISIyPLGx7kYODkcxkpfFByy+Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+c2v8W6KSygkCdWavCDxVxYcsnaaYfgTnV4KzHzx25C1vzWd3wmc4YCW96qPZGs6E3yihHFX/FOJJ7oHXRwFOO0OiMm/FP17BdDKzmKcbDRwfygwzV8UoM/hNzR6ppxLebww+ZErEmEVVQZZp+7dqXs2241/nYkoaAIOKBlCO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmfsRNjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmfsRNjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02688C4CEF0;
	Tue,  8 Jul 2025 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993140;
	bh=JqmoquB/39mT21yXaISIyPLGx7kYODkcxkpfFByy+Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmfsRNjyxmXO+tl15dDHwDctpi91Hs6sXhWBNJB4nc0zxoBAOsWiJeoi7FPsOyDX2
	 CjmCILsit+MJWuYQa+XvDwjDA+Pcppj1wqzd2uIMvyspYEdJ33iUbgSIXr1XOIwrcy
	 zPbfOXNhYJJNNfTYzfJHUUGBZeBzbQZdZKl1yfqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guido Trentalancia <guido@trentalancia.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/232] selinux: change security_compute_sid to return the ssid or tsid on match
Date: Tue,  8 Jul 2025 18:22:37 +0200
Message-ID: <20250708162245.649428809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit fde46f60f6c5138ee422087addbc5bf5b4968bf1 ]

If the end result of a security_compute_sid() computation matches the
ssid or tsid, return that SID rather than looking it up again. This
avoids the problem of multiple initial SIDs that map to the same
context.

Cc: stable@vger.kernel.org
Reported-by: Guido Trentalancia <guido@trentalancia.com>
Fixes: ae254858ce07 ("selinux: introduce an initial SID for early boot processes")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Guido Trentalancia <guido@trentalancia.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/services.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 88850405ded92..f36332e64c4d1 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1884,11 +1884,17 @@ static int security_compute_sid(u32 ssid,
 			goto out_unlock;
 	}
 	/* Obtain the sid for the context. */
-	rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
-	if (rc == -ESTALE) {
-		rcu_read_unlock();
-		context_destroy(&newcontext);
-		goto retry;
+	if (context_cmp(scontext, &newcontext))
+		*out_sid = ssid;
+	else if (context_cmp(tcontext, &newcontext))
+		*out_sid = tsid;
+	else {
+		rc = sidtab_context_to_sid(sidtab, &newcontext, out_sid);
+		if (rc == -ESTALE) {
+			rcu_read_unlock();
+			context_destroy(&newcontext);
+			goto retry;
+		}
 	}
 out_unlock:
 	rcu_read_unlock();
-- 
2.39.5



