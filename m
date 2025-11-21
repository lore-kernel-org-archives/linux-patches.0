Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA441F09AC;
	Fri, 21 Nov 2025 13:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731267; cv=none; b=Rt0swRieZzEYIXmNw9mypekcyNAvaF8QkuFA5fIVH6AD24JIQb3Ebd3fXbyIlLLCd5p4+B9zuRMRCsUb676S0L2T1xSa4yvKJcW6cX+p8CK9mRUD3e7oqbrBq7Pa1Qr6kVmXac324sh+jum1lr9P2iYRE/kcs566W5f9aFov65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731267; c=relaxed/simple;
	bh=ESr4MwQeQ77RTJpWm+kBMbfttRLTJlZLOkLu+59wwa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+V3iMFqCBs3IVz08uFuvfnAuxx+hDmXShWXG8am8Q7Hld7F4H1csgQt5snFItUIimLRihrEecw6LA1h0nJcabMGZMFJgPjd8g8n5rTBD/F0gGBZE/5PA8itffuq0XkZn970y1O0h/9Y9lWaeN5T03PP7m3glPGSeB70tjgAleQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuyO6Y1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuyO6Y1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6FDC4CEF1;
	Fri, 21 Nov 2025 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731267;
	bh=ESr4MwQeQ77RTJpWm+kBMbfttRLTJlZLOkLu+59wwa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuyO6Y1ZgjnZWD3EUeICz4Lj3X44rn4P4ouWTbE4sqXh9jN/8FLeGewZ0KgVPFdat
	 dwTKyrGpiG/AYzum/X1YVbR60bf6r84DXmRPbHOxBI/H1Ash3JftMSqn1jQJLO9Yty
	 25Xq2VuEkXiFNic6ZbOLxMVCZD1IlCw1fvbX7sbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 147/247] HID: playstation: Fix memory leak in dualshock4_get_calibration_data()
Date: Fri, 21 Nov 2025 14:11:34 +0100
Message-ID: <20251121130200.003660389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 8513c154f8ad7097653dd9bf43d6155e5aad4ab3 ]

The memory allocated for buf is not freed in the error paths when
ps_get_report() fails. Free buf before jumping to transfer_failed label

Fixes: 947992c7fa9e ("HID: playstation: DS4: Fix calibration workaround for clone devices")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 1468fb11e39df..657e9ae1be1ee 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -1807,6 +1807,7 @@ static int dualshock4_get_calibration_data(struct dualshock4 *ds4)
 
 				hid_warn(hdev, "Failed to retrieve DualShock4 calibration info: %d\n", ret);
 				ret = -EILSEQ;
+				kfree(buf);
 				goto transfer_failed;
 			} else {
 				break;
@@ -1824,6 +1825,7 @@ static int dualshock4_get_calibration_data(struct dualshock4 *ds4)
 
 		if (ret) {
 			hid_warn(hdev, "Failed to retrieve DualShock4 calibration info: %d\n", ret);
+			kfree(buf);
 			goto transfer_failed;
 		}
 	}
-- 
2.51.0



