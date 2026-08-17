Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D8D3ABD99;
	Mon, 17 Aug 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975414; cv=none; b=hVKTNTzfiivIPC/GMtIHw0N5ise3hrtmwLl656bojPtfEmyJtgPjnTbRh8VxqG6HNWuxYgdnwqZyL+ZHMKNPDawZfYz7NAzUL3bUG6aBs3Uxfhqt8t2Q0ghRBS3FZ8gLSrqcjiNfH6iEWZe1n3v3OWLFu0KTaeLODgbNyifM0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975414; c=relaxed/simple;
	bh=QKHbglmNlwBYNcnqdLE+4eaoQfAKxQ1F6Dl36zk5pH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARY5uQDbYOBBTEw5JU2lWXOMInGLhG6QNmxnfFEYkFW8uoH1ZtrESG59TCzlGkGbvt5+EFj+FFmlD6fX7p4NuP9Eiy1/CldmHvId/Jj5u6Edweydou92pv3kmnAUYgYtBfhySUoAlD3YMBn6E4AJeOtkNAtfXbyZy3YKDyOqP6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLUaTor/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLUaTor/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E841F000E9;
	Mon, 17 Aug 2026 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975413;
	bh=+8Sl9F4IxJdBwnY3ivxE7bLqdLwKvPt4d1ZwXlFskD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLUaTor/gNgwetEwR3lHJKMUMrwij1ag1bECoGZhGyvlpvDUxnGc1lKvz/hSx9j0l
	 tyRrNKti74c0ccszzbuqD2PUfUIdT1mtMpEYX/owkFt+TPKSNdbzdbJdQNVClg99KM
	 H5WAKlsQVSo2+fzGvcuqXEBUrc8aBIN2qn6keUp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/389] cpu: hotplug: Bound hotplug states sysfs output
Date: Mon, 17 Aug 2026 15:27:21 +0200
Message-ID: <20260817132538.909140004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cpu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 08c2b2e30f23f1..69c7be3706f15b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2319,18 +2319,15 @@ static const struct attribute_group cpuhp_cpu_attr_group = {
 static ssize_t show_cpuhp_states(struct device *dev,
 				 struct device_attribute *attr, char *buf)
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
-- 
2.53.0



