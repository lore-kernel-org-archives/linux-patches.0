Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95E44AB91;
	Tue, 21 Jul 2026 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670271; cv=none; b=hZ0mHk1a1OGjfT5DjgeH0+lG6cTnwFYMBgpRRNaaa3zGgxgporLXBeTTUCkWmWA3ZgSwmXlq6Z7M/H9FrciKgoWDAjGauPovfnY98iYPsIn6ls98HNCgobH8QZxRODCUxwij/zcfDtO0RWNmuD2s9Hu1l9P0BdJbTLP326nOgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670271; c=relaxed/simple;
	bh=usFptnymv2/Na59sG9OSMaSLrEgPEEdWL9H85IXEA2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc1S63amO0Ha1eCmg9CfMnnYaj3Y2JCVXBaw49mbjp7eRvxDjoGHmoBl+O4qIvsdd9sMvO+2GELOZQ6LJ8Zd7ov2zrVaQaNR4BKzgUkXS+IwqqvEl6DmUNW3egP9Tn5/UuymUGNvi5kavb6lYPJWkNwRxG79+5avrvV/XW01VWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqHOoy+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqHOoy+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C7C1F000E9;
	Tue, 21 Jul 2026 21:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670269;
	bh=gshUN5gm45tV6hcFeHZJj6bB9P8jH9du4f+CWlEoh2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqHOoy+P49DmXDGDxynu+fNU8eb/Q2XsPU+oqF0K9PdUN2vwldHxJL3Pt3m82Yg5i
	 ws/2pZZTRvOwq/MHPrM8dNBzov1BsDZNcQhetExkU0Zxzmnx3/GDu0lpCKL9kUee4C
	 u7ooRnZDgzNnQYL+qIgQri0+jca7aAjAvhPxm9HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0868/1067] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Tue, 21 Jul 2026 17:24:29 +0200
Message-ID: <20260721152443.955845527@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 411b8c4b274737c3bf08e1e025801161603cfffc upstream.

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1173,6 +1173,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


