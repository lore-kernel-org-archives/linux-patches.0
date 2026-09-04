Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCA83815E1;
	Fri,  4 Sep 2026 05:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500059; cv=none; b=Ddiat/Ce8Q3xwLN9oenooSvxR1ixI4be7TObvW3oxvCYKYK86c11JTRD9ZEQcMFUWb88zl+fF+oqtkH8z5vPKZZkHxxPDbODnn7BafTE4yGnxnwHGmYI7jZd8VIk3NjPld5of01zMzBxO3BA22zvqj6gXWj/5IgyadMq2CvuoLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500059; c=relaxed/simple;
	bh=dUwBo5TJZK8x7RSPVHuseEcNB1xaoz+0e/dB7LE+uK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNG1MJiFl8Z58qE1lTkOjVvm5XLqxzRs4VB+zi2W+N0bhC2SK0Iomvw5s4hyhSxd6Z6FAAOtvh5D1zSGrzsVXjpKrp7jg1gpFUCaXNmE7KkdJ5JyjF26wPJL+jAlhkDeAJd+2LskxtobphTY1IRfU4uhVT+lAjPtu21c7Ho+bk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpcvB0z3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpcvB0z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E311F00A3D;
	Fri,  4 Sep 2026 05:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500058;
	bh=m+IRfMEy1hU/SnuzLY4RZhEroyY8FG6jkvhQaiMXohE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpcvB0z3d/hQ0Fn8x/GU2WTLRVhAczcSw2WwY7Mclxv0b0Vh9zcxaxAwLlElGqqRb
	 YKfzcavzufSvx6fVxVEOy7aXu0xbW8iCHAcIqcw98CCoWeBHvgU14VnKR3txvoV3sr
	 vrnqlWVcpIOMsn93hhAAuTCDjBlzqrzuVC55skNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.2 593/713] ipmi:msghandler: Cancel work cleanly on an error
Date: Fri,  4 Sep 2026 06:59:21 +0200
Message-ID: <20260904045817.116263905@linuxfoundation.org>
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


