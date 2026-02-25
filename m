Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095492741C9;
	Wed, 25 Feb 2026 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983608; cv=none; b=oKHdEiaF9B5mzt84NDRyMaQuJ3fyfEhjP1a9h4UNGHcpM+2U6IdihrITjeCCiIJ6px0vvbqulgj3e0OijuLxM77otCqN1J4dzGFU9h2LphRCRNLA4el0F3YM/peUUQlXceaz41uaRVB+nZO4xj3mxYLEyxSFW1Ozoh8v7QB26pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983608; c=relaxed/simple;
	bh=P747ClMhdzPabwDoQA+SdXZisGkzxVOpqGgn6cO2vn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxPLZlpju0sy9K4c9DMXy+ugwrvwZSmymv437fyZdM/wbExqIzITufXurHwR1boHeubGsSNRZLCBcl75JRIrMcrL+ucFLXuhQfJSpgskC30WBK4swLOWP9hnDuu4o/5oiwTKX55fXTCDyyAwOCCeWd38dAS1fE5TCzoveZBnTQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OumA6HOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OumA6HOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8849C116D0;
	Wed, 25 Feb 2026 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983607;
	bh=P747ClMhdzPabwDoQA+SdXZisGkzxVOpqGgn6cO2vn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OumA6HOk/MXw/uzdMrUfyK8VK58+rrCHZLSflVC9CdKeytfuJlQlrc2GM+BeSFUaZ
	 ZkYZMoaX1NxEvkdWpfWREOQZt3q4nxO6oRMPglSPDg9s0gDsKiwmMOXEMa6GP3JOZU
	 F0NbKmswJnzWuQREMt2P8iEPAHifzET/0C66LFx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>,
	Tyler Hicks <code@tyhicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 695/781] apparmor: return -ENOMEM in unpack_perms_table upon alloc failure
Date: Tue, 24 Feb 2026 17:23:24 -0800
Message-ID: <20260225012416.803073605@linuxfoundation.org>
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

[ Upstream commit 74b7105e53e80a4072bd3e1a50be7aa15e3f0a01 ]

In policy_unpack.c:unpack_perms_table, the perms struct is allocated via
kcalloc, with the position being reset if the allocation fails. However,
the error path results in -EPROTO being retured instead of -ENOMEM. Fix
this to return the correct error code.

Reported-by: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Fixes: fd1b2b95a2117 ("apparmor: add the ability for policy to specify a permission table")
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 7523971e37d9c..dd602bd5fca99 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -687,8 +687,10 @@ static ssize_t unpack_perms_table(struct aa_ext *e, struct aa_perms **perms)
 		if (!aa_unpack_array(e, NULL, &size))
 			goto fail_reset;
 		*perms = kcalloc(size, sizeof(struct aa_perms), GFP_KERNEL);
-		if (!*perms)
-			goto fail_reset;
+		if (!*perms) {
+			e->pos = pos;
+			return -ENOMEM;
+		}
 		for (i = 0; i < size; i++) {
 			if (!unpack_perm(e, version, &(*perms)[i]))
 				goto fail;
-- 
2.51.0



