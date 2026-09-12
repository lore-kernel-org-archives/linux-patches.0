Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E037CD21;
	Sat, 12 Sep 2026 07:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197795; cv=none; b=MynXBzXzC9jfx1c0lDMmLAYdZflFrKgV7o9pIrfqmP0DE2cHzBJNDG7F2cdz336G76BlQfDz9xccpbBDVfW5kthvwin0kel3kCDy7291RbdGp0Flew5TVktbMizmdt9kSPPi0JKc03zHhsJU+CBNPDE6QQiRbX285J9CdH0yvno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197795; c=relaxed/simple;
	bh=Zc0oL74wQGc1KNnA9fsMI6XERmxHlEryLSfrLDiukns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J98RF2kHMuKfhigiwZprbWLx5ZCnzyX05QroNhZQZFpFNPoVSWdQksPwS1lp332+LU6EIa5joWmH0mo3DVnWznqun5MUjR+zWXURN8YXzX1EUDlv/V9XJRh2KaU1kTLzn75UNjd4xqhxdvsBPYUmQiZWuKiWJ9tMdXJdJgKEkyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2fRhKb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2fRhKb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D255F1F000FF;
	Sat, 12 Sep 2026 07:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197793;
	bh=jfVlwTTIGz+7kOEPShSFB4L7dLz7xPwIkDsQOVvlp08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2fRhKb2+PbrxgRkB3DqcXyOTFlGwjvVnSaFusPgMZ6EUr4sIYg440aKEuIy1+fQJ
	 YpkT3rMaBrq0IN15vwTBx2/xiW57tRe+cjKUakzRGFqIbAUx2AeporOfMt7IreXSrA
	 a6QI65NE1d1fx2i2ppipeoGMyCgq3UllgLRMGdT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0248/1815] timekeeping: Unwind aux clock sysfs children on failure
Date: Sat, 12 Sep 2026 08:33:18 +0200
Message-ID: <20260912065654.807801028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit f2eee7e31ccd4bc87d047d8670cc2ec39cf36647 ]

tk_aux_sysfs_init() creates one child kobject per auxiliary clock. If a
later child or sysfs group creation fails, the current error path only
puts the parent kobjects and leaves earlier children and groups behind.

Store the child kobjects during init and remove the successfully created
groups and kobjects on failure.

Fixes: 7b5ab04f035f ("timekeeping: Fix resource leak in tk_aux_sysfs_init() error paths")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260703165337.168445-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 696bb119c56ef..49f81336aae21 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -3315,7 +3315,9 @@ static const struct attribute_group aux_clock_enable_attr_group = {
 static int __init tk_aux_sysfs_init(void)
 {
 	struct kobject *auxo, *tko = kobject_create_and_add("time", kernel_kobj);
+	struct kobject *clks[MAX_AUX_CLOCKS];
 	int ret = -ENOMEM;
+	int i;
 
 	if (!tko)
 		return ret;
@@ -3324,21 +3326,28 @@ static int __init tk_aux_sysfs_init(void)
 	if (!auxo)
 		goto err_clean;
 
-	for (int i = 0; i < MAX_AUX_CLOCKS; i++) {
+	for (i = 0; i < MAX_AUX_CLOCKS; i++) {
 		char id[2] = { [0] = '0' + i, };
-		struct kobject *clk = kobject_create_and_add(id, auxo);
+		clks[i] = kobject_create_and_add(id, auxo);
 
-		if (!clk) {
+		if (!clks[i]) {
 			ret = -ENOMEM;
-			goto err_clean;
+			goto err_clks;
 		}
 
-		ret = sysfs_create_group(clk, &aux_clock_enable_attr_group);
+		ret = sysfs_create_group(clks[i], &aux_clock_enable_attr_group);
 		if (ret)
-			goto err_clean;
+			goto err_clk;
 	}
 	return 0;
 
+err_clk:
+	kobject_put(clks[i]);
+err_clks:
+	while (--i >= 0) {
+		sysfs_remove_group(clks[i], &aux_clock_enable_attr_group);
+		kobject_put(clks[i]);
+	}
 err_clean:
 	kobject_put(auxo);
 	kobject_put(tko);
-- 
2.53.0



