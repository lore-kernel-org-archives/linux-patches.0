Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F7E469855;
	Wed, 23 Sep 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174784; cv=none; b=aVgTwlSKiA16/oTJJ/FXce+/o6Eq0z4PS6UOXFRp3wuwmtGT5k5YZ6C8YNdd2r0ExQiXotBaGJx8j1Hr1h9AewHVcVzlBca8XjDW5iwwongAVeJnKRcopUu8HaNORP06IQZuMFpCgixzWS1CG1nOgMS+LKjuLYb4dAc9wRYMFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174784; c=relaxed/simple;
	bh=LX8XtziXVS1zvt9i2h8LLnUzXlVUQ+mbRaxPO98Z3uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnk82worZUQQ2PfJO4MsvDuhQQimjVaUsTR+3xqsqfCkkkhMljeeRuMJel6cu4LgYLvx6fDPL1uPZZYsd5soFWgl4oigiEU3KGE4LtLSfJxSoC2+S4IpJnHCcRANYbWtBGSCxOA8VGS9byh37RO3RoCpcNcKit24yFb5zGApajw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUnGiHBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUnGiHBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3381F000FF;
	Wed, 23 Sep 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174783;
	bh=JlSD+8EzXg4nnUGHX8u88rrQcy4BdQiABgMKjJxH8dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUnGiHBoWrLbgX26HnlBHPwCXGV2OT5xjfAUpGDct5Tv6Qpo0zMvpoSKfAUdLmn3D
	 +liOkuC0W4Wa5IGXpr2/n3KGWW86gYtUGg1Tx4bR0Pgj2icp/wCfcL9ls18Zy1zIG8
	 rfe1aN3DfDi5plOn6bZcvSyxnefnmbdIBsGf+dAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 224/398] openvswitch: avoid reallocating confirmed conntrack labels
Date: Wed, 23 Sep 2026 16:04:58 +0200
Message-ID: <20260923140649.227011139@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 3f118c8217c109fd13ca61caa301d72c483897ef upstream.

ovs_ct_get_conn_labels() adds the labels extension when a conntrack
entry does not have one.  Confirmed conntracks can be read locklessly,
so adding an extension may reallocate and free the extension block
while another CPU accesses it.

Only add the extension for unconfirmed conntracks.  A confirmed
conntrack without labels now fails the caller's label operation instead
of reallocating its extension storage.

Fixes: c2ac66735870 ("openvswitch: Allow matching on conntrack label")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/372fbb062b40ae6723684f55484be86ff0064f8e.1789218015.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -366,7 +366,7 @@ static struct nf_conn_labels *ovs_ct_get
 	struct nf_conn_labels *cl;
 
 	cl = nf_ct_labels_find(ct);
-	if (!cl) {
+	if (!cl && !nf_ct_is_confirmed(ct)) {
 		nf_ct_labels_ext_add(ct);
 		cl = nf_ct_labels_find(ct);
 	}


