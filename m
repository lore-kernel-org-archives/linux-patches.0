Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E47936A36A;
	Sat, 12 Sep 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206614; cv=none; b=O3Uq52brnsoGltmqX/wSmQybXs3ybcJ0GB0/4OzVOMvY9le58qJlA74ZwHDWhoDq5GtpLM1ZZx3hRHWuT919yUa+X3aUPaopeimlN+J2NG1j+rwPh0nAE5RwBb7Esk7baZDi8P73deRdDFjQ60D2wUM2ZReiHEngLVVyf8AgxBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206614; c=relaxed/simple;
	bh=oPt90TRyWHNA9iYZp9i0tCkkYib+m3n6syqFV59/uBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0Uv7vKqfJjVqSwl2Zlh3KMqkPR1XFc0hjR6zw4dh3EFz1GgGQ9ctA5HTX5cOhd12zrYhxuN+ScSuK5USoAqPI2rPweVylNwW9y11qMUzWFL3TwuUa0Tv7ENjlTOjOi5jw+rWH2hUEpKhOptK1OA5y4hFmb6GGs7puA2allRQYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi0+WhsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi0+WhsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ADD1F000FF;
	Sat, 12 Sep 2026 09:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206613;
	bh=Cq672IrsVH3w8CbVkfxXONP4Xj9ZzkPM2vLYQcZOhSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gi0+WhsFf7WKI3WrOaNkdC6rsCbIdBCaO0vK7nuwVPlw078qjv+0jD7bfgvjh0i4y
	 Cu+v0sauBToRMvVWw+89l56Unysvp5tZM105C4w91HyCOaSLgqeH142ES5XCuTWtC6
	 ItjDql1737pj2cBpDOLUuUr2MKwr6M9yVkEibZds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0244/1518] timekeeping: Unwind aux clock sysfs children on failure
Date: Sat, 12 Sep 2026 08:40:13 +0200
Message-ID: <20260912065629.000087763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 06184f304c6a0..e6060d9392d09 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -3065,7 +3065,9 @@ static const struct attribute_group aux_clock_enable_attr_group = {
 static int __init tk_aux_sysfs_init(void)
 {
 	struct kobject *auxo, *tko = kobject_create_and_add("time", kernel_kobj);
+	struct kobject *clks[MAX_AUX_CLOCKS];
 	int ret = -ENOMEM;
+	int i;
 
 	if (!tko)
 		return ret;
@@ -3074,21 +3076,28 @@ static int __init tk_aux_sysfs_init(void)
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



