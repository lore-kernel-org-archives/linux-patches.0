Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C2630FF08;
	Sat, 12 Sep 2026 09:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206525; cv=none; b=R7mujNqLLEgVibkWtcIy3532ZoRm/rZ2pV8WJJcNqkZAvny0jGWXbu+MSns3yCYZBwnQY6Dv+/vNXh2j7xS+yxb2SnPHb4IQc6tzI6uxZex7p9vX7ZAptkKxu/1GBrlplFHNmuM2Em08cN83/DrUvsyeu4b3LUK5umQpRqo0bNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206525; c=relaxed/simple;
	bh=7W6r1YCUavhyydBeMeQ5t088ckSoiWzuKGBa6mP1TFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7T59yq7munhLlOfK5ID81XypD4KAzl+3ynhjWNPRf6fET3NIRF1j7kGdhVfSfq/hoC+yVfqnlYt9wYjdFVJzNy2lQhgWnhO7YXQJCjOAApJkTtJr+iRWJfxlXUFpSzD4KinvjclGc2zowBgJuSn1Wye28L6fAzle0PUF7YpaPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5zFiUf+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5zFiUf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B01F000FF;
	Sat, 12 Sep 2026 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206524;
	bh=88XgKo3S4qbqkStO8tGSMDYGrzK01UuglE10/+oUb4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5zFiUf+T2jvBgrKUaGXIMJhuy9bK7WYFALDKGsz2I7cjBrtfYlRds3qkD6t7i9TU
	 rHIDxzej0uHwOoc08i2F5uC6DUwGJ8PM0zR4/1Efe4IZaQ5SGKws8WT8nJTfXDhR81
	 h5C644rwuNbdsqnYxkASbYpYdjmpKpvfk1JrJCgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0223/1518] bus: qcom-ebi2: Fix clock leak on probe failure
Date: Sat, 12 Sep 2026 08:39:52 +0200
Message-ID: <20260912065628.532100538@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 64774dea58969194ea5c27fa639954e551a87024 ]

qcom_ebi2_probe() enables the EBI2X and EBI2 clocks before it walks
child nodes and populates child devices. If reading a child node's reg
property fails, or if of_platform_default_populate() fails, probe returns
without disabling either clock.

Route those failure paths through the existing clock cleanup labels so a
failed probe does not leave the clocks prepared and enabled.

Fixes: 335a12754808 ("bus: qcom: add EBI2 driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260620080406.1970447-1-ruoyuw560@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index be8166565e7cc..ab00c75b9e953 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -353,7 +353,7 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
 		if (ret)
-			return ret;
+			goto err_disable_clk;
 
 		if (csindex > 5) {
 			dev_err(dev,
@@ -372,8 +372,12 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		have_children = true;
 	}
 
-	if (have_children)
-		return of_platform_default_populate(np, NULL, dev);
+	if (have_children) {
+		ret = of_platform_default_populate(np, NULL, dev);
+		if (ret)
+			goto err_disable_clk;
+	}
+
 	return 0;
 
 err_disable_clk:
-- 
2.53.0



