Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33E70812;
	Mon,  6 Jan 2025 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177665; cv=none; b=etrZJSgX6+/yITa4uP5jOGUlrT0Rq3C7neutu2ua3C/xIH4dUVS7v9jWXBgt1A+8Gcl095oqIzV6Jf2+drwKIYWpIoyYDjaWkAfTCxUtsFzavn/uX3TaN/UoDpyYMceVX1PhfSbyq5yYmNd0JIEQUd2ohcLSIFYEoaRYl3c8qJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177665; c=relaxed/simple;
	bh=9iGsw4jXY7T90Dj5o2GKRnVGsolkE/O5TSFnKLzDezQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etx07rF0C3/A2S6FrA5tfU6UbUuALZL0zDYBj+f8m70YX+XzPHzjL69/DLxbxjmYS4DGur3bXaM29/je5FUPOMcicQjgARD65rraAuHCjCJg/gX2euIuXZw2Of8MEBVdNnV0fm+1ONn50QUuzoBtit0TzuGcpsbwMHVX3ccMswU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoQsbQBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoQsbQBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B15C4CED2;
	Mon,  6 Jan 2025 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177664;
	bh=9iGsw4jXY7T90Dj5o2GKRnVGsolkE/O5TSFnKLzDezQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoQsbQBI+JBlMz4AFdxys6pEGnKdeQvNCM4CKrSi7AAFMIMwdBAy0nFYqwic5Wheu
	 iayfBfNNExWK1jbqqOzMJQizgwGkRhgC01uRCQShXiQM9xLnzKNxsUOtbW6moXchbd
	 3IbB/0FqOkJMIrlJHuylOCoGw/PJaqBtBgS79qLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 005/156] selinux: ignore unknown extended permissions
Date: Mon,  6 Jan 2025 16:14:51 +0100
Message-ID: <20250106151141.945344395@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -955,7 +955,10 @@ void services_compute_xperms_decision(st
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
@@ -992,7 +995,8 @@ void services_compute_xperms_decision(st
 					node->datum.u.xperms->perms.p[i];
 		}
 	} else {
-		BUG();
+		pr_warn_once("SELinux: unknown specified key (%u)\n",
+			     node->key.specified);
 	}
 }
 


