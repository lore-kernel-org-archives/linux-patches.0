Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B6D53E2FE;
	Wed, 23 Sep 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174959; cv=none; b=KVry6zBxcV/kg7i43Ccb+CaXIWSh7OC5b5VdNw9RIP9ChaDfwFzPinhZy6DwiCorvOuqgbMSYLWlAtBuhMhnZdsxr35qtZfDlVLmQwbOzzLd2X6HJbh0MHRRqutbvI51MlXmsOXneaU1TKXszSRwyaC9HVsB21GO2NfVyU4AQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174959; c=relaxed/simple;
	bh=3KsyLTgN9Jt6i9EW3CxMtVo7PoB+57+sEIm0o6SPeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMG/Wz/x/pBDmxphyBUPufKSzmqEDJ3Qj6pdE4xO2AAGjggJmM14rao0KTHQkysZarckyv3xlMpal0jVqQC+CEkmEfyfD9elNkFCQCsGuWu3q1zeDxZFExu2zVPiE4zlLxgdGcl4dWUF55xuIQhxGeeyZVNNNvnwtcdEDBejofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZakZs8Ze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZakZs8Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036D91F000FF;
	Wed, 23 Sep 2026 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174957;
	bh=2W+dZRlmbQ67vnN1yMExwwAbcVaKL4Uj5xz7uV5vPUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZakZs8ZezHWEE9Xjrpw7G6zZwj1I5xNqBHKj24qGcQBZ0mMLaYsE5QM3LxER7pUPy
	 3nZw/LBZC+fs9HduF1UbjmCky/fdogvJfEpYtMGG0/5ntOfdMcF4j+SVOj5T5sc++U
	 Wo3uR1ZiMQ67RtQJg1Z7gkO3/sIqntZUoirayQAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 276/398] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 23 Sep 2026 16:05:50 +0200
Message-ID: <20260923140650.572017685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1149,8 +1149,11 @@ inline int avc_has_perm_noaudit(u32 ssid
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


