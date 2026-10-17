Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E85385D7B;
	Sat, 17 Oct 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259519; cv=none; b=f+0WdzpmpYNdv7PHwbq4HVp3ni9VSzFbE5FnMW8x18KXvXxQ8lKYWBwGCWY4UtqpFbzykzrGoBg+fJpq6ti8tXwcHhXoTfs26ST0pR0MJk2DW5kOuec9DUpHEV2ZJCmRPAEdhtLaSLQUoXhWl6Fmu5tlHxzgi9w7HRP7yqJPP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259519; c=relaxed/simple;
	bh=2QGz0Mjy0X6WqdRXYxtZAycRm6e+kXj3Ae4aLC/LIa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUE4JUrhwov3UVRe1PUxIlAftmrCuVdvhrGO9JrWdpVbXoE/kgHRXQ/8+8+Ol/kLdzYpe5KZ2pHpd3Dxz+jumSfMsMNC9m8zZpzZEYDBIkUhsmGho5m27lL1mcoXdsiS+mLm2hGjGdgGMMEXRzzHaT9RzUqIqUo9NzjUgtzSfQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhZv7mjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhZv7mjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F671F000C4;
	Sat, 17 Oct 2026 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259518;
	bh=u2VlUnAaNuybBQqPcHLSbXVWDQHUUAnzBE+bB2bhMew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhZv7mjrmQu4sNvHGyZa4pxk66xH7DzeSsniMr+PvTXiplXKr3lj3Y2dNNjXsaZJW
	 SXWr7mOV3/8S0HDmMQvtMtaGp0AcWxVNzC1Y3y/qS9Pr5mBp9qLtLEWP1qf6JiuDEs
	 F/J89qoE7qwwIbDepnJm+zGMr89XjxGtBdvucV8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1242/1674] selinux: reject a permission value exceeding the class permission count
Date: Sat, 17 Oct 2026 17:58:34 +0200
Message-ID: <20261017160503.015610352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit d14b5d0e97fccd27974fedc03b903408872907fd ]

perm_read() bounds a permission value by SEL_VEC_MAX but never by the
nprim of the owning class or common, which is taken verbatim from the
policy image.  security_get_permissions() then writes perms[value - 1]
into an nprim-sized kcalloc() array, so a class declaring fewer
permissions than its largest permission value drives an out-of-bounds
heap write.  The top-level symbol tables are validated this way; the
nested per-class permission table is not.

Reject a permission whose value exceeds nprim, which is already set when
perm_read() runs.  Well-formed policies are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: tweak comment for line length]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/policydb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 81e910aaf22a3..9e55c2c532435 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1127,6 +1127,10 @@ static int perm_read(struct policydb *p, struct symtab *s, void *fp)
 
 	len = le32_to_cpu(buf[0]);
 	perdatum->value = le32_to_cpu(buf[1]);
+	rc = -EINVAL;
+	/* indexes an nprim-sized array in security_get_permissions() */
+	if (perdatum->value > s->nprim)
+		goto bad;
 
 	rc = str_read(&key, GFP_KERNEL, fp, len);
 	if (rc)
-- 
2.53.0



