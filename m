Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1A322776;
	Mon, 18 Aug 2025 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524241; cv=none; b=OHwjbzwKa9/HAz4JR7KRN94Hcz3SggSTpYSL+hJdRr4nmsa8ROVsjFiZT8tttmCjNhHfn0tHl4WojJc6bhwmafxP956FhZ1rZW0qCOvAJw1WhktwOnfL3E8jf+LQxONuKoRcpbFdQG5gM+wk4TU4OZCQFx8QmOMOMjg+grQzsbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524241; c=relaxed/simple;
	bh=0A9Rm8Ux37cMr/EVm62Bn/cqIQhI+CP2ILd1wDxNinw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UATFQwU8YmbJV2sRXyEU3T4CVAGrhkSuJtnw595qjCWC+o5x9xun33AIOstCetrfUYzi8vFdFGjBckES2ROIVPyflFBhm0GwrMl4Mqo8PuHUIP0nkECsXse06Owpg9TTsGja8YNB+5bHndhJYwePQXj6uo23BqSoe9w4FJiBEFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcT8mOVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcT8mOVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5C3C4CEF1;
	Mon, 18 Aug 2025 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524241;
	bh=0A9Rm8Ux37cMr/EVm62Bn/cqIQhI+CP2ILd1wDxNinw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcT8mOVxwoOY6Gfl8tq5lDh3hnZAnT4fQrI3RtOAq7QtGx13GGGUpoP8gXsjP+Wn+
	 uo/z0LMMshaYMseZG6K/iX7qHATD/VYP3rJ77/9cI859JT2sjJE8/w+9QQMiNAhT4s
	 xinS/FU8g4p6hqiVWbi6Mt9GRVMDEaQ5MN5oE1nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 412/515] ipmi: Use dev_warn_ratelimited() for incorrect message warnings
Date: Mon, 18 Aug 2025 14:46:38 +0200
Message-ID: <20250818124514.277560372@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6047c9600e03..808d0d213509 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4615,10 +4615,10 @@ static int handle_one_recv_msg(struct ipmi_smi *intf,
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



