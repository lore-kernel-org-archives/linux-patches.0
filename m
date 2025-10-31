Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CDC21FF25;
	Fri, 31 Oct 2025 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919412; cv=none; b=jcTv37JxIn5rxI2h/l5Ascg6jcLnhQwRsjCGb3K6VWdHxLh00wk67LbLK5pKueHIuN2+9j9k8dleaY4FemUk9BLF4wYr8inajfLfFR+/djwtYUmVNGJe9IZPym0obVukAD8ZcgLvsTKWm9uO0gLb6zmHl3AFdklW1G4iop9zj+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919412; c=relaxed/simple;
	bh=Bb/a+fmVqlWfkX4lzAVc5+c45RObKvifNukXdgZfEN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqU+wf424oVHRVEhA5EG6tW1V1nUZ3qtUC2BrHPIEEZwYp1V7jxLZEsr5Edz6bNudO7wQ1HmT+Infitv8IAaGln2yrxufnXxP1ycTVEHN8LTz/uKf4gcsHwUKInjZt68uq+rFXMN2Aw/VV3y3StEj16DOLtzU1o1KFOuVnXNsMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ucbpbd+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ucbpbd+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA37C4CEE7;
	Fri, 31 Oct 2025 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919412;
	bh=Bb/a+fmVqlWfkX4lzAVc5+c45RObKvifNukXdgZfEN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ucbpbd+9NgJy3oM1iCVCacvO5MVdtOqQK/JKBvwzFmWSrcJA9iNLVPEn1fXmofz7Y
	 aUkEe4g9MZne0cipDq6izrQHEne0odl6Xq8vngfynr0A0SQ7Tk5wENDZsHgBctn+5X
	 9jKLyfvsEr845pyXrH65sK+JfIZKLjP9pTDv3oEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 02/40] audit: record fanotify event regardless of presence of rules
Date: Fri, 31 Oct 2025 15:00:55 +0100
Message-ID: <20251031140044.002039161@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit ce8370e2e62a903e18be7dd0e0be2eee079501e1 ]

When no audit rules are in place, fanotify event results are
unconditionally dropped due to an explicit check for the existence of
any audit rules.  Given this is a report from another security
sub-system, allow it to be recorded regardless of the existence of any
audit rules.

To test, install and run the fapolicyd daemon with default config.  Then
as an unprivileged user, create and run a very simple binary that should
be denied.  Then check for an event with
	ausearch -m FANOTIFY -ts recent

Link: https://issues.redhat.com/browse/RHEL-9065
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a394614ccd0b8..e3f06eba9c6e6 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -527,7 +527,7 @@ static inline void audit_log_kern_module(const char *name)
 
 static inline void audit_fanotify(u32 response, struct fanotify_response_info_audit_rule *friar)
 {
-	if (!audit_dummy_context())
+	if (audit_enabled)
 		__audit_fanotify(response, friar);
 }
 
-- 
2.51.0



