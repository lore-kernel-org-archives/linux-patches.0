Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9061358D19;
	Tue, 16 Dec 2025 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887717; cv=none; b=k2kSzdy9jhPrHP521Otv3E9s/UMGaThfWyxEHALpuV86S9vSTShlZIrJVGLpQ1KmThqOghIo7I5ojcvXd7KHcx23EqYTKFb2HvbRE6tCJ4U/pu0+7RR7dKT1fOxQJhUXVFfVKNtasuokgIgaCDP+ltDAUdG/xyn/QMe7jd8GROs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887717; c=relaxed/simple;
	bh=vAWrhOe+KGotFrkJ3TG30T2PHaGaHLogpzJsh8BWyME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SABPcUVdKb7Ve+xX/V8QWaOXpfdS6KAdbzdXN/eQyYwy4/KVHjmbHg623NC+dLXg/1vC8aFuDY8kldQtKDeGN6RwM/mkqMGbbBNBKVuxCb5nCssEaX49r5S84tsmFpibxgs1eVh0HRiXw5SSUt85RtmrFU8SCdo+qI3r2nLqrWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLenhd8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLenhd8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A3DC4CEF1;
	Tue, 16 Dec 2025 12:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887717;
	bh=vAWrhOe+KGotFrkJ3TG30T2PHaGaHLogpzJsh8BWyME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLenhd8vK5S/e2ytbTyrAAsRjnUM6kKXFr8mhGfJLk6l1tanwQMeXuYunD2dQqHr+
	 PH2N/FCu8c1mPaT4dITbKlKf5WuoNFxWb79AQDonxpQ4Npe7psRYnkk9CYlJ8LobMD
	 akFKo34M10cP7RY0ZL+5wBU3faKi7LLIRGBnpwDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/614] pwm: Simplify printf to emit chip->npwm in $debugfs/pwm
Date: Tue, 16 Dec 2025 12:10:50 +0100
Message-ID: <20251216111411.626957771@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 3cf8e55894b51c14f8500cae5e68ed48b1b0f3fd ]

Instead of caring to correctly pluralize "PWM device(s)" using

	(chip->npwm != 1) ? "s" : ""

or

	str_plural(chip->npwm)

just simplify the format to not need a plural-s.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250926165702.321514-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Stable-dep-of: 5f7ff902e7f3 ("pwm: Use %u to printf unsigned int pwm_chip::npwm and pwm_chip::id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index ea2ccf42e8144..5b75f4a084967 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -2696,11 +2696,10 @@ static int pwm_seq_show(struct seq_file *s, void *v)
 {
 	struct pwm_chip *chip = v;
 
-	seq_printf(s, "%s%d: %s/%s, %d PWM device%s\n",
+	seq_printf(s, "%s%d: %s/%s, npwm: %d\n",
 		   (char *)s->private, chip->id,
 		   pwmchip_parent(chip)->bus ? pwmchip_parent(chip)->bus->name : "no-bus",
-		   dev_name(pwmchip_parent(chip)), chip->npwm,
-		   (chip->npwm != 1) ? "s" : "");
+		   dev_name(pwmchip_parent(chip)), chip->npwm);
 
 	pwm_dbg_show(chip, s);
 
-- 
2.51.0



