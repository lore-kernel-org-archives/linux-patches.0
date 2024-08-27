Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794E1C6F76;
	Tue, 27 Aug 2024 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770986; cv=none; b=NNDsOxhLHljlNcLMaCKRIRcsE0LZiYbbTEXXrce5YPKduLT5R1qv/UYRD5kB1IquYqz62xW1FC8GEDxvAGbu0qJWRgt8tOdElPY7t0DJSxW9sHgCi2glkyizdLYLyRQa7jqixkgKmi6Z9rX/Kygju8c0lJVzwdeEz6UZPTUyURc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770986; c=relaxed/simple;
	bh=X7lXt9ScBCiULqRuhXhlxrz8CSxTlgYU2G2ivpzJXPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3i3mitUELmtNnPpU2FXsRRsiRllgsXfysA52Sts8LoUo1RS7pfw3TcomGXiOB0WK3QVZLj+vj1sAqyxM/ZIqz6ZQDfYRxbogmJZqqmZXYBdvxSe5e6obZBgn5O0kv6VejKr3kiz1bFYvVN6LnMnYiGPKotwoUSF9YhNxPtqgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRcsynw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRcsynw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EBDC6104E;
	Tue, 27 Aug 2024 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770985;
	bh=X7lXt9ScBCiULqRuhXhlxrz8CSxTlgYU2G2ivpzJXPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRcsynw2AU/gMKdvMdj774YMwyNpwpYroHs91fiHT9qGfue3afnZYBlT3r4DN5Orc
	 RZgwZEvVQf+AUGlcYqTDPncGx1pPZi0vFiOwWf+Epq5I0igPU1RnU+t1y+ZGKInUQ+
	 PRYxHispLz7IHNBCCRWzVDBpBEneyfrUqrIhFg1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.10 052/273] selinux: add the processing of the failure of avc_add_xperms_decision()
Date: Tue, 27 Aug 2024 16:36:16 +0200
Message-ID: <20240827143835.379308444@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 6dd1e4c045afa6a4ba5d46f044c83bd357c593c2 upstream.

When avc_add_xperms_decision() fails, the information recorded by the new
avc node is incomplete. In this case, the new avc node should be released
instead of replacing the old avc node.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -907,7 +907,11 @@ static int avc_update_node(u32 event, u3
 		node->ae.avd.auditdeny &= ~perms;
 		break;
 	case AVC_CALLBACK_ADD_XPERMS:
-		avc_add_xperms_decision(node, xpd);
+		rc = avc_add_xperms_decision(node, xpd);
+		if (rc) {
+			avc_node_kill(node);
+			goto out_unlock;
+		}
 		break;
 	}
 	avc_node_replace(node, orig);


