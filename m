Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69412F2617;
	Mon, 22 Sep 2025 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569916; cv=none; b=gPPv++gREzzp5jyhBalQRsrMNlU0RX55wU9r0sY4C6z+hMO4RjbGeHxqBPUArlSPVhjoOpcYVorO8SMhcheZvFZOVxzx+IA02MXYQ939G4TzUQyS0AeE9LKsLaJTco+uLNmOquwiXejYnKbl2lxlJm6owdUnTd0H9NbILFVTpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569916; c=relaxed/simple;
	bh=VlP3k7yT8JTI0S+TGL/Lqq9Jr/NqxERy2LXgwjsu4CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7+OfnuojzH+opnyb1UKALkbBrYsyL9znNirzbNTfOtfDzfNOcnWHK1GpRs+uQQs2MrnKHkY8B+8XlUKD56WlEd/ucvOLF96oG/jung8e/l5EKnQCX4IP+CsQbGaDUkSU+0FfsMS/80t4vOVsSgNrM98V5BbGzSNkTQn/t8bOko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PentoVJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PentoVJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D27C113D0;
	Mon, 22 Sep 2025 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569916;
	bh=VlP3k7yT8JTI0S+TGL/Lqq9Jr/NqxERy2LXgwjsu4CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PentoVJfN3XfBwF41HJ0x7C08/DgVN0+IUd5vW6Jhj5Ee62QFvl/J8Jh2zLIqoMtI
	 Ts8Uo4xYRJ1feQVIXO6nJODmaJpg1w5rrL84lA8wFOzafDUDvYg6mF5FCIDOOt7Gmt
	 sfYMhWGYjtLGB1km4qqPAihWciWRHjrn37+omtbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 039/105] power: supply: bq27xxx: restrict no-battery detection to bq27000
Date: Mon, 22 Sep 2025 21:29:22 +0200
Message-ID: <20250922192409.938927963@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1909,8 +1909,8 @@ static void bq27xxx_battery_update_unloc
 	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
-	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -ENODEV; /* read error */
+	if (di->chip == BQ27000 && (cache.flags & 0xff) == 0xff)
+		cache.flags = -ENODEV; /* bq27000 hdq read error */
 	if (cache.flags >= 0) {
 		cache.capacity = bq27xxx_battery_read_soc(di);
 


