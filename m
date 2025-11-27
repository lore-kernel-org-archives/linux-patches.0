Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC2628135D;
	Thu, 27 Nov 2025 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255964; cv=none; b=ofuxSkxGZ/TPtgGzxIjzJ4RqljiDqSboqDGQq4TN10AB5MzxXWHuuxJ0mAG/wXglOvQeAbxibhxVQkgesrNahrKNTSwQUdVcBSLX3Cb7tQVmVbySpIg91yD7j3uEztiQWOTFQsoHQYhZJmRwyuc51qG/YDO6IFogX5k518KySM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255964; c=relaxed/simple;
	bh=dpKE7ED493mqZPro8OtOTi1HN7d3pWhPA/u905z+ILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii6xoiyagupfkcRnM19c8oM2PIoBKfflNN3YXAC2lJyvDUNh3UP0eugoqJSlRzr0wnZJw2COcAQ2+xqr4n1ljfsXi2iIb+T9bc3PwI3hXBNffWh615+rTYO0hFG5R9PKjyiM21q5w8ibUm9p9Egv1mRYpw38Ufz/9C6/mAJBU/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da9Yd/al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da9Yd/al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579F1C4CEF8;
	Thu, 27 Nov 2025 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255963;
	bh=dpKE7ED493mqZPro8OtOTi1HN7d3pWhPA/u905z+ILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Da9Yd/alu6WkQLHZTZ575eLqVNBvsunfxvevvNmRavensfE4tevWP9erotFLxAXOJ
	 ErJliA+Fav8i0lkASeO9OzmhtewuXrRsWlxRtpZ4ed00d29a4urqoCdq+xR2ijM36w
	 0I2iWMNM0jm/2V2OUYtaTd/Kf/tI68MI7ndvaVSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <mrout@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/175] timekeeping: Fix resource leak in tk_aux_sysfs_init() error paths
Date: Thu, 27 Nov 2025 15:46:25 +0100
Message-ID: <20251127144047.780175083@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <mrout@redhat.com>

[ Upstream commit 7b5ab04f035f829ed6008e4685501ec00b3e73c9 ]

tk_aux_sysfs_init() returns immediately on error during the auxiliary clock
initialization loop without cleaning up previously allocated kobjects and
sysfs groups.

If kobject_create_and_add() or sysfs_create_group() fails during loop
iteration, the parent kobjects (tko and auxo) and any previously created
child kobjects are leaked.

Fix this by adding proper error handling with goto labels to ensure all
allocated resources are cleaned up on failure. kobject_put() on the
parent kobjects will handle cleanup of their children.

Fixes: 7b95663a3d96 ("timekeeping: Provide interface to control auxiliary clocks")
Signed-off-by: Malaya Kumar Rout <mrout@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251120150213.246777-1-mrout@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timekeeping.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3a4d3b2e3f740..08e0943b54da6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -3060,29 +3060,32 @@ static const struct attribute_group aux_clock_enable_attr_group = {
 static int __init tk_aux_sysfs_init(void)
 {
 	struct kobject *auxo, *tko = kobject_create_and_add("time", kernel_kobj);
+	int ret = -ENOMEM;
 
 	if (!tko)
-		return -ENOMEM;
+		return ret;
 
 	auxo = kobject_create_and_add("aux_clocks", tko);
-	if (!auxo) {
-		kobject_put(tko);
-		return -ENOMEM;
-	}
+	if (!auxo)
+		goto err_clean;
 
 	for (int i = 0; i < MAX_AUX_CLOCKS; i++) {
 		char id[2] = { [0] = '0' + i, };
 		struct kobject *clk = kobject_create_and_add(id, auxo);
 
 		if (!clk)
-			return -ENOMEM;
-
-		int ret = sysfs_create_group(clk, &aux_clock_enable_attr_group);
+			goto err_clean;
 
+		ret = sysfs_create_group(clk, &aux_clock_enable_attr_group);
 		if (ret)
-			return ret;
+			goto err_clean;
 	}
 	return 0;
+
+err_clean:
+	kobject_put(auxo);
+	kobject_put(tko);
+	return ret;
 }
 late_initcall(tk_aux_sysfs_init);
 
-- 
2.51.0



