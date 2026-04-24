Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF7A179A3;
	Fri, 24 Apr 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037811; cv=none; b=SRZnmm4J0HvifX0Pp9DAHt3CPowO/Kx7j++MQ3TCQX5VohuOKhlGXLg62oBv8tPL5CCO81eHUmg7cUsDDXyd41vFR6Q3fhd0NZ9vOdYCvefQ+FKNQKE3KYOBZHPZ5epkygafvb5jGR8P3EABmAMSJ0yqxGInZ8ld6CsrbGHNYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037811; c=relaxed/simple;
	bh=z5nsRugr+M74K4WQl8vWPvDkc0SA7NvjmQz9Rr/htUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRZ3Z+3LRg7mq5iwsW4Ik0587gDo0+vjMwQ+WRo61P5nQpo0aQ9dqJNFJ+wgatkhtsAmBkiMGGjoVo8hhfU8bCyKLqG+yGDYyytBUKykkUDmCYtb5BknYNnaHsV7AfKQ88KhF0XrX1AjcightYWKqNCOIuLNAJ8fx9btPz4CltM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMZXRgm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMZXRgm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CA2C19425;
	Fri, 24 Apr 2026 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037811;
	bh=z5nsRugr+M74K4WQl8vWPvDkc0SA7NvjmQz9Rr/htUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMZXRgm0ZmZkH9FLN+UkMwRm5BS2TqkEc7ryJVZ5rW/kDw7jeZDHJJAab2g5t5gNy
	 F2E/fydsjHd1/fQG5zbImV1gqMB7Nt4337+7qBK49n0mN/SzrkYljSqh/IAg+SakMf
	 Cf5vPUlU75qDhFSbOCCRK5S5i/2yziYP3Z3a9x8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 077/166] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Fri, 24 Apr 2026 15:29:51 +0200
Message-ID: <20260424132548.933783737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f98b81fe011e1879e6a7b1247e69e06a5e17af2 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Helge Deller <deller@gmx.de>
Assisted-by: gregkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -496,6 +496,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


