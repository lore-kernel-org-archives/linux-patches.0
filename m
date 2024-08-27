Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2A1C6F57;
	Tue, 27 Aug 2024 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771799; cv=none; b=vAUFFrs5Nb0ttkCpw8PstjdvoY3MYq2yeWazo1GbhK8dr95LriJPDCj0tX184eur9A5AV7je7O4jNlKVpI8RhtyBWdPvga94zqthNxHYjJHQLQYT5wkU9HovghJnlc9Gs15/UkGT0x3aChSxTQYtc7qeTBOCFeAYNG0f3lZNHRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771799; c=relaxed/simple;
	bh=p+73uSk875wTSOqfZobF7j/dfiXVYbA0HcTbD3GDHso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCvbAkhbcU7uoWf0extn46edvVoXBMwvyEYDlP1mGcTAqIcGX/KPEryy+Q200QaSl885/l4Pod07AkU65NaXqx/uY7aTP9aabCNz7eXd38K9dNwVnATBIrYImVc+YGx8H1PtHEIKfHG7HtekIV4co8Qzk/oAi1gI8g5mSg2G7oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MEbNpbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MEbNpbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4338EC4DE18;
	Tue, 27 Aug 2024 15:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771799;
	bh=p+73uSk875wTSOqfZobF7j/dfiXVYbA0HcTbD3GDHso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MEbNpbngJpV3pQRBcj78goNI6vNzJEX12MtLT1sY/vHhtZtOhfRYfqxRrM9uctrt
	 HZUmAoouW+MmVRC1zr1Dhaq0i8Ir4n+weTIq/zHpt3PP4tWp1THjkmHzW8THJasZbV
	 rUUvOuD/v/qwhVGH0dW9tprkBhznMFJ2WScNyilw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 024/321] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Tue, 27 Aug 2024 16:35:32 +0200
Message-ID: <20240827143839.132940130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -332,12 +332,12 @@ static int avc_add_xperms_decision(struc
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
 


