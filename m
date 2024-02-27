Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BB91420A2;
	Tue, 27 Feb 2024 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042770; cv=none; b=kGhf1mb30j+UhKMwe0o6Q0Rewqgn3GoAwEYuvwSsrHMRrCQuobULBTI4v7J9eV4WQ5VAn0LYZwzoiJWNd9dDwbbsoQjJmY7K5nO1JsrBwLX3z9/yX5N3cHdnD3VpRHucV/miR7OKTGOFi/CwqbaXAObrMhCpOA0ek5l+F0UQ2rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042770; c=relaxed/simple;
	bh=BKgA6fne44q9lqXFm4PwbVks4XTM+cJca8xwMKyOYW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRXf4VVXMYPIZyBpittL+ExpfN1VHmtkubbGM9V6oLCe+NkBtwRH7YY6se4gCn/ndtqxwuSfSWFl65QAZ0VewiGQM8JDBqPF6lZwfjDfLKNbpR9QaWCQVwJE/ktes+4WFC7q/O4tPbHJvGIj26mCZE2MKg6EMz//PJva2DiHpOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2RNFDF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2RNFDF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340DFC433F1;
	Tue, 27 Feb 2024 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042770;
	bh=BKgA6fne44q9lqXFm4PwbVks4XTM+cJca8xwMKyOYW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2RNFDF04ySIss9FcpH1O1CyMXvc5tubbe905UZ3F7stCFTtCZbFpq9Cfb+y2Q0sP
	 pIBPzC37CwCIoQTA0H6Ja6JDzMq4D7S+DNd6BZaCxTMaKhxZiBtL1BD6ufM3ifcPQ5
	 AlbNTL+F8MaJAq02d40Rr1OlRYJ1ONQWxLdR6vnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ellero <l.ellero@asem.it>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/245] Input: ads7846 - dont report pressure for ads7845
Date: Tue, 27 Feb 2024 14:25:02 +0100
Message-ID: <20240227131618.941903703@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ellero <l.ellero@asem.it>

[ Upstream commit d50584d783313c8b05b84d0b07a2142f1bde46dd ]

ADS7845 doesn't support pressure.
Avoid the following error reported by libinput-list-devices:
"ADS7845 Touchscreen: kernel bug: device has min == max on ABS_PRESSURE".

Fixes: ffa458c1bd9b ("spi: ads7846 driver")
Signed-off-by: Luca Ellero <l.ellero@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230126105227.47648-2-l.ellero@asem.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index f113a27aeb1ef..ef04988edf0c2 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1323,8 +1323,9 @@ static int ads7846_probe(struct spi_device *spi)
 			pdata->y_min ? : 0,
 			pdata->y_max ? : MAX_12BIT,
 			0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-			pdata->pressure_min, pdata->pressure_max, 0, 0);
+	if (ts->model != 7845)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				pdata->pressure_min, pdata->pressure_max, 0, 0);
 
 	/*
 	 * Parse common framework properties. Must be done here to ensure the
-- 
2.43.0



