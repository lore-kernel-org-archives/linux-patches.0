Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7C3471258;
	Tue, 21 Jul 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657053; cv=none; b=YlS6m9mIHYTF1IevsjKttsLDjJPewHiUkXDupkJ6z6B9SZfYAv26keOvgoJhKb/N5zyj9HKx7pWHi5Vdty2X5NwCnGjohc27MYMrJXfVAEO0gcsPTPmq3bKR1L3A6wtz8NL2VWePyf6WunwJAT2OfseULGpcRhGDbzdroWWofhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657053; c=relaxed/simple;
	bh=eoA/kcWyvusFzKUJkmOHYs9LWq2hKIEKEd/X8ee3wqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+O2ovkLZrlk4swCmebDL6tRKcbw9+D4kCnO3WQrkFENYkXtRwQ/ZdBZw9CuLvGdv+CnlYFadi1J/muqlayw0fNwh3oOF05SnBSKpKotYYKZfdn+Qqy+aZPJSGmNDTo0qxKsJjpWUo5T6wkNViOn6lcps0CTjgsvatLdXqbdyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5V/J5qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5V/J5qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE2B1F000E9;
	Tue, 21 Jul 2026 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657052;
	bh=EpXfKRG9r0ps/hxLYgr6UvyrktwzBPdbacL6KM9BpeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5V/J5qxdtXrM0sd+cta1qQ64v5B8er6OH/ZfYXF++nrhcgrkkpYTgDPNRsbZx2Lv
	 HGLd5jzB1xc+IuKnH6PEP5md6MMrUUtg1LNPCJ0lw8/p8sOic5gLRmlxTnAv8s09wZ
	 YQboub0d7aJXkksod94w23Pta6v0xWjclHx7yUSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0620/1611] iio: light: si1133: reset counter to prevent race condition
Date: Tue, 21 Jul 2026 17:12:16 +0200
Message-ID: <20260721152529.332660442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit 0a5f45ed2342aabae1e32c72558d15be28940a95 ]

Sashiko reported a potential race condition happening when the driver
returns an errno after a timeout in the si1133_command() function. The
premature exit causes the hardware and software counters to become out
of sync by not updating data->rsp_seq, therefore the internal hardware
counter keeps incrementing.

Fix this by adding a call to si1133_cmd_reset_counter() before returning
from timeout.

Fixes: e01e7eaf37d8 ("iio: light: introduce si1133")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260428-si1133-checkup-v2-5-70ad14bfefe2%40gmail.com
Assisted-by: gemini:gemini-3.1-pro-preview
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/si1133.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/light/si1133.c b/drivers/iio/light/si1133.c
index 44fa152dbd24c2..c88c79202be2e2 100644
--- a/drivers/iio/light/si1133.c
+++ b/drivers/iio/light/si1133.c
@@ -427,6 +427,11 @@ static int si1133_command(struct si1133_data *data, u8 cmd)
 			dev_warn(dev,
 				 "Failed to read command 0x%02x, ret=%d\n",
 				 cmd, err);
+			/*
+			 * Reset counter on err to prevent software and hardware
+			 * counters being out of sync.
+			 */
+			si1133_cmd_reset_counter(data);
 			goto out;
 		}
 	}
-- 
2.53.0



