Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E750EBFC;
	Wed, 30 Sep 2026 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785984; cv=none; b=PrepfhwYtI2kxZ1KcpbTx4t3PPeq1jZTyTH7qS2K+XQEnZKUHSEMsM54E1XR7NhUD02QCdj4qBhmMxIOEqvN6LZoRWxVW3lWToKrTB0EcTbqDw/l7Oc6SXFDE3d63IvXjU5PGdoC7zvxUFXKRxJLACChGfm0bquhxRm50Jh7b2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785984; c=relaxed/simple;
	bh=Xn7aDLfgg+wEbk5DJIWw6i1pW92j6aIFRu7zWdXPpqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp6NqWvw+EAs7qQsnmD5Ax4UHHfC7Esf8FYARsenCTum+t62aYRMwhOBMrY/wFwDBu99NHxv/LLRls7DqsizuB0eU/+UFft5K5W+kSna2Ch4r/3L92ksML+n7orpmag9qE5it7qkDitIDzHI8cxKGqnrOiiAjT23CwzxAQv42wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbZ23Q2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbZ23Q2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2A21F000FF;
	Wed, 30 Sep 2026 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785982;
	bh=e5rTRs9oLhcy5pT3Y/4vIoWityElN1gNePy0CqBG7xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbZ23Q2JbW0DnLnTLKphqOREahcbDVWCCmiToxxqcXL/jAxwjivTLnpX8Ym/cf5Vt
	 sTn2F8OPn7SdU4qCmKJph6gvOeZpTT27Pubx9GYl82a7hNEiglUDOAfbQmf049jTmd
	 JQOZvFl4dedxSEP5umCETKC6Zl1ujdaoZ7weFr9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 702/982] openvswitch: avoid reallocating confirmed conntrack labels
Date: Wed, 30 Sep 2026 17:23:58 +0200
Message-ID: <20260930152431.836563785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -359,7 +359,7 @@ static struct nf_conn_labels *ovs_ct_get
 	struct nf_conn_labels *cl;
 
 	cl = nf_ct_labels_find(ct);
-	if (!cl) {
+	if (!cl && !nf_ct_is_confirmed(ct)) {
 		nf_ct_labels_ext_add(ct);
 		cl = nf_ct_labels_find(ct);
 	}


