Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315F477636;
	Wed, 21 Feb 2024 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521613; cv=none; b=Et6ACoJfdqvmPAEoMNkvAn+bXWatNIWbFXobG3CMaLTrJPsUYQmBmHODRhmXEDSs16TiAV30ILF7xFpGJhupqmWUMTdPOKWiikdwOLhrJDesrAHtLgbS35SPqjBiT8eSA8Csg03yLEpBIqQV+vIImA4haPwfwr7kJho3yZ8UzMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521613; c=relaxed/simple;
	bh=r5wILG8Ea4Fki+m2s1Qn7cEPi9DlS8Jcj+ik5Or/Z8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md5BFzi8ytEgFwauIpEw96MpFqziepiw4Qh04ZtPyaAf7aoA8z+tPL7M01hIAJ/9gVb50mhEtOOn8rn0je8y82K2EJBdz8WukqkvzvhdQFohEFhR8gN04WxHQTWteA6ls+R0R80hL5k9VGEWSBA5hl3aHXylUWArn+xwpeUcSy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRibocJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRibocJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80ACC43394;
	Wed, 21 Feb 2024 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521613;
	bh=r5wILG8Ea4Fki+m2s1Qn7cEPi9DlS8Jcj+ik5Or/Z8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRibocJ9EfwyMypCSAPGqkEHZjh1LpG3orgHl9+5J3EhcstpebFQFkc4Tblo/2gv+
	 S5gmkYmcpgFf/n5UUL3vbnvQtRSKlqsmdJV99J2OuZM3uxnAoUL4S9Ww4pn+g9de8Y
	 bWI3RmTb/hJ5ncGo3nH1eYQySW4M+b3aSiPacLfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/202] net/af_iucv: clean up a try_then_request_module()
Date: Wed, 21 Feb 2024 14:07:39 +0100
Message-ID: <20240221125936.804217260@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d59f2341bfec..1ff2860dd3ff 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2477,7 +2477,7 @@ static int __init afiucv_init(void)
 {
 	int err;
 
-	if (MACHINE_IS_VM) {
+	if (MACHINE_IS_VM && IS_ENABLED(CONFIG_IUCV)) {
 		cpcmd("QUERY USERID", iucv_userid, sizeof(iucv_userid), &err);
 		if (unlikely(err)) {
 			WARN_ON(err);
@@ -2485,11 +2485,7 @@ static int __init afiucv_init(void)
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
@@ -2523,17 +2519,13 @@ static int __init afiucv_init(void)
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



