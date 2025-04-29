Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED81E22AE68;
	Tue, 29 Apr 2025 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948966; cv=none; b=WEhAeB6MNl7Xw4vvB6nGrlx7JUi1LwM5OI1Xo4naOw2f0dXjGykH+evUxWkzg/lg2jxoqfAwZSHDMgcNmt6ibXteG0JUIMTz8W9QRjifsWz4sHDiQSM6Wf/6tjywtqJGNGUBkcy9WwTXnlbxS56NdZZpgxVQ3QbPiBY0sseTBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948966; c=relaxed/simple;
	bh=2VtONtnOwOgOH91JTxy0wVHsBzvdmLoQTQa3reObLLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/ZroGMnOpedqmk2c3okMQFYHlHnwnUMWeEY34AEW8q6DujdXbHgF04d1yk6DkHU+I+C81yYFDY7XITFT+SYmW89riIKIkJcxNqzmG/xRYlIKlFmR+EY98L4/Gh01b48bQYOZ0+Vd8xhAassADwooR5UVoOd44ARkxbUWIE9zNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsL4Fodu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsL4Fodu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED66C4CEE3;
	Tue, 29 Apr 2025 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948965;
	bh=2VtONtnOwOgOH91JTxy0wVHsBzvdmLoQTQa3reObLLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsL4FoduOPNa+C8DvvQ7+UI6yEnzkHANgTV+6ggxLASApgbMvd1sda6fOnwEImdt8
	 Dilv9kVqPFG8TbSsf4mNi8amrzQHfiTH2wunj3yQ1EdiDGkPj/6UMUa4JrMwf+VBea
	 sBe70fLgp7lQuSXSoj5+pkqsugzZFOvpolXWIZPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 178/373] drm/amd/pm: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:55 +0200
Message-ID: <20250429161130.491774754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 7d641c2b83275d3b0424127b2e0d2d0f7dd82aef upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b64625a303de ("drm/amd/pm: correct the address of Arcturus fan related registers")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1278,6 +1278,9 @@ static int arcturus_set_fan_speed_rpm(st
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
+	if (!speed || speed > UINT_MAX/8)
+		return -EINVAL;
+
 	tach_period = 60 * crystal_clock_freq * 10000 / (8 * speed);
 	WREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT,
 		     REG_SET_FIELD(RREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT),


