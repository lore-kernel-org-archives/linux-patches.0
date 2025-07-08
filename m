Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D093225414;
	Tue,  8 Jul 2025 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993573; cv=none; b=J0K7keNzdol/xDViwEfYz20LPlrUypmsn1lVw8VP/3Hig+CsNilPVfpDvB2FWq1pZaKeqeNB38pAiYX7uuVP0F4wY/ZdyWM4bTt/O1n4eKACN0EZ9E4worZG35X4sIT7N0HpCI5PBtWshdNlfj1xSx+JjGCIAtUTR7uWAqXs5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993573; c=relaxed/simple;
	bh=kXOdr1Lo8/epfWCeWs1+chvNjdHrkCxA0FFaaDj9Wiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tejEUR7X2O9KADEl40kd7UosS6uvJ04W19Ppt31brdRn806Vsj33zOAwuvbl2YZTj6PA0zlJ9GnSG5yVCiyZyuOMq2DI5Y8B7zyIhCsORrJZa/FpoNYvle2m7urtqYdf3D9W3luS0+lmrpe9ukDWF10fmQLf18IL8mAWrgkbWeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMBX9W5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMBX9W5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BBC4CEED;
	Tue,  8 Jul 2025 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993572;
	bh=kXOdr1Lo8/epfWCeWs1+chvNjdHrkCxA0FFaaDj9Wiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMBX9W5m3vonHRp1mtrwsOoQLojrrycCa4XEpI8iC8JJQB9x1PNwjmdX8kpx1PS6J
	 lA47BlvLtVochI6rZkjokW6mHxtXOCQeMlNpnOWlHg7AkyZPemdjFThhwiQ6/PsDlY
	 y8hzm6mOlwP9k+QTjz9Pp4fy5jj5g4vHW37AHDDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Blaise Sanouillet <linux@blaise.sanouillet.com>,
	Suma Hegde <suma.hegde@amd.com>,
	Jake Hillion <jake@hillion.co.uk>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 121/178] x86/platform/amd: move final timeout check to after final sleep
Date: Tue,  8 Jul 2025 18:22:38 +0200
Message-ID: <20250708162239.760057815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jake Hillion <jake@hillion.co.uk>

[ Upstream commit f8afb12a2d7503de6558c23cacd7acbf6e9fe678 ]

__hsmp_send_message sleeps between result read attempts and has a
timeout of 100ms. Under extreme load it's possible for these sleeps to
take a long time, exceeding the 100ms. In this case the current code
does not check the register and fails with ETIMEDOUT.

Refactor the loop to ensure there is at least one read of the register
after a sleep of any duration. This removes instances of ETIMEDOUT with
a single caller, even with a misbehaving scheduler. Tested on AMD
Bergamo machines.

Suggested-by: Blaise Sanouillet <linux@blaise.sanouillet.com>
Reviewed-by: Suma Hegde <suma.hegde@amd.com>
Tested-by: Suma Hegde <suma.hegde@amd.com>
Signed-off-by: Jake Hillion <jake@hillion.co.uk>
Link: https://lore.kernel.org/r/20250605-amd-hsmp-v2-1-a811bc3dd74a@hillion.co.uk
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/hsmp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/hsmp/hsmp.c b/drivers/platform/x86/amd/hsmp/hsmp.c
index a3ac09a90de45..ab877112f4c80 100644
--- a/drivers/platform/x86/amd/hsmp/hsmp.c
+++ b/drivers/platform/x86/amd/hsmp/hsmp.c
@@ -99,7 +99,7 @@ static int __hsmp_send_message(struct hsmp_socket *sock, struct hsmp_message *ms
 	short_sleep = jiffies + msecs_to_jiffies(HSMP_SHORT_SLEEP);
 	timeout	= jiffies + msecs_to_jiffies(HSMP_MSG_TIMEOUT);
 
-	while (time_before(jiffies, timeout)) {
+	while (true) {
 		ret = sock->amd_hsmp_rdwr(sock, mbinfo->msg_resp_off, &mbox_status, HSMP_RD);
 		if (ret) {
 			dev_err(sock->dev, "Error %d reading mailbox status\n", ret);
@@ -108,6 +108,10 @@ static int __hsmp_send_message(struct hsmp_socket *sock, struct hsmp_message *ms
 
 		if (mbox_status != HSMP_STATUS_NOT_READY)
 			break;
+
+		if (!time_before(jiffies, timeout))
+			break;
+
 		if (time_before(jiffies, short_sleep))
 			usleep_range(50, 100);
 		else
-- 
2.39.5



