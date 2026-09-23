Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077A48EC6C;
	Wed, 23 Sep 2026 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173503; cv=none; b=NNTg1YAagL8k5bQ4ZJ4Ew819OqPolUDEeiu3GPBlZCdHz7hjATi1aaHxZT42r/Yl70WL1D1qEaffegBljh456OGdOJ/vuGILyPyJvMkT05BUt7rGbWkDcttGictBDx979ornS9tz/+WTjlWPzMOMc+g+wGbxmujU2j+v8HC6J8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173503; c=relaxed/simple;
	bh=vA7992hEkqEUKr2Dwex9JT7YVgijHrvPntmIp/HTPvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAmrHvRHLjY03U1+G8WU9onOiPB2T4yP8PX8Zakc68Y2NhMwZwaCNTpMRJWQkAJx7lu1N1bFia9RHjAhad6zT4F4o8hBIrTsdol5BNFlr5ug74yGmoa4l8hfOXPwOiftFqY4tELnSQVVL5G4xiBl9Ko3Y2a5VMU/C4FmbeCE6NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rap6JtUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rap6JtUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30771F000FF;
	Wed, 23 Sep 2026 14:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173502;
	bh=BII2ay10m0Rg8dahK+434aIUScBa8juHthid0hgOYx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rap6JtUDFP4UI3rCgnQ/V2oo5Qx0Py9LMOahEjwoJfe5FqHhvM8k7mipAuAg4PmGX
	 FPNSZjcrzN17xdTY3OQgI/V8RvaenhJ1wwXS8eItk6Ii//rPFW10awhH0WpFfIv5xk
	 20grfo4xwJ3KMepxJrU8edjlH3KIcv6UNbnyUtEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 267/438] openvswitch: avoid reallocating confirmed conntrack labels
Date: Wed, 23 Sep 2026 16:04:48 +0200
Message-ID: <20260923140651.688538132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


