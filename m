Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686335C6A3;
	Tue, 21 Jul 2026 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670284; cv=none; b=QVuOAG3kYnKhGEKT7H6Sy1n0MC8pINwyiHh8M4zFWCHuBo/zKm/Gufm/h5CF6H3btqV+D3yQFvaYa8654wwWxfxfeHbBO8aMmh2tGPZWk5hog1XKzioKvtWrMUVdX92fPIB6V4A53n1fRoCY/CJw3gjKUlubXNLkBVMHmWmSJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670284; c=relaxed/simple;
	bh=dMO5vLvVwl7c511uy6avaMPv2qCPwdhPPcvYoWBl77k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7Y2TsaUhF7DpueqRdL/p/O9bpC9mAB8+VAL0hRlo3SCOubnRXBoe4DpVYcjzAVwh5sNZd2etwffB1oGxoOzxP7G0nGtcg6NIYVBwd1wSE0qKps1WrXdAKV2p+O0rrv4Zr6160LQSIOhQmo0ciwk7UTQFSRX+mwVuyDvS/U5n1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8t3deAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8t3deAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCA91F000E9;
	Tue, 21 Jul 2026 21:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670282;
	bh=haU57I+glRU5puyo7MYZjBJLp9YMYN6GjXYfxztqA3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8t3deAgROFvfllxekTNW6hF6srVJ31FEn6uHpEuobuv6xJkLk4hkKdHpyb2zeBro
	 /xZVP8piArgobDo3yyO3QE4GSh0FRoowCREivZm5xq1R4Ne6aJaZHoVVqaHSNj2d2/
	 nOkOT6y7VpIduplod3ZyqnpYaJdEDm1A4VeKTuNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 0873/1067] cpu: hotplug: Bound hotplug states sysfs output
Date: Tue, 21 Jul 2026 17:24:34 +0200
Message-ID: <20260721152444.062765525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2502,21 +2502,17 @@ static const struct attribute_group cpuh
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


