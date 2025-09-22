Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61501222590;
	Mon, 22 Sep 2025 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569720; cv=none; b=CaS75q1XtR+Yc+xWikQ8GU124LwBGJXOLDFjo6wS2fvnQO2F8ywDzLCYnCl06bfJhVc0aB5bgvwTwpZoszM2fMu9I967SzV1/yy3x3ck60BfScVAo6PCHJmEISBXC21EqWBiagpJB0KkvWaEokj1wme+ZI7+Q2X7WYN9GDbm4c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569720; c=relaxed/simple;
	bh=yAVwn+JgasPGAw+TXdG3vOwmEyA2eL7aa24rTkr+QgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FshI14Vrt9csvo6gGrytfjMWiAk3RJY759zGdjz8XqJ/oOuS3TyTQ975rpaUomW6Wt379S+CO5Rw883ntcNhIVA90j9llfPodEeZR4oWwrndy5VC4oreHJ5Mij6ahoxB0tB70wZuQdjyVsQA3sKL7513RSBi6u6HREzS/L8Cw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVGottpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVGottpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB417C4CEF0;
	Mon, 22 Sep 2025 19:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569720;
	bh=yAVwn+JgasPGAw+TXdG3vOwmEyA2eL7aa24rTkr+QgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVGottpbXcbWtSY7S0ahoUgh3/7vI8c3mAH1HfpXG7rge2ePv3jhYGfEgSajHYI+b
	 A6XAxRoJJILvnevFJd2MG4uiJKvBMfZy0u2JRxUGupMGGhfdvevJ/+3EIlbtsY4Fny
	 +VI2OVezKkbwDfddXgTQh/4SIiWn5nXhWzEF3Nfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Lv <Jerry.Lv@axis.com>,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 31/70] power: supply: bq27xxx: restrict no-battery detection to bq27000
Date: Mon, 22 Sep 2025 21:29:31 +0200
Message-ID: <20250922192405.432094799@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1872,8 +1872,8 @@ static void bq27xxx_battery_update_unloc
 	bool has_singe_flag = di->opts & BQ27XXX_O_ZERO;
 
 	cache.flags = bq27xxx_read(di, BQ27XXX_REG_FLAGS, has_singe_flag);
-	if ((cache.flags & 0xff) == 0xff)
-		cache.flags = -ENODEV; /* read error */
+	if (di->chip == BQ27000 && (cache.flags & 0xff) == 0xff)
+		cache.flags = -ENODEV; /* bq27000 hdq read error */
 	if (cache.flags >= 0) {
 		cache.temperature = bq27xxx_battery_read_temperature(di);
 		if (di->regs[BQ27XXX_REG_TTE] != INVALID_REG_ADDR)


