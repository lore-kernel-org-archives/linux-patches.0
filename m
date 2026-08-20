Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A35C468C16;
	Thu, 20 Aug 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247407; cv=none; b=VaE6HQrvjJ7SNFYAbpl8xGt5F/Phlmo3DJRvKxxEijLOcIdgLobGoalN7rPXBi9kX2wQstPRQMOMP79fjv7bBTBAkcJ1fAcbV9XbZGplzdS/IViX6pwk/+aS8P+zLkVaTbKywYa1UZXzWjbArJSHYNWApUBCrIYksPfVIPJ8qVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247407; c=relaxed/simple;
	bh=1hipg/ZZaRBZ6opgRmaIdQVe76Sua77wbWfDOtw+8Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8qyxXHLXIDbg6Is7R29K2Qwd6scS46xwwTqqPDPI0WmV/3+dawi2mhZF0qAXZXVhintpSUwIQR6yYR2Melv9YmA6Ckt5MUYORols2kwAH4Qp3Jld6azMsA5YDKkMupqixaOXD41sEQ3cjWrmZea/pUfmJXrRAZ5SZDoSK8d8kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPbBa68S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPbBa68S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B751F000E9;
	Thu, 20 Aug 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247406;
	bh=z0wR3hYIeg6L45iwDJulNktYCI9C+JI8k+ONDpK3M9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPbBa68StuIc/WaO8z/dt5jCkNZMMVP9JJthq3hwT9kL5vl13UMe/UhoLfGMDbJkM
	 XRcQtp/HipGaT621e+xAMUD3ew7JjITUMG5Qvfs2ueYaWBDQbRFMfRmDdZOwYbEwio
	 Ms4L90pbk4W0ltBIjmxEAZkfmqz0+gUNTucU8P2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 007/166] selinux: do not cancel a policy conversion that never started
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145211.415403172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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
@@ -2157,7 +2157,9 @@ void selinux_policy_cancel(struct selinu
 	oldpolicy = rcu_dereference_protected(state->policy,
 					lockdep_is_held(&state->policy_mutex));
 
-	sidtab_cancel_convert(oldpolicy->sidtab);
+	/* a first load has no outgoing policy and converted nothing */
+	if (oldpolicy)
+		sidtab_cancel_convert(oldpolicy->sidtab);
 	selinux_policy_free(load_state->policy);
 	kfree(load_state->convert_data);
 }


