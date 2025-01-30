Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E611E7C25;
	Thu, 30 Jan 2025 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247104; cv=none; b=fE+3H6CsuAQvMegY5GfZCOWY8odjIdKj7hgklA7U0aQ+l8iue7GzWPmipvkypfkVcKoMubpFRLiBiM5v9Z+cJVoM3WmYlDXCvDgUXNvo5SjVALp6M5W77VkJYMrFVp0HZs0eaxgcHy0fgjWJAe0YOJSgVMMvx8iqbL/dR9qPXDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247104; c=relaxed/simple;
	bh=o1om8vZ1zM8bj6JKu305gbA11jzxEtMv9cMks/6Xeb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyLjGxrbNTnnIjvOzscazqqfCK+UrojqSDrRgJ4H543BwZ2ccirDK/ESRIDxv/Vapa/v/7eKd/DOzYJlRzaP9WWXfBfNKFpulxvMoqwh+iQo2l+vvMVP//4lBjYFCbHqzbqhJIjSrcMYnfmh6HOZa1lhHQkJd/Bs2qIwOzY5V78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeKgDhEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeKgDhEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8098DC4CED2;
	Thu, 30 Jan 2025 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247103;
	bh=o1om8vZ1zM8bj6JKu305gbA11jzxEtMv9cMks/6Xeb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeKgDhEsmemCCC/h9OLa79axKnguzKV9fWHZFVjgaMgP+CHWW9C34Tuh8KW/h1lM3
	 vqyMX/EIubVvNVXMHkM5TatKVEqs4DUEPXy9ejSlrQlnvpsnB97ppilwaOLJDKKEVP
	 /jDXvq9MpDILpaAwEmjYuA/1hmVnawkq9OWjfs+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/133] i2c: mux: demux-pinctrl: check initial mux selection, too
Date: Thu, 30 Jan 2025 15:01:12 +0100
Message-ID: <20250130140145.861991983@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca89f73394daf92779ddaa37b42956f4953f3941 ]

When misconfigured, the initial setup of the current mux channel can
fail, too. It must be checked as well.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 45a3f7e7b3f68..cea057704c00c 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -261,7 +261,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 	pm_runtime_no_callbacks(&pdev->dev);
 
 	/* switch to first parent as active master */
-	i2c_demux_activate_master(priv, 0);
+	err = i2c_demux_activate_master(priv, 0);
+	if (err)
+		goto err_rollback;
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-- 
2.39.5



