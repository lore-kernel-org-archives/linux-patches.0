Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2BA38E8DD;
	Fri,  4 Sep 2026 05:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499554; cv=none; b=HQkFGIa8z9Gnr3psmcLubDPNS4uCbBTWQC0x/wUlnoIgbPCHpzlgdct0Nnq440fl2xcV/ahNm0T5BukJC0qeMYrjcG9qIRwBvKgb9Ggy5KxcOfW56S/34+RBlBJlGbxaF4BFBQcOr/qmNbCsUfD5A2SUKKzYyQPELcZVVGVDtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499554; c=relaxed/simple;
	bh=LGBC0MqzP+7ZIBtj6vK8i9EAUIUboQlxSf3o85bgsHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNahykE1uC9AEwp7vMd7rxvHFa9cOqHQHCPTBXNt5+lqZMhYbVNqnmFZA0IfpxSQmgfPlvao5HoIAlJDrksA9DlUxsGseaIspllWam8P41/et7Bgp8nA+La7LszNxxs918h/XsrYGjbB01TJ4w0x5iTwxvLKBwDB0UgWifXS2Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksrrBePG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksrrBePG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57801F00A3D;
	Fri,  4 Sep 2026 05:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499553;
	bh=BnGy7Lhi4eu27GhPOY5b23kC1R2ZC+bts97mHruQu8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksrrBePGBlU/gQlvPcddaUSk9zvtUE2/9FDrBsagsfjypF9mwfn4D+/K8mHTS7mAo
	 TsbqZCvHE8bVRqw9+30a8Hdump/pRH1C2JcwhiF+ASlNWeCq6m6C9ZurMAKfalgC9Y
	 D1hSSLmuHJ8nBb77IIYdjbbw35bCN5/3ZRMTuxJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 7.2 459/713] orangefs: skip leading spaces before parsing client debug masks
Date: Fri,  4 Sep 2026 06:57:07 +0200
Message-ID: <20260904045814.115483339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

commit d410cd5303ec59c7cf23dd61423752ce8e9ecb59 upstream.

orangefs_prepare_cdm_array() sizes each client debug keyword buffer
with strcspn(cds_head, " "), but then parses the keyword with %s. The
%s conversion skips leading whitespace, while strcspn() does not.

If a client debug entry starts with a space, the allocation can be sized
for an empty keyword while sscanf() copies the following non-empty token.
This can write past the end of the allocated keyword buffer.

Skip leading spaces before computing the keyword length so the allocation
matches the string parsed by sscanf().

Fixes: f7be4ee07fb7 ("Orangefs: kernel client part 4")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/orangefs-debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -569,6 +569,7 @@ static int orangefs_prepare_cdm_array(ch
 		cds_delimiter = strchr(cds_head, '\n');
 		*cds_delimiter = '\0';
 
+		cds_head = skip_spaces(cds_head);
 		keyword_len = strcspn(cds_head, " ");
 
 		cdm_array[i].keyword = kzalloc(keyword_len + 1, GFP_KERNEL);


