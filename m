Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C275264614;
	Tue,  8 Apr 2025 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110991; cv=none; b=P48zqN89T4Gl34TEgZg5lVmfqiPVvVkLm9hVV+wct3sduA4WND9THriE31rUhplowun2R9Xzp67rbvKwzFnsPq9OJgPIAgiZfMhfBL8Zj13nI3a9njPinywuombd/4q4sUzWXtjcKFziN/SatG8Bn+pVDQxkyGExzs30iFy/XMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110991; c=relaxed/simple;
	bh=8xsVi3H5SONMG0vWEmz33DK34LDkhOxZ875l0VeZIxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3m2aSaQIsmVYGSs4TlGJ6di/cxLFUUxTDr52ut/BGnSpIJC7nSd4ktsGWkDAYKBqv5Fe8BFK6nBJHh8+qGVntz5VrkhVdYRGNJTUOFbUN+3GmHF+nGe2huLBtLy7oNOsEMgPzuAMWPUfVnN6UZr1UHKn+EMSZL9ocQa8roUqG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zAtMCxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zAtMCxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD5C4CEE5;
	Tue,  8 Apr 2025 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110991;
	bh=8xsVi3H5SONMG0vWEmz33DK34LDkhOxZ875l0VeZIxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zAtMCxTOLAVPbmfoKzMJaqLCa40bJKDK16CPFi1iJUCP8uVuIrzYScClMuM6dVbt
	 K8MQs09DtSSls+Jj9x4IziPrxe52Lfh2lilcAxeh1oHNHWul9879E1HYw96pS0rE9V
	 uzgIeX3pK1N0SagDrRyT20vN2ad/nTm1duwHXbBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 270/731] drm/ssd130x: fix ssd132x encoding
Date: Tue,  8 Apr 2025 12:42:47 +0200
Message-ID: <20250408104920.559000293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 1e14484677c8e87548f5f0d4eb8800e408004404 ]

The ssd132x buffer is encoded one pixel per nibble, with two pixels in
each byte.  When encoding an 8-bit greyscale input, take the top 4-bits
as the value and ensure the two pixels are distinct and do not overwrite
each other.

Fixes: fdd591e00a9c ("drm/ssd130x: Add support for the SSD132x OLED controller family")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115110139.1672488-2-jkeeping@inmusicbrands.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index b777690fd6607..4bb663f984ce3 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -880,7 +880,7 @@ static int ssd132x_update_rect(struct ssd130x_device *ssd130x,
 			u8 n1 = buf[i * width + j];
 			u8 n2 = buf[i * width + j + 1];
 
-			data_array[array_idx++] = (n2 << 4) | n1;
+			data_array[array_idx++] = (n2 & 0xf0) | (n1 >> 4);
 		}
 	}
 
-- 
2.39.5



