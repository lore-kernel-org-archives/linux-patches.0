Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82E386C39;
	Tue, 21 Jul 2026 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660614; cv=none; b=Qxb5hGm3FKJ9Xbj6yOiUaVPGVPIDnJsTcJ6thatPIs5xoZfI4OpzRw+B1jA5QX7+egnIAanWbfxhiLRIJI4qiGEbGC1wFid9WyDOrIoQv3HeiNKye5g47ji1+CbmcNOORlsnwpLfu8vVilGvc1zAFLXdfpD0JVtdxHWk2qMWDHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660614; c=relaxed/simple;
	bh=FgtuefYXToTiRmxNc2pcDmOcZwdPoeltDjKnrZtTVIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCDbsN4jXXi7I+OLlJjuiq5490487y2lDXUBgPyxuCT4uIIqrsLQ6BUFA6dJv2n9TZ3TQVny269KCbJfwVr4T8qeafAu/SWQzsMlh9Ks1T5uCXOVR7+W3Cp0/MK6XuQ/X1CMX1HdGz5tCGvT7migvxYFMPasaZPhsO0grAWL8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkzM3LP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkzM3LP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C771F000E9;
	Tue, 21 Jul 2026 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660610;
	bh=qNm496Ov4W8y/L67Wv9ruVJE1vgTL0z4888lYXTkf8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkzM3LP7+jtUGahqGrUvdk7zireiBdsUill+c8b+msOkTCA9Lfgdg1+EqCn4kM69G
	 QaV6770DYV27TkSIfAXeHf+SBaVB8mKTgLPuIKHlXA6hz3xvH7HgrRwDd5LK2AAn1n
	 r9oRfLM5k3Vv2N+kQUJRjbruJE+I4vGUXQoWatOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1044/2077] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:11:57 +0200
Message-ID: <20260721152617.436249958@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 7b42f95813dc9ceb6bda35afcf914630909a19f9 ]

The function aa_replace_profiles was accessing udata->size after calling
aa_put_loaddata(udata), causing a potential UAF.

Fixed this by saving the size to a local variable before dropping the
reference.

Fixes: 5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index e103cce6f4af55..6effddb46994a0 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1375,13 +1375,15 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	ssize_t udata_sz = udata->size;
+
 	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
 	if (error)
 		return error;
-	return udata->size;
+	return udata_sz;
 
 fail_lock:
 	mutex_unlock(&ns->lock);
-- 
2.53.0



