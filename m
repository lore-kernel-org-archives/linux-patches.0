Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E43F2459F8;
	Fri, 31 Oct 2025 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919532; cv=none; b=W5Vymr/OH4PUydVFeyx4dBp6sU2A1RcQk60lOXWstxEv9YhFP/8h8uuceCS9pEfY2UD6mCjY0qD1i9HBVwjJw1FYYmjHTgT5JwMNuC5aFYNv4BPwV5a1Jm6OWOO+TRn8ZucJ+UCVeAeRqyRLILIBRVH7LTZYOe1pGX+7t/mugj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919532; c=relaxed/simple;
	bh=xxRoeE8YJSVVBrwa0V9+t6L1gDqt2nNklx0OY1/uIxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RarOJDfvbo22MvBhGCpOL5xpGkhBPbIulRZZcx3OCsa44y07OZ0g27hRYjx5DzCOWZeA7Tb7sIlANu5yqSQUkhvTo+uNsn7adLH7C3g1xRLUq6Jd8YXuG3KKWEr2DSiU3Keq9OezUZaoWJkapdTKCuin3+15i08ljSXkiJg6KvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiDz0VJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiDz0VJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4658C4CEFB;
	Fri, 31 Oct 2025 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919532;
	bh=xxRoeE8YJSVVBrwa0V9+t6L1gDqt2nNklx0OY1/uIxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiDz0VJY+x2ZXBGuJZn2QnGpI7BV+L90S0FqPfvutBdzp74n3evQ0jIO9mp2yUNGH
	 BF7W6N12kLSwRH2PlFrjVn5f91vKXgo6hsEp82HaLol0oi/KzNIpmwNNmgp5kOtlKE
	 sOMp/ebi5DrpqJ/bFQGnGpgVjdLXfYeWz7X/WB+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 10/35] audit: record fanotify event regardless of presence of rules
Date: Fri, 31 Oct 2025 15:01:18 +0100
Message-ID: <20251031140043.804680603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



