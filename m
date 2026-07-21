Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB8D35C682;
	Tue, 21 Jul 2026 21:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668148; cv=none; b=Xtd213ZXVk/ybwUdsmc8gbfh4XxH0Y4k+2rOu7QzrkztYVlPyNkb4P84z48uz94qCprYfbqkj4R03XS9bRLkqvEfY9s+qlIJmC8HklqOlsf9JpSj1I58NnqtbBkDS7z8RDEhxwEuZYHwie0Gy218RGiV7EWfLnyBp8OZge3oMXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668148; c=relaxed/simple;
	bh=vZur591eILzyYVYovxc4i+II936UuauvXE3I+5DG1AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiBsdPj/u/KjsHMH6YjORBcRaU7Y0mDEL0hH/pz574uD/PeSSPslrN5UTaqAwwc/Z0VxyymHKBZ9f/Z+OaeV3icftSIsZ55891LOyPAEe6V5MwTb3D6QiUaZHtAKHLKJGXzjBvrARxPeDbPyh21b1C6CW61HX6+FQ40ewnqzjDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdHN0Suh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdHN0Suh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8421F000E9;
	Tue, 21 Jul 2026 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668147;
	bh=ZBnkqbfV66ih1vUXu3aUleF578cjE57N9wDhcUCjMpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdHN0Suhyic84tyxQkd7Ru05q5gq54bBS1sLbR9Joel5Yg/gULBQlA1kHKRlSPXl3
	 EAP/13uSY7jiZODwiGnKuc2VjS1NUp0fcMhkITWWab4NZa3oj80Ad33yyWRPm+Q9Nu
	 euLohDvtZyxt4mrlZk0+ABqUip0trM7gA13MgCQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0067/1067] iio: light: opt3001: fix missing state reset on timeout
Date: Tue, 21 Jul 2026 17:11:08 +0200
Message-ID: <20260721152426.069859024@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -280,8 +280,10 @@ static int opt3001_get_lux(struct opt300
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


