Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D42BDC03;
	Wed, 25 Feb 2026 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002765; cv=none; b=YxDxrA3ZgbRZT9aMT9n9U4qZ5brbhRfsk1+rS0xTHqDVuG+wtv5mqjOt0/eo/bXmbeB4GA92RYZ5ij0AIItV5QllkhdOkGh/8B6J4pTBUxyFK9vNt2OVPzEiE9lg83iwQrDP9x0RCByS6pk9ctRrSLPeSO5CCuatff9PTrBXizg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002765; c=relaxed/simple;
	bh=Go5vKHukaJBL20tJxEaUEvwVN7i/7XdkRQiXaVFOIG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV4rC+UXL3LBuhqLIDcEamsi2usq/1qU5OcvdCFvJqcHeziFIoMOXJrhH7Eo4vLxHKwM9b/P11aiLtJHqXSgq4GpnYAAEi9dB1kn59rALHM84L8IgVwE5DRvQ6tN46lc9kE3Bcn4oi9NRu6KT5if1L8RkdfEOFTzKk9jSa9vfcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTZzP5wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTZzP5wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B5BC116D0;
	Wed, 25 Feb 2026 06:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002765;
	bh=Go5vKHukaJBL20tJxEaUEvwVN7i/7XdkRQiXaVFOIG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTZzP5waoy7RfQHhBCf5ultxkDQDygGUy+mPD2otf5cas4Loo4KNU5X4JR0Tr8XZK
	 urKgpQzBtpLZLxW+OnOPflQD3PXX4Oxb56YbJ5ynS8o4FXGZ4zvfrqSmivAtuqutzs
	 yvKibcwcLruLWZVwIe0KVw/yT9EaPPTuHQFXly5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>,
	Tyler Hicks <code@tyhicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 567/641] apparmor: return -ENOMEM in unpack_perms_table upon alloc failure
Date: Tue, 24 Feb 2026 17:24:53 -0800
Message-ID: <20260225012402.260376087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



