Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703C94E36E9;
	Wed, 30 Sep 2026 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783514; cv=none; b=B4UXFphM09XokkyHJYmL7/Rz7sPgZ2fUi7iYZuh48yMD9TkF6QnPm7AadvFDv9O4iuty3CgpTsXshQXVhIkPlmS2SYPrL6JUZlaavt85JFSeePgx8KRv7U++3BBQEFLbQO7nD2KbuYvjgtb6oZKB4kAjoEbwA6xximQZA0nm6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783514; c=relaxed/simple;
	bh=CVSMpeMX9vdmecPpHILrkfuzh69QA46L/UAkHikjT9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCm1T1EdqZLkcpraC2eU6AwnKfh2p4ljeb4NewVhonxjGZrgmyB8jcNbrY9wthYjuapzrj2nUvhNjd8SESu8myRLLFrgrtF3aWxgD9Q55hUm7tRrLUPs4z1jsbLGXjwOuODRwIzkDEkH6zTojf09dAHhRNV8x7IQBrkCyoAs0Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbz2bHcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbz2bHcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAA81F00898;
	Wed, 30 Sep 2026 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783509;
	bh=QCxvt/71sgkZtNylhW5YGdWwEY7P1M/xXnZqnX3MfHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dbz2bHcZVt8lH3R2SCwpFnWOwk06eCkf8W2/5CxOBQ4vpHh6rtOdgDCEEMUhwTwcK
	 mpCFpLKdw1sVyID/64FG3Jzj61VYdrTtQE1xTwV0k71Q500NhbwCoWu6IynEgLbZWR
	 oM6o5PSKwfcWFJLiEHCecLzKVCXpPFAxIBuj7Re4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 424/595] openvswitch: avoid reallocating confirmed conntrack labels
Date: Wed, 30 Sep 2026 17:25:17 +0200
Message-ID: <20260930152356.800083872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,7 +355,7 @@ static struct nf_conn_labels *ovs_ct_get
 	struct nf_conn_labels *cl;
 
 	cl = nf_ct_labels_find(ct);
-	if (!cl) {
+	if (!cl && !nf_ct_is_confirmed(ct)) {
 		nf_ct_labels_ext_add(ct);
 		cl = nf_ct_labels_find(ct);
 	}


