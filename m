Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3459E11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A961FC433CA;
	Mon, 28 Aug 2023 10:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217842;
	bh=7+CHnaC1gBCiwP+hzmlqvP7yA2tKwUMGbpc/EKT/DEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdGnpfjhETX2WePMiNx9YVOjxU3ccDm42fljjAFqfVR3nQ0Jk7y4IAd0LbOLCdwny
	 7uUgeFrU73x8MtEBTdxEXh0S3JSsXgIb/UwOlWKy8ptezWolYchJ36yfaODntcHox4
	 VSdvfRHDOCdtQavpNzz02iZmvAkS/gvMdS9I2AgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junwei Hu <hujunwei4@huawei.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 44/57] ipvs: Improve robustness to the ipvs sysctl
Date: Mon, 28 Aug 2023 12:13:04 +0200
Message-ID: <20230828101145.883319622@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junwei Hu <hujunwei4@huawei.com>

commit 1b90af292e71b20d03b837d39406acfbdc5d4b2a upstream.

The ipvs module parse the user buffer and save it to sysctl,
then check if the value is valid. invalid value occurs
over a period of time.
Here, I add a variable, struct ctl_table tmp, used to read
the value from the user buffer, and save only when it is valid.
I delete proc_do_sync_mode and use extra1/2 in table for the
proc_dointvec_minmax call.

Fixes: f73181c8288f ("ipvs: add support for sync threads")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Julian: Backport by changing SYSCTL_ZERO/SYSCTL_ONE to zero/one]
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |   70 +++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1648,6 +1648,7 @@ static int ip_vs_zero_all(struct netns_i
 #ifdef CONFIG_SYSCTL
 
 static int zero;
+static int one = 1;
 static int three = 3;
 
 static int
@@ -1659,12 +1660,18 @@ proc_do_defense_mode(struct ctl_table *t
 	int val = *valp;
 	int rc;
 
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 3)) {
-			/* Restore the correct value */
-			*valp = val;
+		if (val < 0 || val > 3) {
+			rc = -EINVAL;
 		} else {
+			*valp = val;
 			update_defense_level(ipvs);
 		}
 	}
@@ -1678,33 +1685,20 @@ proc_do_sync_threshold(struct ctl_table
 	int *valp = table->data;
 	int val[2];
 	int rc;
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = table->maxlen,
+		.mode = table->mode,
+	};
 
-	/* backup the value first */
 	memcpy(val, valp, sizeof(val));
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (valp[0] < 0 || valp[1] < 0 ||
-	    (valp[0] >= valp[1] && valp[1]))) {
-		/* Restore the correct value */
-		memcpy(valp, val, sizeof(val));
-	}
-	return rc;
-}
-
-static int
-proc_do_sync_mode(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int *valp = table->data;
-	int val = *valp;
-	int rc;
-
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (write && (*valp != val)) {
-		if ((*valp < 0) || (*valp > 1)) {
-			/* Restore the correct value */
-			*valp = val;
-		}
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (write) {
+		if (val[0] < 0 || val[1] < 0 ||
+		    (val[0] >= val[1] && val[1]))
+			rc = -EINVAL;
+		else
+			memcpy(valp, val, sizeof(val));
 	}
 	return rc;
 }
@@ -1717,12 +1711,18 @@ proc_do_sync_ports(struct ctl_table *tab
 	int val = *valp;
 	int rc;
 
-	rc = proc_dointvec(table, write, buffer, lenp, ppos);
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
 	if (write && (*valp != val)) {
-		if (*valp < 1 || !is_power_of_2(*valp)) {
-			/* Restore the correct value */
+		if (val < 1 || !is_power_of_2(val))
+			rc = -EINVAL;
+		else
 			*valp = val;
-		}
 	}
 	return rc;
 }
@@ -1782,7 +1782,9 @@ static struct ctl_table vs_vars[] = {
 		.procname	= "sync_version",
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_do_sync_mode,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 	{
 		.procname	= "sync_ports",


