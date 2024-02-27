Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6459E13A26F;
	Tue, 27 Feb 2024 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042779; cv=none; b=DIbQuOl6kjpvRKvJOlL69++NwaiikrRFkFck9Ibsn0+rL5HuJPavahEQez8rEfFXhX37LJ6BdOZkxlUjJo1J9ZeG0zEb/SAlq2TMloJNMQ86ICT2loCYxWoN3xRVfHcuZ0+/j94lR5qsk9BscRAGHc3D3DnUztYpS6QDG4P2Qj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042779; c=relaxed/simple;
	bh=YKknOHQda/mbDQ6xQJLZwEq6je9bbcVtaRGfBrRskj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGG1jydElR3LbeRZtWyONGE3+BZgnHtg1aBb+CaT7KTu+nD5M7d8fxTc315vF6vsew1dvEIu1nywE6Dg1A5Eoy6rb6iiV64CE0JY/RPtgze/RbediIpu7L4MH/q95iVI8dw/9sOBcPQ0xiWItcs2A4Tx2R9tjKQSNmO1cSomR9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhTd0IJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhTd0IJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D291C433F1;
	Tue, 27 Feb 2024 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042779;
	bh=YKknOHQda/mbDQ6xQJLZwEq6je9bbcVtaRGfBrRskj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhTd0IJJebDsqqxBqxVkoqZ1pPLJvYPjwB6zQKH48/GKZQF71ITin1wdCD1MQG9Zy
	 vu2CVaTqbq9rf8t2ZSq/T5oguOWjWlDxQAsp8klKQRZblz5DNW10axOJqaAJ1r3D/c
	 vzsSie7Rsu8z8uLljO96vUJX0CS3pqZyfPZ8fBN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ellero <l.ellero@asem.it>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/245] Input: ads7846 - always set last command to PWRDOWN
Date: Tue, 27 Feb 2024 14:25:05 +0100
Message-ID: <20240227131619.033496768@linuxfoundation.org>
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

[ Upstream commit 13f82ca3878db8284a70ef9711d7f710a31eb562 ]

Controllers that report pressure (e.g. ADS7846) use 5 commands and the
correct sequence is READ_X, READ_Y, READ_Z1, READ_Z2, PWRDOWN.

Controllers that don't report pressure (e.g. ADS7845/ADS7843) use only 3
commands and the correct sequence should be READ_X, READ_Y, PWRDOWN. But
the sequence sent was incorrect: READ_X, READ_Y, READ_Z1.

Fix this by setting the third (and last) command to PWRDOWN.

Fixes: ffa458c1bd9b ("spi: ads7846 driver")
Signed-off-by: Luca Ellero <l.ellero@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230126105227.47648-3-l.ellero@asem.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ef04988edf0c2..f416a4bcd72bf 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1074,6 +1074,9 @@ static int ads7846_setup_spi_msg(struct ads7846 *ts,
 		struct ads7846_buf_layout *l = &packet->l[cmd_idx];
 		unsigned int max_count;
 
+		if (cmd_idx == packet->cmds - 1)
+			cmd_idx = ADS7846_PWDOWN;
+
 		if (ads7846_cmd_need_settle(cmd_idx))
 			max_count = packet->count + packet->count_skip;
 		else
@@ -1110,7 +1113,12 @@ static int ads7846_setup_spi_msg(struct ads7846 *ts,
 
 	for (cmd_idx = 0; cmd_idx < packet->cmds; cmd_idx++) {
 		struct ads7846_buf_layout *l = &packet->l[cmd_idx];
-		u8 cmd = ads7846_get_cmd(cmd_idx, vref);
+		u8 cmd;
+
+		if (cmd_idx == packet->cmds - 1)
+			cmd_idx = ADS7846_PWDOWN;
+
+		cmd = ads7846_get_cmd(cmd_idx, vref);
 
 		for (b = 0; b < l->count; b++)
 			packet->tx[l->offset + b].cmd = cmd;
-- 
2.43.0



