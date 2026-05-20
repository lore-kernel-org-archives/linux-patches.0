Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E95F39B483;
	Wed, 20 May 2026 17:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299572; cv=none; b=mfIfYvgwNNdOXI4qU6IrH6J0m38Khv5QqCeJfUmMKMZo32SCByzsBVGHVDVnan0FHt1NIaWYQJS5+ql7cqTV+5DzOP/YTrTg8JLibBydghAhkjR2hgMpgqTHOfl2FokGL4YXASqUC4pFP5ub7KUQ73OafUYfXENWz2Z2gBdOzbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299572; c=relaxed/simple;
	bh=fMothTKDPQpVDeNmGPsjtMoa93bU3q88XP/MPo1Q3Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGc++nQS+1kboy3EcW6coAkVlnFUeRvlNI6O9cwup/SomXRM/oNoTSK9Y4Eu67z2duLnE2v/u+CDnACZO2RDigW7jPn7nZiIzkOSfDR8aEM7LE5K/dfnVb0eFBS1jV88Q4LMjPCGNReC2fySz08mGr6egTgrFJ8c93uUZhcbGfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2SDeKZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2SDeKZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107A51F000E9;
	Wed, 20 May 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299571;
	bh=ePrAscXzeplmu/CD2C2KKX1XInYMiOtDKy4rxs/2r1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2SDeKZ4foYCuA8upoT8EuCmn/oDOEdymKUyo2feT3m/S0UieORrXt7/aDUaDKADR
	 2Rm8T7j068+hrsHPUcmoRi3j45helngUEySIbPyixiu3/18561h7HhaRZ1vIGroags
	 63JYAq7Ud6ee4rw6cHZadw8WGhGEnh+7e7q1wV00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 823/957] netconsole: propagate device name truncation in dev_name_store()
Date: Wed, 20 May 2026 18:21:46 +0200
Message-ID: <20260520162152.416967406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 92ceb7bff62c2606f664c204750eca0b85d44112 ]

dev_name_store() calls strscpy(nt->np.dev_name, buf, IFNAMSIZ) without
checking the return value. If userspace writes an interface name longer
than IFNAMSIZ - 1, strscpy() silently truncates and returns -E2BIG, but
the function ignores it and reports a fully successful write back to
userspace.

If a real interface happens to match the truncated name, netconsole will
bind to the wrong device on the next enable, sending kernel logs and
panic output to an unintended network segment with no indication to
userspace that anything was rewritten.

Reject writes whose length cannot fit in nt->np.dev_name up front:

	if (count >= IFNAMSIZ)
		return -ENAMETOOLONG;

This is not a big deal of a problem, but, it is still the correct
approach.

Fixes: 0bcc1816188e57 ("[NET] netconsole: Support dynamic reconfiguration using configfs")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260427-netconsole_ai_fixes-v2-3-59965f29d9cc@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 7523f7763d36a..06345487d6aac 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -694,6 +694,13 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 		size_t count)
 {
 	struct netconsole_target *nt = to_target(item);
+	size_t len = count;
+
+	/* Account for a trailing newline appended by tools like echo */
+	if (len && buf[len - 1] == '\n')
+		len--;
+	if (len >= IFNAMSIZ)
+		return -ENAMETOOLONG;
 
 	mutex_lock(&dynamic_netconsole_mutex);
 	if (nt->enabled) {
-- 
2.53.0



