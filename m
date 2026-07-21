Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8837B40C;
	Tue, 21 Jul 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654951; cv=none; b=Ed0rkORc//eX1XC468rgJPr+/f6Xxi8GUq98P3alDBOBEO+ZfYWkqUlnCX1UBJxsgB9VPoq2j9Nm/bWB4QqElghDWTOpz3NK+PX1NDjZxeDCbGT0/iIpK3JAW9xYx3Y0aLmYeasemJxl62U1XaUVqFEL4ZEEE3hmAq8inAiA0wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654951; c=relaxed/simple;
	bh=Ymw1xghJN9lt2rTXW0nUutTwP4okIkUAgf0XZNPETvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA0/pzg9/U54LUpZdofqT+VFC28+q7xWfYLtNP5ihgxMOzh/NI5k2T3kcjnKLqTLQomFebY0m9lMA65lWf7JO+EYlcbdk5ktSwCvCSswGANV6gDZsxruxzghuQpM67lhB6lMRSFGlqL2BRyYCCmHexKQ/LPE67XKDe1GwL14Hic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc5Pie7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc5Pie7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD911F00A3A;
	Tue, 21 Jul 2026 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654949;
	bh=5Y6FEc96yJCjLgmmv2NKduIsS+eu++zWMmmXa3UUitE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc5Pie7I15vCREjGIkwCxc6lFpvToLXa/KT1MEn7DilA15SdtV4tA/ryAsXVclgbA
	 9cbiety4O6GbAhqapHNSlyDB7S9CXE16w8pqBqGuRKymiB3x0Rjw707+XwNBq9T3NA
	 3wa/JLrQpoyndyzGuYZvKiFvTExBY5acXieHpG8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 1900/2077] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:26:13 +0200
Message-ID: <20260721152637.534406200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2854,21 +2854,17 @@ static const struct attribute_group cpuh
 	.name = "hotplug",
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


