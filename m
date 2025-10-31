Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27BAAD4B;
	Fri, 31 Oct 2025 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919346; cv=none; b=eteawYSUrToeKFVTabdbJRbtuGmzjQFnZQMhTf0z8RpKoVIf1xcEg96EXZfCseXGPR71rlr0gUVf0SubvkdE+ONu7aVSIkKMYokMbj0hd1aGciwLsbxC/i9YOd2aTrMQC8PPEfDYl0tA8IdgGAYCBVm7I5NQNWSdLMWYt8vyl1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919346; c=relaxed/simple;
	bh=UM030BhM0sPajPATCN4W5B+Gz7sCXfNOmyRec8gf2vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iozXDdAzn/mwMao0EWrWY5mtQnomWu+A0AUypsRoadqB81Syh14UnqZYtoJtn+3fJhetgiw6byFSrc4p+sGInjnZQICLq/20JRTbq4L15atVqSOiHj9yO72Gk2KpB6nJ9GXXs44h3khfQSBsiQBUBEVd1cC8++UwjibVm3rNyIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3AhVbCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3AhVbCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359BBC4CEE7;
	Fri, 31 Oct 2025 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919345;
	bh=UM030BhM0sPajPATCN4W5B+Gz7sCXfNOmyRec8gf2vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3AhVbCmYttN0dT7t4VIXe5aZKYTA8GN8iP5RtykL9miYfrSxykkFtowyW6UAS+7/
	 RTfe3JfaJ43r3bbkHD4OLI0qXpM/nfT/h8QSlWZ+7VR28b7Oz9lEodML6jkyagkyia
	 AbpMCqbz/pNio8MdVnlsih7QnTe4WIJZzyQbOoj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Guy Briggs <rgb@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/32] audit: record fanotify event regardless of presence of rules
Date: Fri, 31 Oct 2025 15:00:56 +0100
Message-ID: <20251031140042.450183807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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
index 335e1ba5a2327..7ca75f8873799 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -526,7 +526,7 @@ static inline void audit_log_kern_module(const char *name)
 
 static inline void audit_fanotify(u32 response, struct fanotify_response_info_audit_rule *friar)
 {
-	if (!audit_dummy_context())
+	if (audit_enabled)
 		__audit_fanotify(response, friar);
 }
 
-- 
2.51.0



