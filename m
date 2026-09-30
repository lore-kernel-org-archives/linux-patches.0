Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C465D3DD849;
	Wed, 30 Sep 2026 19:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796248; cv=none; b=Om3S1izJmlfzjiAd3AfaDSMc+D0JFgHCoo2e1+NG5DaA3RXl8NG8npIvrt/GwKUIJBEBV6AIdWmCblgHq4wSNnXHgK5dCVHO5RCOThBnH1vNx0UZdDhVoo4LggHPOYlIhPnEgywIM6lUyyiqWfSDBD24hIT5BRJMWIGXW+qaQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796248; c=relaxed/simple;
	bh=S1uG9ncgEf0x0Z0XpZjBTxAeWTOOKhdINxOlx20s/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH2XCbQB1K+l9oqOMcgbAtrCk6d/KKB++DQanRDilPpdfbJhXa99jdKqZVvzBk7nRHu08OkpZsDlSr3gWIZqNyy9cmasOGMoYXF61hTMjY98LHglEyyXCe4ccmU+YFxgSQuRTZnfOz7Vz11CDdjF/nI3cj+TxHgrnXfjfd98KWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eLB+3Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eLB+3Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC221F000FF;
	Wed, 30 Sep 2026 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796247;
	bh=8qaL3IV9xlsbAWNLIcOrJkXKR9hQQgezg8l/VaxuYFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eLB+3Pmr0+31vTcJjy3aT77DlyD0CSIpCyJJL+m8NIXOKhQjksx3RYJK1vwzda+r
	 0h8pdzbmBeJAwRhHwCxkCGKzVHluKgCQYRnSEsI68COZllIrqkMgOgDffa3+KhoTr2
	 gL1UJzXkV8rHpS3EyL9kjVd2yzoKtvXbQVGUp5o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0844/1193] openvswitch: avoid reallocating confirmed conntrack labels
Date: Wed, 30 Sep 2026 17:25:28 +0200
Message-ID: <20260930152452.991518486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


