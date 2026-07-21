Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E2B44210A;
	Tue, 21 Jul 2026 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672717; cv=none; b=A9m+gYTXGc7QY6yyajGbv7mtYrgXHjc80K12qpIHeirhiHXCi3mejAEuE4hfM7fmSvrk8b4PRn26DhozfnPwAs13nP8knYA1sHbcSxwQj9opiOPm1V5Jqd8lZSWoK58nrwbAOZenkUZoj35AlWeP9qFFL1eDRrLeT1tnoJzvSK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672717; c=relaxed/simple;
	bh=S/SBAgQ4nUY5/ur/stNm5IK/IjAOkvorjq45bYlUZI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOyvxdAChSP2TZyhS6XCCbdT2cNKzm+UJKWnbbvB2Wj881PKOF72B50adJDdKMKhc1d5KlOLBvn0/32gcTn/36hYxO8E6UiN1Ly7NWyq/DKNKNKU6ebccpEXacjzPsYuEAIwa+IO4HIOslSax8TzlL26S/foRuxVOdKrHQYsGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnanfEaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnanfEaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985021F000E9;
	Tue, 21 Jul 2026 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672716;
	bh=KLugIhHq6063egupdUFMyPZFSh/QXY4f2aWzQQZKpdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnanfEaZo1sdmbEBNTMkRk6BcydFO4ZUCwFvC0GQhrsLpK9FTf+bSpj+LGTlPebXg
	 9vfeIv5rAqnXRvaxpQxWhfZRnZ6c2YxZaIvxFsTkM53lVUm9GMYbpF0mhc5OmRxn35
	 IqlMVN5gAdbhPJM0UwiQfgyEQvvj8GZyynk/wdb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 677/843] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:25:12 +0200
Message-ID: <20260721152421.287511465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

commit 86f436567f2516a0083b210bedc933544826a2c3 upstream.

states_show() adds CPU hotplug state names into a single sysfs buffer
using sprintf(). With enough registered states, this can write past the
end of the PAGE_SIZE buffer.

Use sysfs_emit_at() so output is bounded.

Fixes: 98f8cdce1db5 ("cpu/hotplug: Add sysfs state interface")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260619163719.12103-2-include@grrlz.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2436,21 +2436,17 @@ static const struct attribute_group cpuh
 	NULL
 };
 
-static ssize_t states_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static ssize_t states_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	ssize_t cur, res = 0;
+	ssize_t res = 0;
 	int i;
 
 	mutex_lock(&cpuhp_state_mutex);
 	for (i = CPUHP_OFFLINE; i <= CPUHP_ONLINE; i++) {
 		struct cpuhp_step *sp = cpuhp_get_step(i);
 
-		if (sp->name) {
-			cur = sprintf(buf, "%3d: %s\n", i, sp->name);
-			buf += cur;
-			res += cur;
-		}
+		if (sp->name)
+			res += sysfs_emit_at(buf, res, "%3d: %s\n", i, sp->name);
 	}
 	mutex_unlock(&cpuhp_state_mutex);
 	return res;


