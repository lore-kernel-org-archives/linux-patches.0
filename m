Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD073376A5;
	Tue, 26 Aug 2025 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214667; cv=none; b=MknP1I82ubM4mXmVABzk/WhuSVwwbxB0vs0CNSaa90zKezbWOrAPzAq6Aqmz0Gih2VidmWRjWo4BQY0eVQcnSC+DsbV231QpOsvCE3dX1GOqCd23vSizY16e+zVx2hJskXhkWEIMqLXtePuVcrg1BxV+tOZcKewRi1AUsg+G7MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214667; c=relaxed/simple;
	bh=DTd1JBAb+zfEJ6nneL0B3TYJy7VyzYO95Om9Whl9Cvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcDAciXSWt69dmgHjHnMO82nz9gKkxRU1WDAgq8AkTD6jVSgyYGxFB5LtIlIWwSxPNE/KeSVuo1+m40wLc9g31oQrW+HiURojQ53Dt7JmYhw8EXtsM1AEDzmDPTY7K0EDhHCRNPM9g0Q0OFkNCuIvwkvrmb7CzBd6TfmSidsibg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsBYtVLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsBYtVLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023F1C4CEF1;
	Tue, 26 Aug 2025 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214667;
	bh=DTd1JBAb+zfEJ6nneL0B3TYJy7VyzYO95Om9Whl9Cvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsBYtVLTrgx0oELG9DtX+JdOwTUtqcX8aw27UAfQjUSuViqiV1fRkwNqSqMLK13CX
	 wS89NrqSyJHJiaoptm2okaWCiDGSij95AyLST8l+a/GACQAZ0I64mm2twgpyfwOLVB
	 i3Dvrw4MxDx5NCFjaipSzaAD3Mgg755bWGtUryP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/482] ipmi: Use dev_warn_ratelimited() for incorrect message warnings
Date: Tue, 26 Aug 2025 13:07:58 +0200
Message-ID: <20250826110936.333293244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ec50ec378e3fd83bde9b3d622ceac3509a60b6b5 ]

During BMC firmware upgrades on live systems, the ipmi_msghandler
generates excessive "BMC returned incorrect response" warnings
while the BMC is temporarily offline. This can flood system logs
in large deployments.

Replace dev_warn() with dev_warn_ratelimited() to throttle these
warnings and prevent log spam during BMC maintenance operations.

Signed-off-by: Breno Leitao <leitao@debian.org>
Message-ID: <20250710-ipmi_ratelimit-v1-1-6d417015ebe9@debian.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index e4ac38b39889..653e07171dc6 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4618,10 +4618,10 @@ static int handle_one_recv_msg(struct ipmi_smi *intf,
 		 * The NetFN and Command in the response is not even
 		 * marginally correct.
 		 */
-		dev_warn(intf->si_dev,
-			 "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
-			 (msg->data[0] >> 2) | 1, msg->data[1],
-			 msg->rsp[0] >> 2, msg->rsp[1]);
+		dev_warn_ratelimited(intf->si_dev,
+				     "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
+				     (msg->data[0] >> 2) | 1, msg->data[1],
+				     msg->rsp[0] >> 2, msg->rsp[1]);
 
 		goto return_unspecified;
 	}
-- 
2.39.5



