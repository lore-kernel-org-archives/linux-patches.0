Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9701A08A3;
	Tue, 27 Aug 2024 14:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769794; cv=none; b=QevUPRqJNpi5QdXATCmTEG9GkzlfVejqM7c5LJCb0G5b8h+W8r/v82Dac8+tTdmvEfr1Uyo1S30R+x2ueP2Od5Q0mqGjFoWsVolfSMFLpxTaojwoI/dM292WSKus19vgM89kz2VJtzPG1Yp3Ihs/7av86DPZT1WNMQHVMfDUj4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769794; c=relaxed/simple;
	bh=N63PXlKDwiyl73Oq0zaYR5TwZjh/qwkWDIDOnEGHGM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfmEj5ghuEOi1oTsLsPiHB0pm8Vqb/1DigTu0pE6eS1qq8hM2rkgaO3o0ke4tjHkIBgKmZCqKP8sUFFs2ez+8NAfxbg5gYqEgDYvzWYj00LMApChNAs6l/zszQujpSja3NA9srKxlugFYJmFNrjgD1hEZdodlDAceVVqME/vMP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZgKuO1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZgKuO1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA0BC6104E;
	Tue, 27 Aug 2024 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769794;
	bh=N63PXlKDwiyl73Oq0zaYR5TwZjh/qwkWDIDOnEGHGM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZgKuO1yLJ2R9xraCAKNeRIZ5mbURsssrpvfsSz+363X1bNd2rhtuQgmRcEv9SmGn
	 Tx2dGdmFhJmsVVtJWKS2ULD2U0Xhh0i5gD+ANF3bpknF+fwYXFBrpYK+6ZPXRL+Hpe
	 p7vMwqCad6zcshIOYDr4dhh7Txc2vTcHa/9H6cCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 037/341] selinux: fix potential counting error in avc_add_xperms_decision()
Date: Tue, 27 Aug 2024 16:34:28 +0200
Message-ID: <20240827143844.824674511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,12 +330,12 @@ static int avc_add_xperms_decision(struc
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
 


