Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB841AB6F1;
	Tue, 30 Sep 2025 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244208; cv=none; b=npmXGz2l0dmp0A8YFzHOTknvtcyQxZzo3O09+vLY0aK8skZxq//3fHTYrJnmHqrnTfmWoI0it4U8qcfrvU/il6vDDHUxY3PZihkFCED8p0tJm5ypbTevKrBYpc14BDMnI1xfqyrtnZ+A38G2kERG3NBaMefbyr601O3unFm4LB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244208; c=relaxed/simple;
	bh=y9JfZ05l5ZrrOTpnWM2bc0spmM7Il9fGgiWfUKnIbRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tET5euxbS4yh5XBil0lGOVn0R1dagUQyeZeDVo/zJOiffAT4smxSwCQgycnlu65SVwk8kOpcycztBbB9Pa3erQvTCkTdEaih3zB/HNSpHuQWL16Zijx8MQn2UksRoSN+erAFwtd5N64iUMWsauF9mBdWGSf3QJhmf2RHABIYhjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiB7G1fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiB7G1fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25439C4CEF0;
	Tue, 30 Sep 2025 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244206;
	bh=y9JfZ05l5ZrrOTpnWM2bc0spmM7Il9fGgiWfUKnIbRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiB7G1fra3cshbH8AafXLBBuYbnIKWEH0A4Jm5MlrCgSK/wProNwFA3SfbC3pZMZf
	 z0WvZWzcvzzSs8js1xWmOZ7ZHrI1RFj92XOoDRjK/QhGtXhQwMIgcbXS139XSKzVdT
	 2k+LwWEhgSk+7tQUFpkjAEVYODnAvOmL9DQxEgoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 060/122] power: supply: bq27xxx: restrict no-battery detection to bq27000
Date: Tue, 30 Sep 2025 16:46:31 +0200
Message-ID: <20250930143825.453690230@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 1e451977e1703b6db072719b37cd1b8e250b9cc9 upstream.

There are fuel gauges in the bq27xxx series (e.g. bq27z561) which may in some
cases report 0xff as the value of BQ27XXX_REG_FLAGS that should not be
interpreted as "no battery" like for a disconnected battery with some built
in bq27000 chip.

So restrict the no-battery detection originally introduced by

    commit 3dd843e1c26a ("bq27000: report missing device better.")

to the bq27000.

There is no need to backport further because this was hidden before

	commit f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")

Fixes: f16d9fb6cf03 ("power: supply: bq27xxx: Retrieve again when busy")
Suggested-by: Jerry Lv <Jerry.Lv@axis.com>
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/dd979fa6855fd051ee5117016c58daaa05966e24.1755945297.git.hns@goldelico.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1828,8 +1828,8 @@ static void bq27xxx_battery_update_unloc
 	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
-	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -ENODEV; /* read error */
+	if (di->chip == BQ27000 && (cache.flags & 0xff) == 0xff)
+		cache.flags = -ENODEV; /* bq27000 hdq read error */
 	if (cache.flags >= 0) {
 		cache.temperature = bq27xxx_battery_read_temperature(di);
 		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)


