Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D053447ACD7;
	Sat, 12 Sep 2026 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214400; cv=none; b=PkqWpBBijnf6EJr0m7hAxIMjkLRIpk0VjLQ8BXRKk+DyxL4WDS3kl8d6w+lXF+mFaGQkyBxczrII80oJyb7pbykV0RFwtOmUtoGyiCNdCRigzqZsVIaJlyIJNIL/I18vvLxneFWsPRzPmuDRlifkidpBpIv0jm3BID6VDcW9bE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214400; c=relaxed/simple;
	bh=VScdBUeGGTKzN02t4W0DMnQeNHZ1oCFkWW/4FbzI3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/8p92awvs24imqy60AFEz1XuBTjeUk7x+zLlYoICNtp2GyNs33eaBVuELEjIMcKS4+Yp0GDyfvOyfoV3o1oMwX8RQ4fVzVyn5+ObQPss50KQtwIcnHR6FYJU8yt6ksfZfxHuz4yPDuBb61x3A2bEUeaUkemh7+F+sH+k4gM2e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+R/JZrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+R/JZrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DF81F00893;
	Sat, 12 Sep 2026 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214397;
	bh=0Sx96BBXBbKI7J6aFkhCGagUMjE0Ofa6lqPjj29yBYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+R/JZrHkBmJSaO+Vv4SSjE1TUpHmo5pN6XlsCH/WgjjQ7Di1cTuuRinUti8xXpDc
	 x/X7BT55H6Wp6H5kpUv7wRw6mZO5MLBZNMlF4UYBVQK1a2EjmrxPx4WmBxIqlAXl2U
	 pjh2P7kZfV5bPAqMzOzXo8UM5DcUu3mcMW+itDzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0317/1376] smack: restrict smackfs/{direct,mapped} values to 0-255
Date: Sat, 12 Sep 2026 08:45:43 +0200
Message-ID: <20260912065614.615292421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit a7c44fd9f80e37763acf9cd3c87a58058d206427 ]

Both smackfs/direct and smackfs/mapped incorrectly accept
the full range of integer values. For example:

    # cd /sys/fs/smackfs/
    # cat direct ; echo
    250

    # cat cipso2
    @ 250/2
    _ 250/2,4,5,6,7,8
    * 250/3,5,7
    ^ 250/2,4,5,6,7
    ? 250/3,4,5,6,7,8

    # echo -1234 >direct ; cat direct ; echo
    -1234
    # cat cipso2
    @ -1234/2
    _ -1234/2,4,5,6,7,8
    * -1234/3,5,7
    ^ -1234/2,4,5,6,7
    ? -1234/3,4,5,6,7,8
    #

I noticed two things regarding this:

1) sensitivity levels are truncated to 8 bits when labeling
   outgoing packets (0x2e = 46 for the -1234 example above)

2) the reverse process fails: incoming packets with sensitivity
   level 46 do not match these smackfs/cipso2 entries.

Even observation (1) on its own warrants a fix.

This patch restricts smackfs/direct and smackfs/mapped
accepted values to the 0-255 range.

Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")
Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h   |  2 +-
 security/smack/smackfs.c | 26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 26b3fa0d3e463..f1eda7f269f58 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -302,7 +302,7 @@ int smack_populate_secattr(struct smack_known *skp);
  * Shared data.
  */
 extern int smack_enabled __initdata;
-extern int smack_cipso_auto_level[2];
+extern u8  smack_cipso_auto_level[2];
 #define smack_cipso_direct (+smack_cipso_auto_level[0])
 #define smack_cipso_mapped (+smack_cipso_auto_level[1])
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index ab472058d2e43..0f304667d8578 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -92,7 +92,7 @@ struct smack_known *smack_net_ambient;
  * secid is contained directly in the category set.
  * It can be reset via smackfs/mapped
  */
-int smack_cipso_auto_level[2] = {
+u8 smack_cipso_auto_level[2] = {
 	SMACK_CIPSO_DIRECT_DEFAULT,
 	SMACK_CIPSO_MAPPED_DEFAULT,
 };
@@ -1659,17 +1659,15 @@ static const struct file_operations smk_doi_ops = {
 static ssize_t smk_read_cipso_auto_level(struct file *filp, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	char temp[80];
-	ssize_t rc;
+	char temp[sizeof "255"];
+	int n;
 
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smack_cipso_auto_level[
-			      smk_cipso_auto_level_idx(filp)]);
-	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
-
-	return rc;
+	n = sprintf(temp, "%u", (unsigned int)smack_cipso_auto_level[
+		smk_cipso_auto_level_idx(filp)]);
+	return simple_read_from_buffer(buf, count, ppos, temp, n);
 }
 
 /**
@@ -1685,13 +1683,16 @@ static ssize_t
 smk_write_cipso_auto_level(struct file *filp, const char __user *buf,
 			   size_t count, loff_t *ppos)
 {
-	struct smack_known *skp;
-	int i, ret, idx, old_lvl;
+	int ret, idx;
+	u8  i, old_lvl;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
-
-	ret = kstrtos32_from_user(buf, count, 10, &i);
+	/*
+	 * draft-ietf-cipso-ipsecurity-01 (CIPSO 2.2), 3.4.2.4:
+	 * "Sensitivity Level is 1 octet in length. Its value is from 0 to 255"
+	 */
+	ret = kstrtou8_from_user(buf, count, 10, &i);
 	if (unlikely(ret))
 		return ret;
 
@@ -1704,6 +1705,7 @@ smk_write_cipso_auto_level(struct file *filp, const char __user *buf,
 	old_lvl = smack_cipso_auto_level[idx];
 
 	if (old_lvl != i) {
+		struct smack_known *skp;
 		mutex_lock(&smack_known_lock);
 		list_for_each_entry_rcu(skp, &smack_known_list, list)
 			if (skp->smk_netlabel.attr.mls.lvl ==
-- 
2.53.0



