Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5E3B287;
	Wed, 21 Feb 2024 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525592; cv=none; b=EuKsfkuzksB4pCAl/t5R0A+NoeMG7WNWHRaRu9mmodWQOywiyr4rxT6npaf7BR/MCaaLALR2HNA2/USPaIcBDZ5XC2AFot8j3q69SSxl5eYHwkVpFfzSR+y0T/pUQgPmh3akhYGX/UVAYPKOir9822l+zM+Giv6ZU2FsePxz0mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525592; c=relaxed/simple;
	bh=vmuWrMUXIcSedqu8ZVhX9pH79NHXUEsUAymcmywGJvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsnhMAbBTfvINIB90uSQru20lG7oBs6xQp3LRH3bx5qmPP9P2zC1jmxZH17Cc9PiVrxO50bZuYTJk7dXrm87NnSZfqbhmSXJT7maNgKRaRmW9LPmlv2ETJQddH1jLzg0daQ5xEEDZGHc47DojSRpbbucq9ojFJk7LKWnS7zDRgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+ZDNsyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+ZDNsyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77181C433F1;
	Wed, 21 Feb 2024 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525591;
	bh=vmuWrMUXIcSedqu8ZVhX9pH79NHXUEsUAymcmywGJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+ZDNsyz1bR2hRX/tmLWSsdxC0BvJZH/oMADlm9sGPfskbNdQ9bNIygEbPdPVJFNI
	 JdwjKnZyZ2unW0T9UY0nzl17ZccKD6DiQ7cumMHcqS3lr1Z5mqWJiom7V5yQYYlVbO
	 U7KqkNLTsPPEsaKxqkshjW1hg/KHBaiYZS9zYp70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/267] net/af_iucv: clean up a try_then_request_module()
Date: Wed, 21 Feb 2024 14:08:55 +0100
Message-ID: <20240221125946.228634831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bbc1924d64e5..652285191da1 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2455,7 +2455,7 @@ static int __init afiucv_init(void)
 {
 	int err;
 
-	if (MACHINE_IS_VM) {
+	if (MACHINE_IS_VM && IS_ENABLED(CONFIG_IUCV)) {
 		cpcmd("QUERY USERID", iucv_userid, sizeof(iucv_userid), &err);
 		if (unlikely(err)) {
 			WARN_ON(err);
@@ -2463,11 +2463,7 @@ static int __init afiucv_init(void)
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
@@ -2501,17 +2497,13 @@ static int __init afiucv_init(void)
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



