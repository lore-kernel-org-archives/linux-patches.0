Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419844C97;
	Sun,  1 Sep 2024 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207623; cv=none; b=laSokHEEYxqLXO3AXA1IX7YBTwNF+xRExrIFslb8PPtdxTTWyBUKq4rPlXhxUsec2Hu2ZABhGw3QwQuqu1XaVcpj4bjk2bLQWZ/zI+f3hIhYCt6xypSE7Cao5iJ7TVXk4ydd0UuPtCb4onUzSe3R1nM7JcXzg8UzqTI5mAZxUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207623; c=relaxed/simple;
	bh=zdM+9az1UdhmHltRb7cj7CPOToPGpumCW4a1Z9ILVWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsWM2jlNQDRiVvKXpjA3L11yY+b3CxA0CU8zzp6nbm28wx0HeF07+Ore9pjl6zAcWpHZ8QNxQdoDmNtHJnys4BSXKFz6I1P1py/GloreZpVEqc1m198r3Yf31J3qIlGkTPmyL7TnGTd8sjTRXlh7j3rWry0WxxVxHngontTrQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEbI2uf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEbI2uf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9CDC4CEC3;
	Sun,  1 Sep 2024 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207622;
	bh=zdM+9az1UdhmHltRb7cj7CPOToPGpumCW4a1Z9ILVWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEbI2uf8eQCYZPNE6lXznPumJsuDZ46L8RC7QDXeZDMBn4a6kQ+VWeuDWy62MXOqY
	 9bfYgLrDZztvgSKCClVkhxYR6dub1DkAqxD0jUfZvEVBRcp4LT014yEXWdhcQf5D3G
	 jytSMFOCRNbZe68CdEotD4PAVAFyU7KRCMuVOOlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.19 09/98] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Sun,  1 Sep 2024 18:15:39 +0200
Message-ID: <20240901160804.037540571@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 379d9af3f3da2da1bbfa67baf1820c72a080d1f1 upstream.

The count increases only when a node is successfully added to
the linked list.

Cc: stable@vger.kernel.org
Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -401,12 +401,12 @@ static int avc_add_xperms_decision(struc
 {
 	struct avc_xperms_decision_node *dest_xpd;
 
-	node->ae.xp_node->xp.len++;
 	dest_xpd = avc_xperms_decision_alloc(src->used);
 	if (!dest_xpd)
 		return -ENOMEM;
 	avc_copy_xperms_decision(&dest_xpd->xpd, src);
 	list_add(&dest_xpd->xpd_list, &node->ae.xp_node->xpd_head);
+	node->ae.xp_node->xp.len++;
 	return 0;
 }
 


