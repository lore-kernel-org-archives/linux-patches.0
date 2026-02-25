Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832D72652B7;
	Wed, 25 Feb 2026 01:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983646; cv=none; b=f4sHB4CM7871bCD3osqxGfvM5kOdEZn26IgaMBRpzKMyWU8slaTZzPQEVSmTLUkCH87SjFkVgH5LNxqMJ+qJxIGyhrze2l20zZR1sX3MXpSferKTTAot9g/A4EuzAdaVzHaYfZ6ixBAwnxXRJ4QIhQYm127QdManPXeJhKrFJMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983646; c=relaxed/simple;
	bh=ZYUq1kakN5qe/Dv5hyA5QBcHw0ELj96sc9WZTb4KYWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHezudbb0/9PUL8vV1gAmEJ/4TEpCI40pUSKpHmi7M9OA+YnovN7SaVJ6bkgrbuC/teiEZyiH923gkV/VvuGt+oD+6JVdRaigObALVxmMRpYY52awyLirlwzbw5WA5Sl/oJWxHV53fmd4vyiV3WknS/meeNCCntMG+L5F4/kURM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NucpDZBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NucpDZBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8C7C116D0;
	Wed, 25 Feb 2026 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983646;
	bh=ZYUq1kakN5qe/Dv5hyA5QBcHw0ELj96sc9WZTb4KYWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NucpDZBxzqe15qC70/Ycq5gdHc1rl+Utaq3XOvV11ZGPF+j7tS5UpJCo31r1PZzy9
	 JjDhcrTd+gRcpG6DJI4J5E90pbcwoeYc+e48wiQDNL1pSAu7KR3q+HYtmN4GAZ5Mar
	 346YUWpzdyYuXSEIxY8H/1fJuLcGBhAa0CvxAnTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 698/781] apparmor: account for in_atomic removal in common_file_perm
Date: Tue, 24 Feb 2026 17:23:27 -0800
Message-ID: <20260225012416.877123295@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 9b829c0aa96e9385b1e9a308d3eb054b95fbeda2 ]

If we are not in an atomic context in common_file_perm, then we don't have
to use the atomic versions, resulting in improved performance outside of
atomic contexts.

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index e59e9bc7250bf..f47d60d8c40a2 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -524,15 +524,14 @@ static int common_file_perm(const char *op, struct file *file, u32 mask)
 {
 	struct aa_label *label;
 	int error = 0;
-	bool needput;
 
 	/* don't reaudit files closed during inheritance */
 	if (unlikely(file->f_path.dentry == aa_null.dentry))
 		return -EACCES;
 
-	label = __begin_current_label_crit_section(&needput);
+	label = begin_current_label_crit_section();
 	error = aa_file_perm(op, current_cred(), label, file, mask, false);
-	__end_current_label_crit_section(label, needput);
+	end_current_label_crit_section(label);
 
 	return error;
 }
-- 
2.51.0



