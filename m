Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105237DE9B;
	Thu, 20 Aug 2026 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247816; cv=none; b=T0jT4dkjQcUEU3nkrgWT7IkQwgEZzLcB9KVu2IeR9EjkKBn/LPzp9D9r131MEx9I/hjCn/VZKjnJhZwO/AbG7Fyfns0XYSEI4k7XjUJPmucpZLAto1jD8kn5LT9xjocYKA7gsXYy/9mZJ9ZVZDxurCiqH69xkTX9CpzDT7w2tCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247816; c=relaxed/simple;
	bh=yL3NjzkKLys5/meudnQIwAGJGHGppnzu3v8xoh8wfUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWm3hHAbDQNKkxe4Hp6XxGBsKbDwrS2tK5F2iR/17O12J4avvBkbmwr5294lR2+/CrgqLydwpbpMRSFKfgY8RspKikFHBYxI1zAo3gpSRhW372GJPG2TLVJ6fGNCxIyftNUu/SZwXnhCVw/6q4XRiH1OgqZVMpar7BYx3iKTnCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuwWegx4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuwWegx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEC91F000E9;
	Thu, 20 Aug 2026 17:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247814;
	bh=5WtvwrtFshO0yePEeWvO0TlL5JFkXs828fWJiyvoQhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuwWegx4VXXXgtHpe+UyKkZu1BxE8tzG9/ieucsbFDX3/tPjgE+KYhMmIyFVvYhqA
	 D4T5ZAuwd3x+B7NT8wtOBayTn4lHEpnHcWNuZtNxYNuPxtPHKKUf2seEUAeE3yBb1/
	 gMvgz4qIF6oztkswsmh0Gbe/YDBxel82VTAOpyuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 012/303] selinux: do not cancel a policy conversion that never started
Date: Thu, 20 Aug 2026 16:52:28 +0200
Message-ID: <20260820145253.562751347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2201,7 +2201,9 @@ void selinux_policy_cancel(struct selinu
 	oldpolicy = rcu_dereference_protected(state->policy,
 					lockdep_is_held(&state->policy_mutex));
 
-	sidtab_cancel_convert(oldpolicy->sidtab);
+	/* a first load has no outgoing policy and converted nothing */
+	if (oldpolicy)
+		sidtab_cancel_convert(oldpolicy->sidtab);
 	selinux_policy_free(load_state->policy);
 	kfree(load_state->convert_data);
 }


