Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E34BEE54;
	Sat, 12 Sep 2026 07:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198370; cv=none; b=IRUq31SvOaBsk2kmT8Py+Tm+NTbw3p5zM55ZyR/VKTnTfWJtPAcLqm2Se1tk91AtnEDzQ9iMQAMZZQk7paxxecpBJEdmwsiKE87GA2uThECwxBh5yCP7OUXQFP7T2FWyHWXv5eVjSNKHxhBxJG4h0iv9U+Jfq+xnyFv+i5K4G2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198370; c=relaxed/simple;
	bh=LhPzNrHCos7tVoumalBJ167DuHs6EtlSCazd6RauOEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpThlnjMMdmqkoQYeFFih216Oi6Wcdchl0tOFzKNZ8B8v5TgHeA1KeFKYOozLj2zAqu1fcdAcrTIJckhaa6J4n6HUPL958P4E3xgFwNHzF8hhpURJL7+CHatm2pYGIopNStgNTfyMvbAbndY381Fo4vZ40oSs8IhQKZbO5sPmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhIasGrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhIasGrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1BC1F000FF;
	Sat, 12 Sep 2026 07:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198369;
	bh=EDDkuDmk2LifSkVZMMI5T8ZT3so9I7WN4M8jvoo41SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhIasGrUAF787vAJvw3ibIXA51gPWlZD9Sl2yEWm6C2TdgR6XmTXCoj4iofaUSKhr
	 hPKF6mPi2S6/kEmYII59cIzAzIWEDhgBOShwV+ZIsijyWwfj+uGFjLofButYhKhPpD
	 b4mrIvE7GGyVrAjg54c08PZz0yO0QVa51SYXCA30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0323/1815] usb: typec: tcpm: fix EPR AVS APDO maximum voltage decoding
Date: Sat, 12 Sep 2026 08:34:33 +0200
Message-ID: <20260912065656.516523753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 29741ca40b7b780ba14c4c3ffef190f908864fe9 ]

pdo_epr_avs_apdo_max_voltage_mv() extracts the EPR AVS minimum-voltage
field instead of the maximum-voltage field. As a result, an EPR AVS APDO
with different minimum and maximum voltages is decoded as having
identical limits. The currently visible effect is that
tcpm_log_source_caps() reports a min-min voltage range.

Extract PDO_EPR_AVS_APDO_MAX_VOLT in the maximum-voltage accessor.

Fixes: f82890c98f3e ("tcpm: Parse and log AVS APDO")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/48301FCEC9F3CA14+20260616085439.987664-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/usb/pd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/pd.h b/include/linux/usb/pd.h
index 337a5485af7c7..ee360dedeaa65 100644
--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -493,7 +493,7 @@ static inline unsigned int pdo_epr_avs_apdo_min_voltage_mv(u32 pdo)
 
 static inline unsigned int pdo_epr_avs_apdo_max_voltage_mv(u32 pdo)
 {
-	return FIELD_GET(PDO_EPR_AVS_APDO_MIN_VOLT, pdo) * 100;
+	return FIELD_GET(PDO_EPR_AVS_APDO_MAX_VOLT, pdo) * 100;
 }
 
 static inline unsigned int pdo_epr_avs_apdo_pdp_w(u32 pdo)
-- 
2.53.0



