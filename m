Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CDD43E495;
	Tue, 21 Jul 2026 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673773; cv=none; b=MO+VBTJsSw93Vo10gIhDdDZopTnlqBBCJ6tGVSIhLU+mxK/TrHwqJ8QemPaqR5xImkY+Vjs9pS7GPmuMp0Qu+FTD0ZvE9wOL1OqQKiAf73NTsQdmeVkBY2bHakRqH49hDlgmxFepY2xJgm+CC7lVoHXmxVhs/GvuMqq3EIdJANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673773; c=relaxed/simple;
	bh=z7CcznbMIP/nXz+PUgIcEzGmTgMwMqU1NYNRuagWlMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDsnjKpDRlQvTK1QhBCDskDTcq1W8VR+vmlxjdeNs/zofQHL15gewr9GLWD+GkXwrGrWRJeAnwQ87olmFCOasF6hbe3C67GStFc381/oVxop9wSfx6MDw0UyADaUQJ9NFaqKmWwuqXZqesPiQQ3g3M6rar+c90biTD+oJu5GdQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKNn4enC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKNn4enC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92C61F000E9;
	Tue, 21 Jul 2026 22:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673772;
	bh=Q8hKfX/lRFrIfo38EvnZmjIETlQWLIiDvrPFdn6E05w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKNn4enCrHR0kFHpUy72gEASY5+IsIz8w++qyXtLgGPCTb0pr/BSJj02ZTg26M+If
	 Sa1Rg6fK7oaEHAdx9Humj8mXWDbOTOhoeIXq2emhNeH6JrAE+6R+XNa9xklo41iBjq
	 dBvO43NoBpJWRMrkjSZmwK9tblNGo9qjfL9ye73g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/699] iio: light: si1133: reset counter to prevent race condition
Date: Tue, 21 Jul 2026 17:20:48 +0200
Message-ID: <20260721152402.219008657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c280b41950036a..02d1882cdfdf0a 100644
--- a/drivers/iio/light/si1133.c
+++ b/drivers/iio/light/si1133.c
@@ -427,6 +427,11 @@ static int si1133_command(struct si1133_data *data, u8 cmd)
 			dev_warn(dev,
 				 "Failed to read command %#02hhx, ret=%d\n",
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



