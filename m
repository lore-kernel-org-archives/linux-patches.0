Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E501315D53;
	Tue, 21 Jul 2026 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659142; cv=none; b=DLhd6BmJGyBRB63nnzkRZ2iVOKZdUv9dZDwKp6/burWilOQ0pIogzE4C2S3C/1AbXpYjNKsb7nC8LlTAdFz78skr+pJns6f0tz2j+UeK9OzfbUI6mXYQzSSl1sp0wHLxtk0VAbDN74r54k5No57I3BcgeCgnzeMWB3xzM1Vc1Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659142; c=relaxed/simple;
	bh=/sMnKXUwDu8rfpCIa/68Xg3aCHeTmG+0sFd/oVQArfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTJ9YEKkTbQIdZh2NEgYeh2eO4w7dxX5LvF9SCBGhkJdTqPlPjVK6eU1Fm5/o7AeFc5lM+mNuK4+gxOYkiow4uysL4uLOiZrM8eOshAnhCsGtDLq8OmfKqnI9wu11teR3HewgGo4E2sKclTroyX62CmkRlz5wfUJ2ZHpT2sWH6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgBcHMk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgBcHMk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55B61F000E9;
	Tue, 21 Jul 2026 18:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659141;
	bh=l1vJribPA0FhVbp/gKsA34o4N/jdR55E5aT420OCgMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgBcHMk+cqqUwQgcMQswOi5fkMl1ll5HGL75iDY2LSIRtsm0cdvQ1sIKgrqwJ+Dz6
	 sWDQ2UtX9gOkFwKNZWiuuOraJLCMSUxYrwIm992wRolIbqRaHcw0PM+RmBkFH9FJBl
	 YzDBDDc/jG/ivYWDGtaEMICLiW7y6MTpRnjuSP6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 1392/1611] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:25:08 +0200
Message-ID: <20260721152546.753581449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2865,21 +2865,17 @@ static const struct attribute_group cpuh
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


