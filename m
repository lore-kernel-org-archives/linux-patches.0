Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB133EE1C0;
	Wed, 20 May 2026 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296923; cv=none; b=h9EcoBVq6u9rBl0aMoecqWtBUy+L9qGSWRQYRdkLXC/KBevJRdoRjYR5YVkabIvhW71IIwlcCrm1djVZGAdr3/KKCtl2WfwmjXtNJWmPr5EQxd8+YXO/AIf9MAvbHX2TT3Hcavh/KDJln5yCZgeDkmC0zcGz8MD0MCM8n3r3Z9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296923; c=relaxed/simple;
	bh=L7EJMqgJYoiCn3av+LJXTFfkJe9GT0Dt1fkxhroRpek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF4ZOjtCazhCCuTo47MPrT+H0Yk5lVoxM+OAEfMoFjjpWhPIktdkgxekrKGfkU6Sylt2Ze/LIuQpwxONzvMFu348y/qHQDv1z69eHjvKpQuROmzktwO3iwJFR14Ccu9Pqd9ltuJVOQfGX9dO29t2zrH1hHn4i1mfA0mSe9rPdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NF58qjlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NF58qjlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37121F000E9;
	Wed, 20 May 2026 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296922;
	bh=13dEf3ks5FwS6qpnT+bl3w8wEa/yNQiIb2cQAOWsmjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NF58qjlHxpBRWxRAN+gbQxNzOrIS4GK3lnS1xhI3bExQ822tjMt00UBghGHBRmlAg
	 EBw6IoNroc0vpJBGoid0pEtvgBRzMgGLzaPnj6envyUIvk4w4GV1g1J/70PzavF9QK
	 IvVj4Gt8HUdhfvQO5e9zxLbPe1Od1A7QBnSqAYcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0983/1146] net: psp: check for device unregister when creating assoc
Date: Wed, 20 May 2026 18:20:33 +0200
Message-ID: <20260520162210.476014008@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b89769f936a8fa9e66de72ddc1b71a9745a488e6 ]

psp_assoc_device_get_locked() obtains a psp_dev reference via
psp_dev_get_for_sock() (which uses psp_dev_tryget() under RCU);
it then acquires psd->lock and drops the reference. Before
the lock is taken, psp_dev_unregister() can run to completion:
take psd->lock, clear out state, unlock, drop the registration
reference.

The expectation is that the lock prevents device unregistration,
but much like with netdevs special care has to be taken when
"upgrading" a reference to a locked device. Add the missing
check if device is still alive. psp_dev_is_registered() exists
already but had no callers, which makes me wonder if I either
forgot to add this or lost the check during refactoring...

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260427190606.366101-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psp/psp_nl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/psp/psp_nl.c b/net/psp/psp_nl.c
index 6afd7707ec12e..0cc744a6e1c9b 100644
--- a/net/psp/psp_nl.c
+++ b/net/psp/psp_nl.c
@@ -305,8 +305,13 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 
 	psd = psp_dev_get_for_sock(socket->sk);
 	if (psd) {
-		err = psp_dev_check_access(psd, genl_info_net(info));
-		if (err) {
+		/* Extra care needed here, psp_dev_get_for_sock() only gives
+		 * us access to struct psp_dev's memory, which is quite weak.
+		 */
+		mutex_lock(&psd->lock);
+		if (!psp_dev_is_registered(psd) ||
+		    psp_dev_check_access(psd, genl_info_net(info))) {
+			mutex_unlock(&psd->lock);
 			psp_dev_put(psd);
 			psd = NULL;
 		}
@@ -319,7 +324,6 @@ int psp_assoc_device_get_locked(const struct genl_split_ops *ops,
 
 	id = info->attrs[PSP_A_ASSOC_DEV_ID];
 	if (psd) {
-		mutex_lock(&psd->lock);
 		if (id && psd->id != nla_get_u32(id)) {
 			mutex_unlock(&psd->lock);
 			NL_SET_ERR_MSG_ATTR(info->extack, id,
-- 
2.53.0



