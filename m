Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A03413792B;
	Thu, 12 Dec 2024 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022634; cv=none; b=GwpoWmKzkBSY1GvFGSvuZlePdiBHxvkxsJAnOQqBueXfr0VRyMvUVsX30wjppAvGFU2LfyhlYkOhuP1CegzwykFFUdDZoUZl+3RFDbXujK0+GzaSLNlRRvCmEn9JU7JLtG+YZ46efT/9Oulrsg0gQoijT8N18Vunu+dtKZ+AtL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022634; c=relaxed/simple;
	bh=fgf4LDeHI0CLEmkkRbSmnniiJuoxfd/Vr2jdszO/ewU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLid1X5tojoTq+1iFOZXgCjTAU7bhUDaf6Ix4ol424IZ+O1FnVeMbgAwKhDOnd9Fr5gGRlJQD6CN/PqlGeFD4p09h+anssntYOw0ZfTeAxzHXYbsbcxCi2ePqCtai4ZaGxgszdzjdsaep1sW4TfeJCqFBvtEhzbS85Ug3FaScGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGNMzCxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGNMzCxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8335BC4CECE;
	Thu, 12 Dec 2024 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022634;
	bh=fgf4LDeHI0CLEmkkRbSmnniiJuoxfd/Vr2jdszO/ewU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGNMzCxTCQwxYRycKxvWJC0tIawac4z5dIiIfqZajqg82X2TJg0yHsAIGZ6hkHNkn
	 xNOKox9Z54TyErxzPRBBiKJ2TMO0EWShehry2I+U05tyk37UscGhh+cJ3nD5X1Xzq0
	 8cwKkqm2SbjzhDXltfnsajsJZioFEQ+WvENV74pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/565] apparmor: fix Do simple duplicate message elimination
Date: Thu, 12 Dec 2024 15:58:09 +0100
Message-ID: <20241212144323.086811278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: chao liu <liuzgyid@outlook.com>

[ Upstream commit 9b897132424fe76bf6c61f22f9cf12af7f1d1e6a ]

Multiple profiles shared 'ent->caps', so some logs missed.

Fixes: 0ed3b28ab8bf ("AppArmor: mediation of non file objects")
Signed-off-by: chao liu <liuzgyid@outlook.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/capability.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
index deccea8654ad8..1b13fd89d5a9f 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -94,6 +94,8 @@ static int audit_caps(struct common_audit_data *sa, struct aa_profile *profile,
 		return error;
 	} else {
 		aa_put_profile(ent->profile);
+		if (profile != ent->profile)
+			cap_clear(ent->caps);
 		ent->profile = aa_get_profile(profile);
 		cap_raise(ent->caps, cap);
 	}
-- 
2.43.0



