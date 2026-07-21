Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1837470108;
	Tue, 21 Jul 2026 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660606; cv=none; b=mNpCxbWNqbXaqvbQKx4o4sGTKWGrpOVf3EHfVkFlHjyoqd5K/Dq53EbBOMNRUkdolMZhBVlJV1K8+q+e4O1nJa8WPXNBvR1rUoYxvrfJ4n3trm+R/5gdVe7Q+E41yGArXFzc0AUUQdJkFF/uJIVZ7zX69e4XThnk0j/XPgjQsJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660606; c=relaxed/simple;
	bh=89UNen6ExxibjnOQF+q7ltW3tC8XuWwFoe014mXRBdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muXV8kJz8lSky1E0Dr6GwV6K8viddJT//sk7bf0kInWUyVyObSSPklVTut8out64YyU/OD5Zo7ycmlaQ4Sij6fzYaE+l5CyQa8DR3cKjNfdkZ/Gj5Y5K4yDOeBDan75QSVZ/mk3bOS07RCK2FzcAxD+RO9JcZoFiwpswzw14cX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjdBwMZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjdBwMZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773411F00A3A;
	Tue, 21 Jul 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660603;
	bh=j/gutry7D30ko3pkJ2lAnUCyIqbnjsR74Pa+qmZaapg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjdBwMZcdF7NsHAl2CcJWauPPGldbGC8FeRs1mOiNW1pNjQ2Rs14S+aD+/OqT7P1c
	 RxMATL3UkGBtj5eGmVTQ4BwLEKv8U1kg4TOIcHsiEhm89nYtY5X1cz4w24+c4kuCh0
	 d9rAFvK/RG1x6gGmep6Rocfj8yL3xv+QwoCwSEOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1041/2077] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:11:54 +0200
Message-ID: <20260721152617.366740987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 654fe7505dc6889724d4094fa64f89991afabfc3 ]

aa_label_alloc() allocates a secid before allocating or taking the label
proxy. If the later proxy step fails, the error path only freed the label
memory, leaking any resources initialized by aa_label_init().

Use aa_label_free() on the failure path so partially initialized labels
release their secid and other label resources before the backing memory is
freed.

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 3a721fdf18339f..c6a96355e8d9e6 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -458,7 +458,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



