Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351DC182D2;
	Mon,  6 Jan 2025 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178920; cv=none; b=bA4hDx3ktcEmLoTHpmtgO0K+XX23oUQQGiNGk7qhnZM3chOt2jWC1Akc6gDVYmzX/gHefqKM+nC39eO0lbb0nRRpz5ztiGsw5UwXyuYt2oXACVUMFt3kuxzJvt4abkx+GbR9BE24Wt3jlH3Pu7Ma0BLperdUIynEjKawuQIDPso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178920; c=relaxed/simple;
	bh=q+LN5V/CaskauJlHXa1mhSCfiOd3cTidjeg/IWSA2Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3SbPya6CtT44yEPErk9tBZHbH+cIStSQ0VdlrsJp71FgiDZ7m+NGk1rK+lF1NZHRIy1mHXnMPU7jgDSKYiVQK9E3yyIBJ+cp6gst/RNa4CW9/aZLXhdcd6rASuY3Y8PRpcTxbKENYIcqeObNXpR9/AERep/4fcdjeelm++l2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9w8TSgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9w8TSgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC0C4CED2;
	Mon,  6 Jan 2025 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178920;
	bh=q+LN5V/CaskauJlHXa1mhSCfiOd3cTidjeg/IWSA2Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9w8TSgZlgYfoqjR/HjXXO64xRbcjrrUbnRpa2eoFWUXcUebcJmW7ctW4rr95I0Pq
	 KnSOCd6mhUt82pXcfnhisBGU6NjVBesdiKf/XHb0MeE1B2B35kiaKF1KMgnzCz+azX
	 pm40xmy5L2qwUi/wkmMk6+5biAMc4knWcy9p4f28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 105/168] selinux: ignore unknown extended permissions
Date: Mon,  6 Jan 2025 16:16:53 +0100
Message-ID: <20250106151142.426144809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

commit 900f83cf376bdaf798b6f5dcb2eae0c822e908b6 upstream.

When evaluating extended permissions, ignore unknown permissions instead
of calling BUG(). This commit ensures that future permissions can be
added without interfering with older kernels.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -971,7 +971,10 @@ void services_compute_xperms_decision(st
 					xpermd->driver))
 			return;
 	} else {
-		BUG();
+		pr_warn_once(
+			"SELinux: unknown extended permission (%u) will be ignored\n",
+			node->datum.u.xperms->specified);
+		return;
 	}
 
 	if (node->key.specified == AVTAB_XPERMS_ALLOWED) {
@@ -1008,7 +1011,8 @@ void services_compute_xperms_decision(st
 					node->datum.u.xperms->perms.p[i];
 		}
 	} else {
-		BUG();
+		pr_warn_once("SELinux: unknown specified key (%u)\n",
+			     node->key.specified);
 	}
 }
 


