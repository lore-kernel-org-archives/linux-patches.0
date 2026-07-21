Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39185473C65;
	Tue, 21 Jul 2026 20:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667490; cv=none; b=NB5EZ14MOBDECkGtyphSxU7+anarq81oJ1M7qtFE5j0pvas8YQ1oniacwZpXsC12AuNck8FGnt4PXoE6ddYwX13u9NTq7AQAOi1mGbczfRIptj+A5vsOVKb9r5sG88KeRgCjAbgI8pB1owFqXc45TptXfO7RIa2Gv/Wk10DN+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667490; c=relaxed/simple;
	bh=JTdeo5kBEB8CVgfjzC9UvJZzU/x3flJVxyPDHX34p94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da/Sl5fqEsq6RJVLDWFGdtGNeKKoe0P58WNV1gkTKxNIEUImPDwkand8ISScBuad2eii8o9Y2XiiDtM68QTdkm+luxMdrly9Ojy/Li3oe8V85eo9PBWhBHwUy/YuMjluPAblTU6X3WfwIkYrgURDZaBnwCO95SYVLvx2d9MsAEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqUkyuf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqUkyuf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBF1F00A3A;
	Tue, 21 Jul 2026 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667477;
	bh=uBMJPeD4CfNQ8YPzCxLcKi/umqZ7VJrXYWv9BeckAIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqUkyuf2FbkXWa2kPcwvOt0we3Fbhc/EWJSaSNBiOPS4fKdghxiomDoqVZQqCjQxR
	 9pLy+4XCdX0gP1sS9M5cfmA2oErdO8KSY7T6L2nLEWi5+dXpC62sbtXqYZGNuySKJ1
	 FJnEh0sQhqV8RehZZOwVSZEgVgtU2h2nBML4buQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 1077/1266] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:25:14 +0200
Message-ID: <20260721152505.917722112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2894,21 +2894,17 @@ static const struct attribute_group cpuh
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


