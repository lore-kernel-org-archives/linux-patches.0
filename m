Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B644C62;
	Wed, 21 Feb 2024 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524532; cv=none; b=cV5tK6zWIvVOPrARJ0Ux9x1u+QpiOMZ+mxAwXuKo4rfcg/OgtMYPAUcPOMFIzyaACK2sIGVaPTgsWpfmajm1IAxl2K5w2jaYEEBmwLwP4tLVslwuZUo7QVdJq+MGK4B77Fu0CdzQP+kWcouQJI2ChEf+FCbroYFehTqwSgK5Ouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524532; c=relaxed/simple;
	bh=kqhal68y5e1xglMa69VHlG00r1DVh9+ZcyvS1aMSG14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfIS6fsiRJlwZmU+zcrzLjaV+D8dIKf7u33OwjQ+KeswKmXSbGfLZ7l11XZPZiZtornPvcnM51qsvGOUbGexNQmqlbP4144yau7i5No8ipYv7od1BRi7LMGHmczE6FMEiW+FmYWVWg0JZXtva6IT6VzKpUl8rM6SCpzrajIi2AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQFGiQhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQFGiQhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3524C433C7;
	Wed, 21 Feb 2024 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524532;
	bh=kqhal68y5e1xglMa69VHlG00r1DVh9+ZcyvS1aMSG14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQFGiQhwKlWHqlVcgGvYo+XPw1PMueqHazQhvKoIzF/r+0N7hZCQVD/ztJpLM29dq
	 u73bZvPF+CLFsvaiD4pyQ3EFbkPqD4YxBwsLRAb9A/rbe4rpth0vlLBc90kUgWJyap
	 bDTj/ourPSeyTzKDmnb3SozZOawNpjtfV5ma/I+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/379] net/af_iucv: clean up a try_then_request_module()
Date: Wed, 21 Feb 2024 14:07:32 +0100
Message-ID: <20240221130002.983080743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 4eb9eda6ba64114d98827e2870e024d5ab7cd35b ]

Use IS_ENABLED(CONFIG_IUCV) to determine whether the iucv_if symbol
is available, and let depmod deal with the module dependency.

This was introduced back with commit 6fcd61f7bf5d ("af_iucv: use
loadable iucv interface"). And to avoid sprinkling IS_ENABLED() over
all the code, we're keeping the indirection through pr_iucv->...().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index e14368ced21f..7c73faa5336c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2310,7 +2310,7 @@ static int __init afiucv_init(void)
 {
 	int err;
 
-	if (MACHINE_IS_VM) {
+	if (MACHINE_IS_VM && IS_ENABLED(CONFIG_IUCV)) {
 		cpcmd("QUERY USERID", iucv_userid, sizeof(iucv_userid), &err);
 		if (unlikely(err)) {
 			WARN_ON(err);
@@ -2318,11 +2318,7 @@ static int __init afiucv_init(void)
 			goto out;
 		}
 
-		pr_iucv = try_then_request_module(symbol_get(iucv_if), "iucv");
-		if (!pr_iucv) {
-			printk(KERN_WARNING "iucv_if lookup failed\n");
-			memset(&iucv_userid, 0, sizeof(iucv_userid));
-		}
+		pr_iucv = &iucv_if;
 	} else {
 		memset(&iucv_userid, 0, sizeof(iucv_userid));
 		pr_iucv = NULL;
@@ -2356,17 +2352,13 @@ static int __init afiucv_init(void)
 out_proto:
 	proto_unregister(&iucv_proto);
 out:
-	if (pr_iucv)
-		symbol_put(iucv_if);
 	return err;
 }
 
 static void __exit afiucv_exit(void)
 {
-	if (pr_iucv) {
+	if (pr_iucv)
 		afiucv_iucv_exit();
-		symbol_put(iucv_if);
-	}
 
 	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
-- 
2.43.0



