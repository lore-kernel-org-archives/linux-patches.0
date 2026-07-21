Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DC71A683A;
	Tue, 21 Jul 2026 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664018; cv=none; b=BaWdCVRzHL1gnPPUSc5xQYL/V8+32QD4jTs8d6IG8XRjGV7KxgWAe4BPznrmHm6DcFHdwhfjpYMKQ7k1F0Q0Knctv/HVDWljyouRoP9ciwSQ8gGFpPuhXjY+Mb3JR5YYrb6DAAAvqU9c274IFi68UQZlC6gqvBZQc+wgdXPbKNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664018; c=relaxed/simple;
	bh=kRwZHaT3ZctefIIEU+W8GyBn6SDZKs/OerJ3oQS93Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqHbfKj6L3UM2nOwd3h7TYvaTaGUsMDjAdhkWlJzIJ16Iis1BaACJ94AXKwuL2vtW2z8mn44XU6AS2Kr8tulyCKt/++9sgx4+V05dEvdQWFxvg5Zr7l6ykGgDl+Sdm5fONJDeOKcfJI5Q1ubDy1dmXdegqKDzAZroDHNWW9bCQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=majcKQzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="majcKQzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DFD1F000E9;
	Tue, 21 Jul 2026 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664016;
	bh=5PyrUvYoPpjnYKbeX2ysz6OJx12nhGfIh/3IpEC2qUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=majcKQzC/R3hLAqC39h4IumYGd6QL0fNwFrEYdp6jbpBssXk+0PMqe8O9W1uJZ4qu
	 RrJwi/iYX9xiTFvq1BQbm9ptk7U9iPxR2eymLg1VdBANhC+uVM4QhiP3ydjLrKu4uD
	 UuuLskhW3eOgETf+lQiAq30rK9wojA36bTy/dOck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 1041/1276] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:24:44 +0200
Message-ID: <20260721152509.280552061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -2864,21 +2864,17 @@ static const struct attribute_group cpuh
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


