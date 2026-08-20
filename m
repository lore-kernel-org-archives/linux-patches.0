Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27B6377A82;
	Thu, 20 Aug 2026 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243989; cv=none; b=bVNPtVOdOj6OtSnHdsGjUiSz/1pX/DAiBMu2tYuk4Wajenmb+hGZWUl+eHw0c9qCyIsy7EvKcLRMa/1Yk9ySl24f/jK2Z7rGheR/Q/Uh7xsXXtcu7rIMB/uUdZVlQegnGGe7rJxdJkk5MeS4b2VJmrl7DqUePIx363sdr6nfTAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243989; c=relaxed/simple;
	bh=tVng0EiQnZcWYu7D5aBgFh6psLMmxPrxT9lz5vciHG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZvoql/FtH/Y6SFyva4WfYIirEOkPSXNEQDvHMn1VLSGR2gcAS38GYd1NKZ76BJwYI2vk+jUksKwcI7HuiKUBcwTBoi+B5NsnwDbHlZRKdytwno667XY4GP6hn10QPnTrhSKG3s/t3mqtZIlpMNzAT0TSQvAZgsJB4d2qwLlO94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zytolUCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zytolUCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BD41F000E9;
	Thu, 20 Aug 2026 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243988;
	bh=bBuiPw0SIOCAQkXzyBmYZWKu48lvIFxq+kM+Z+KSRm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zytolUCgiLjGtpjPU/H9XHaCsRlgvp6zS0POTJDQQrOZTV6ymCjBmxrqnABgeJP10
	 D4NkYiyCPPCTWca/R/kFCcLyF+ii7phgtwUYEF3TzUrKnh4PTJaBgt6nljGqtULHNA
	 bsuN7xF64L1R/fXY4kqznRqtg1QqAickjqbL2750=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 006/235] selinux: do not cancel a policy conversion that never started
Date: Thu, 20 Aug 2026 16:54:02 +0200
Message-ID: <20260820145216.634249660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit e5c0235a3c4e9eb047a16cd02323fe4ecf2f570e upstream.

sel_write_load() calls selinux_policy_cancel() when sel_make_policy_nodes()
fails, and that helper dereferences the outgoing policy to cancel its
sidtab conversion. On the first policy load there is no outgoing policy:
security_load_policy() returns early for that case, before it converts
anything, and state->policy is still NULL. A first load that fails while
building the selinuxfs tree therefore takes a NULL dereference in
selinux_policy_cancel(), reached from a write(2) to /sys/fs/selinux/load.

Skip the cancel when there is no old policy, mirroring the check
security_load_policy() already makes before it converts.

Cc: stable@vger.kernel.org
Fixes: 02a52c5c8c3b ("selinux: move policy commit after updating selinuxfs")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2194,7 +2194,9 @@ void selinux_policy_cancel(struct selinu
 	oldpolicy = rcu_dereference_protected(state->policy,
 					lockdep_is_held(&state->policy_mutex));
 
-	sidtab_cancel_convert(oldpolicy->sidtab);
+	/* a first load has no outgoing policy and converted nothing */
+	if (oldpolicy)
+		sidtab_cancel_convert(oldpolicy->sidtab);
 	selinux_policy_free(load_state->policy);
 	kfree(load_state->convert_data);
 }


