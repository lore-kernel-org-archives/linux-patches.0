Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1203ADBB4;
	Wed, 23 Sep 2026 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173868; cv=none; b=qF/6wAekhyR9WxIuFI+mEI01pMdijbpoqLMxReX32n2KXwEX8hbygYkDSrOYC/Co+OFHSdYc0niJf2atuj1SZARyUnrVKba6y5enBW16r0dnXeUOWMro3oImKoO0RuKfXKfC9xNGnYYcmNdn0eREAjGmn7O45IAYBz0+9dkZkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173868; c=relaxed/simple;
	bh=phbe6DSKQ9F+NvcArNz6FmhsJ/3PFE0pdCqRQjnO7y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upUfFH09+De8aDBiLUqNTIyG0MAJVScURYP0IhpLrpkl/GWhtuP5PW05r3Kew5Y2uuK2KCEJE6NO+c0lHB3Ot+7u9G1Hg6BllIDjYPUTDFo1ex7ODMEu9FdVXLIvjt6Qc0hUsy/ttX+yVXiHZHOQ69/DGgL4HrZzMb29jigR+0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfzxbuYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfzxbuYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57E61F000FF;
	Wed, 23 Sep 2026 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173867;
	bh=q5yDlXNlAyqvVRY34kBepn/grjBL58W98YoDQVXQVxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfzxbuYnqbYxQcSRilg99piIbKSRgLwCrwulvutFRCy8p/ZP1SnZz1nMEL7k3VjY3
	 auF4o/XPNaYft15r4UcyHMtRzJLqIjOGNhfRCAWfxw3xYDY7deqrIDweofGoElhnuO
	 tvUi6v8XFXVexCD7Z+pZU8N5k19JPmn8xqzrOvfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.2 335/438] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 23 Sep 2026 16:05:56 +0200
Message-ID: <20260923140653.497284853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 8861db305103107199b1426f25fde1fb6d465583 upstream.

avc_has_perm_noaudit() is documented to return a copy of the access
decision in @avd, but its early return for an empty requested permission
set leaves the buffer untouched.  All callers pass an uninitialized
stack variable and afterwards feed it to avc_audit(), and the inode hook
even stores it in the per-task decision cache.

Fill in a deny-all, audit-all decision, similar to avd_init(), so every
caller receives a defined value at no cost on the hot path.

Cc: stable@vger.kernel.org
Fixes: e6f2f381e4015386 ("selinux: replace BUG_ONs with WARN_ONs in avc.c")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -1150,8 +1150,11 @@ inline int avc_has_perm_noaudit(u32 ssid
 	u32 denied;
 	struct avc_node *node;
 
-	if (WARN_ON(!requested))
+	if (WARN_ON(!requested)) {
+		/* Provide a deny-all, audit-all decision to the caller. */
+		*avd = (struct av_decision){ .auditdeny = 0xffffffff };
 		return -EACCES;
+	}
 
 	rcu_read_lock();
 	node = avc_lookup(ssid, tsid, tclass);


