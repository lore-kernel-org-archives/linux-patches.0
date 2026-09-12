Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE0E2ECE86;
	Sat, 12 Sep 2026 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229155; cv=none; b=SvdfvO9+9LG7O4oZfzUj5I8N3Mrnq35EbZSHk6FlyjObQySBsyyE9bzgzJvKJ6t++RuDi42HO57hsVgGbxQSF/vRO6sfLnB3sdEiJ3kKwB6ctJbD54L0ExQY3+6EDm6mpuc2wnPFgjEnB/sOzDfDWjYV+SZ5d8PJpjMU3cmZqqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229155; c=relaxed/simple;
	bh=6XRSe03iM9st4odtr9harnqWOp5yJFFsyOMMVOVbXC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB20J5HAgJYEmOyitvxUA7xqbmlQtaY+c9q/rD2ZRBjXvl89qOGr8/gt4vKQjlsLvLYIxj/cL0+i77j26NS9AAn6vyYNQi7GtfdPeJtEDDvlr1RDwy92OEEge/+PkdfFT4wQCXn8nS4BMo4GKaK4PsfY0mnD9ruqoThmCAXOnR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+nH+hlz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+nH+hlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4801F000FF;
	Sat, 12 Sep 2026 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229154;
	bh=5W91PcJN8REpvU/9EZdnEJplwhKjxpXZ5Ym0DjvIytI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+nH+hlz4QHfqg9DjSy8ThzS53hOcDLopcRN4wUiGjTMrg6fBO+oML211MsMxhZHn
	 9Oiuk2tqwGecIdsMGNbAp6V2503eKfmenHOKJ43WLfMjfUgtwUKsxEduk2zDKfB0ra
	 didwTk8Hl7pITbha8t8OqMNpw9xoh6TJfwgyT9m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0532/1191] bus: qcom-ebi2: Fix clock leak on probe failure
Date: Sat, 12 Sep 2026 08:54:20 +0200
Message-ID: <20260912065600.199655069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 8375d33674660..fb0f59da1abdf 100644
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



