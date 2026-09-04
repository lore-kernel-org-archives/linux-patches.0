Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C020137C106;
	Fri,  4 Sep 2026 05:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501547; cv=none; b=VcwuBfzbyOoqN7+HuWZuLCCVrXHuqxfZRHm6O/R3tPBEMrzn40M8rFLEszetK0mtBq1zXV0pS9qHBmCf/44kaBXY7mvtpZIZDjUvu1cWRDpXr73KuFaE7OKaja44YFvUWHt3GSa0IKHzoqXDcijeXkuSbYKXkitqCVA4bHc9PVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501547; c=relaxed/simple;
	bh=OKdxVJb8bAQZ6wDne1PMY4QoXlN8g6q7zWSRVJt8WG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgqlwOuDYUe9iLCeEjCNZ8rhNRQHNh/OQrhwdtKSAQtiMQHE9jBI2EbMj4qryTXnNGHd2F3zRFztjRatBV1Thwz2KQGGm+bu3eMfYTDPKQ2FmdDV2WLZmksP5SdzR0o2stO+/hDQh1Zj/e+ftR7/lt8EDcirJTry9wzggmsA9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcwLTDM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcwLTDM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279681F00A3D;
	Fri,  4 Sep 2026 05:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501546;
	bh=20viwIBB/Xu/Gge/nZ1+cFc58Bfqvta2ZrwGLHZUjXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcwLTDM1b208TuJoNtE4+Q2DOz7J1RRRhWeHaWU9910vi2Xddogu9W+J8MgCwoqZc
	 T46NiFsRldFve79J55V2J0U71UBWT1pipQGXgnERcVfFG05nPGoYoCEzRNvx0Hf2ck
	 GpXCH8Vv1ilhoPKFNEvQhrw0VvHatQ46o5l+qBYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 449/552] ipmi:msghandler: Cancel work cleanly on an error
Date: Fri,  4 Sep 2026 07:00:06 +0200
Message-ID: <20260904045800.884316578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit ae84a2536577057e97f23f75a202e26d0e86cf01 upstream.

If an error occurs during startup of an IPMI interface, it may have
scheduled work to run.  The work needs to be canceled before the
interface can be freed.

Reported-by: Nilay Shroff <nilay@linux.ibm.com>
Closes: https://sourceforge.net/p/openipmi/mailman/message/59375605/
Fixes: 62cd145453d5 ("ipmi:msghandler: Handle error returns from the SMI sender")
Cc: stable@vger.kernel.org # 7.0
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3766,6 +3766,7 @@ int ipmi_add_smi(struct module         *
 	list_del(&intf->link);
 	mutex_unlock(&ipmi_interfaces_mutex);
 	mutex_unlock(&smi_watchers_mutex);
+	cancel_work_sync(&intf->smi_work);
 	kref_put(&intf->refcount, intf_free);
 
 	return rv;


