Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022F43B6C1E;
	Tue, 21 Jul 2026 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666285; cv=none; b=ZtTcCWOT+dlj/mQzXB4JI3TOUpOJv5zoKUno0kN0Ip+WSApF10C8wq589qv0Pa0reH8z37yQU5x6XCbQ7EtIiF0MkBpbqZXja9XwmwzMXQ4WVDgkky7afBkJrDCQ7yXpFw0DIr60apkhDG67r4G/nhgOpWQYsfaeO8C08+OeaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666285; c=relaxed/simple;
	bh=WhOF/FeSqnLRc/9Nh3HZKCV6TU0XXrVx/ujvhzaZ2Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHIfFjBa3t9EAJKbF23MZX2vxBUlMKhbPXuYcauX39IjezfJ8962ZaMpq0u1KtvTPFlF1QAW19o9gf3lGBrMhbI0qfhV73AYyZQlo9jeVrUfLpfJfflVEu3AoC/3hNKo7aCEBRsA1WvVVIK4i+peRH1D0YXO7gG3BmoQ5JJOBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMMyWBZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMMyWBZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8086F1F00A3D;
	Tue, 21 Jul 2026 20:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666280;
	bh=MNWA57lT6p54IevJSmSt8AACfLOpjaRiqfXQGFP7y7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMMyWBZSsOhRyXBzZQOpsWNu5APBsBJRbd4dFcmupVEyow9V4DKlf2ctVeZM/aWQq
	 3dGuPmNtZOWY3rG+Yxgmp+r7V47+LEPgL9X1aIwOBLCzM1ZNr+T1VGQVWsKWnCkD4X
	 se59d44T6zoy4OGIbpdD+vd/NNc9J8EW78dMiDCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0623/1266] iio: light: si1133: reset counter to prevent race condition
Date: Tue, 21 Jul 2026 17:17:40 +0200
Message-ID: <20260721152455.804001198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea2c437199c0fb..ce5afd74e6e2a5 100644
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



