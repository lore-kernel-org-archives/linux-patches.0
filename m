Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F9A35C6A6;
	Tue, 21 Jul 2026 21:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669270; cv=none; b=IFNL3cqHcTcvbMMHKGW7b6JqgHrOCEE32r799146RHVUdm/dHaL7YcmO9S/Bi7SQks5bvFl/tAokdF4rSMU7p6dQtBGnr0BInk/FRl8l2mTla4zZtndyXfTfwLF2id1+4y5eqpuXNqzFgjHayOIevy2UVhhVk+DZZFP3t5ASjzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669270; c=relaxed/simple;
	bh=Hpqa10hZX5nPfLBLUGToi1/GydJ3l5r7/sQng7j8I9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEJzKjRTeUIDeCTxaPqm+K2R56UBZT59WBnKDw3IoP37rblylYxEmebDEgc8j+Pgrf5FErMS29o7cDGcqAgnTshQPQw+mTGUi6ZZmUqN1IiZAhibgpz65KJlyGNdtn5PJIj1T/YUE+PAk5b6ogtYyreCN1eY8aboo1hl8dkeEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppPSmCPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppPSmCPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91971F000E9;
	Tue, 21 Jul 2026 21:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669266;
	bh=2VEKYuz/ScNoTe1UjB1k9+FnMy0AJZ/WrYTnrtRgbwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppPSmCPFtdZ9n3lUQhboRN/a7EcpmvbRjmGGAdJGqQlo9/HueDyVrwylKzUWAQObW
	 rRl1jqoc3oyZOKosDy8qdttckgl9PPmiJwjwbXf0Vi/Q4zhIiouNlCjrvhwfISpLSy
	 dB4aitTAqC/ztH3MlzRR4KrqlpnlkVmEkngy3MjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0490/1067] iio: light: si1133: reset counter to prevent race condition
Date: Tue, 21 Jul 2026 17:18:11 +0200
Message-ID: <20260721152435.577015105@linuxfoundation.org>
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



