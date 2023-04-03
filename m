Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD68F5683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C27C433EF;
	Mon,  3 Apr 2023 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531433;
	bh=PfydbKzpZCsxVnfkbWETdgAMfBJsJKvG7N8IhN7kgBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdxpZOFX2PNS+MnWngcsrD929RFThcgfnPAlj/QNIlpG++R5gFxp0OC4qOOcPAOLq
	 dhEM/fFkz/4+439/NkpRD656PbdYv8uz1Eeq/+vRtxW7JGQX1j+M1YIeyJWI+i6UNO
	 VrTslfsuGjSCuM19Yv0ri4hsJHdXzWB6r+8q0et4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/84] fbdev: au1200fb: Fix potential divide by zero
Date: Mon,  3 Apr 2023 16:09:01 +0200
Message-Id: <20230403140355.499556340@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 44a3b36b42acfc433aaaf526191dd12fbb919fdb ]

var->pixclock can be assigned to zero by user. Without
proper check, divide by zero would occur when invoking
macro PICOS2KHZ in au1200fb_fb_check_var.

Error out if var->pixclock is zero.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 3872ccef4cb2c..f8e83a9519189 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1039,6 +1039,9 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	u32 pixclock;
 	int screen_size, plane;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	plane = fbdev->plane;
 
 	/* Make sure that the mode respect all LCD controller and
-- 
2.39.2



