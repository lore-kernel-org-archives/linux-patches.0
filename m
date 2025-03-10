Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFC817CA12;
	Mon, 10 Mar 2025 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629192; cv=none; b=DekfVQs48FWaL3iWLZKTnM6y+X8BSYKgkTKJtp3buMltAmY9Nfk1OTFoUke8HHLvKe2Bv5l076inr7Ud9FoKCJTaJ/BsMPtaT6mpIzfo4I6f2lj31qF2D5ZCFiLt32Ie3ASZKopXfUGJwtx49HTdLT//ycvr3lcCT3x2GQSRSN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629192; c=relaxed/simple;
	bh=CJlvlBV1JpmqbjhGuM2+YK0rq6Vcx4W9RIwZG1wigNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXhpQc2/lRN0tLhPq2tWgQV/LeVwK1jAyhhkrrYjMfIcMlyVVxnnJY1MlihtWIvGzX3msAA9pztisbffCFZQDjax72XwiQjENUP2eeQVRSoFPYOAtC1XKLRhdfwTvK1u3rKaMxZaoF0uOkJUji2zHBiqjt0QKL45jCD/LROY2sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrzbNNG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrzbNNG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53293C4CEE5;
	Mon, 10 Mar 2025 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629192;
	bh=CJlvlBV1JpmqbjhGuM2+YK0rq6Vcx4W9RIwZG1wigNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrzbNNG1pdVvEKSWd6CH0OpFWAca8oWKkRUU+8EhTyFzRVPL6pIozU01HRNYzJF8w
	 Pa0Q3tKRVF+5SRcgYPkHdLjIB5iqLJL9GlHZRhG+B1IcrJROaq5QyutPfdbLh4aStb
	 4uH0r6gnQUdkRc5i0QSz+wXC2zAazD05pLeKLjyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/620] safesetid: check size of policy writes
Date: Mon, 10 Mar 2025 18:00:54 +0100
Message-ID: <20250310170553.837098289@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit f09ff307c7299392f1c88f763299e24bc99811c7 ]

syzbot attempts to write a buffer with a large size to a sysfs entry
with writes handled by handle_policy_update(), triggering a warning
in kmalloc.

Check the size specified for write buffers before allocating.

Reported-by: syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eb7a741b3216020043a
Signed-off-by: Leo Stone <leocstone@gmail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/safesetid/securityfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/safesetid/securityfs.c b/security/safesetid/securityfs.c
index 25310468bcddf..8e1ffd70b18ab 100644
--- a/security/safesetid/securityfs.c
+++ b/security/safesetid/securityfs.c
@@ -143,6 +143,9 @@ static ssize_t handle_policy_update(struct file *file,
 	char *buf, *p, *end;
 	int err;
 
+	if (len >= KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	pol = kmalloc(sizeof(struct setid_ruleset), GFP_KERNEL);
 	if (!pol)
 		return -ENOMEM;
-- 
2.39.5



