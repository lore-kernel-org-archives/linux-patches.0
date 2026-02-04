Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE5410D10;
	Wed,  4 Feb 2026 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216250; cv=none; b=UtNBYu5HKp9+ut6i6NRIQmGzWQXavmNVjgqd4bs98OZX3uHjEOP9OgRQA+yXWyE8iZXxcVRk761KxpXPmnWB0cOqn+D9cwiHFOadfP/OpMyLN4bbZsBkjQhZ18eXfl1/InzRMwUujJjy6fy8e9eZX7Dm7qWxqAk2MdYVM8DQ/GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216250; c=relaxed/simple;
	bh=9w8dDEVjZ0VWQKu3hE/74SQeM/o0ThFeM2bLjjyesnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoMciSCueZxtneewXmvve1rNeaJdSOr1AH2py2OwpdMH56nYvCHnrMS0YqXkZFNWFAuAs10DVmmqw0WZqtzKOsFekViRv79vY2x1HUYqzdx8u7kYnaUiwg5LYRDI+isubrxzrynWGlSQCiOCMf5fRGljmLuoM/DP049ucY4bjtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxO1xuZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxO1xuZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D77C19424;
	Wed,  4 Feb 2026 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216250;
	bh=9w8dDEVjZ0VWQKu3hE/74SQeM/o0ThFeM2bLjjyesnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxO1xuZulM6vS04FsWeSgTREMKuaVFhQLize2J1KleplZbMmTIr/MZZPMJYladkgP
	 Ronpm2hO5L4f+XmebQzfylD/UT/khLJORkVVrX/dI2CEuIN5Hkql1IwxGKoAr0R6NO
	 cnAY6ulrkA4oKBZpG08WVZOLjMl+b9sUKeiq3R8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 025/161] usb: dwc3: Check for USB4 IP_NAME
Date: Wed,  4 Feb 2026 15:38:08 +0100
Message-ID: <20260204143852.668820391@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 0ed91d47959cb7573c17e06487f0fb891d59dfb3 upstream.

Synopsys renamed DWC_usb32 IP to DWC_usb4 as of IP version 1.30. No
functional change except checking for the IP_NAME here. The driver will
treat the new IP_NAME as if it's DWC_usb32. Additional features for USB4
will be introduced and checked separately.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/e6f1827754c7a7ddc5eb7382add20bfe3a9b312f.1767390747.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    2 ++
 drivers/usb/dwc3/core.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -778,6 +778,8 @@ static bool dwc3_core_is_valid(struct dw
 
 	reg = dwc3_readl(dwc->regs, DWC3_GSNPSID);
 	dwc->ip = DWC3_GSNPS_ID(reg);
+	if (dwc->ip == DWC4_IP)
+		dwc->ip = DWC32_IP;
 
 	/* This should read as U3 followed by revision number */
 	if (DWC3_IP_IS(DWC3)) {
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1142,6 +1142,7 @@ struct dwc3 {
 #define DWC3_IP			0x5533
 #define DWC31_IP		0x3331
 #define DWC32_IP		0x3332
+#define DWC4_IP			0x3430
 
 	u32			revision;
 


