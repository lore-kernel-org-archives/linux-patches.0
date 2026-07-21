Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60386435532;
	Tue, 21 Jul 2026 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671808; cv=none; b=Aq9rQkxylFJM5VbVzS1zNz/muSEUcG0p57jUtBJU4rxejtAezKDonxyoaYDGJmqM9vCPzKX7Wcq6jGg06ccdGzUFPXNtFDdpiNyLZ+CcG+pRf4pDcV4RmeyaZZZD0vVaIHsuHhhIgYLYMzweSxZh6kxLTly2T8SrNGG2uzxLhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671808; c=relaxed/simple;
	bh=OrvbZeBW4CZ/CtWHjekAAJr6UImrS3crwqO8RyzO7hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gab/CU048eJ4GcmnSRDmHhf1TWr8U7wZkrxGsw6SQ+tpmlTyziS1Ql/nCCGokSRYpyuv9/px2SFTJZOU9QC7+gEG6KT8OBtD6LkMvn7TcScPC65jmd4P5LSi4BGzlBeDzTMev7XcOZDXrccoQwBGFtQfnTPZrjr87S9lDmC12zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMtSP1h8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMtSP1h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7516C1F000E9;
	Tue, 21 Jul 2026 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671807;
	bh=2Z+skCLmerUGb746NHDlj2VcWhsUEO7OAala7TOsaiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMtSP1h8sMYNlJAQUj0BQziQtJXy8sGtmE1+DE0PKyxpBnR6ccHSRgaD0dK3RWfyU
	 hIe9oz5vm98dYOqW+n7nVgEMzpGZV6d7SVLfgjM4y9CoRPcpWqNZBD0+c6dqIM8i3w
	 Ofzs9O6xWFrvVtEbdIjRebVlptZWdB9v2zJWYHmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/843] iio: light: si1133: reset counter to prevent race condition
Date: Tue, 21 Jul 2026 17:20:20 +0200
Message-ID: <20260721152414.698142630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f8c9b2cc322e8d..17ee203d16a274 100644
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



