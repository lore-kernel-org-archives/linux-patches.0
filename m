Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D667149E0E;
	Fri,  6 Dec 2024 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496985; cv=none; b=VkctvmZUN5V6YkmiSdwhl39lsyMp+RRr2hlzlvesYYVg0hszBxfS6KH2R0Gd+y2LkJo6RLdP/RHQOjtLZNBWZPLzf1vzt6sw8bn4wL7esh7f3g0gJy4I5bljmGTVC8n3KwgOfCVBuS7crtMfj9N27x/x28iALORjG90Q0VGwuKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496985; c=relaxed/simple;
	bh=SJFS5oqIaNPvasrXWgbnhuqeTfgPtMnMUk9ZSkwlfCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxN3AKGjtFp3gs9d7H6vd3m58DATHxp9iPm40rGZO3sRTCs4y0X4VesnguJGn2ekbUbTLUR6OKKjBD9YR+SOFw/B6Q1PF15IFSjzrGL+IATiDbjHrb+CiQRZgybue+fg6gDlKnStsCpmZXtkTx77p10LdcqOuKNdHmMeVJUMpag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOYE0JBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOYE0JBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF00C4CED1;
	Fri,  6 Dec 2024 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496985;
	bh=SJFS5oqIaNPvasrXWgbnhuqeTfgPtMnMUk9ZSkwlfCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOYE0JBj3R+t0yvRrD9hUPJd4p25bJnHuMtK2SJC9RJwjjYo6qjzZG8MBfImG3xq+
	 fGpXFHEWsK31xz+6j+OejsRSgGflKOrZEHikR7FGALDWq+2ojr+XWNei5CVUGKhJt5
	 uzOPQh75yPMpWVA+DgIQCZh7fbOvAR+ub8jKPkoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/676] platform/x86: panasonic-laptop: Return errno correctly in show callback
Date: Fri,  6 Dec 2024 15:29:42 +0100
Message-ID: <20241206143659.719888402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 5c7bebc1a3f0661db558d60e14dde27fc216d9dc ]

When an error occurs in sysfs show callback, we should return the errno
directly instead of formatting it as the result, which produces
meaningless output and doesn't inform the userspace of the error.

Fixes: 468f96bfa3a0 ("platform/x86: panasonic-laptop: Add support for battery charging threshold (eco mode)")
Fixes: d5a81d8e864b ("platform/x86: panasonic-laptop: Add support for optical driver power in Y and W series")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241118064637.61832-3-ziyao@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index ebd81846e2d56..7365286f6d2dc 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -602,8 +602,7 @@ static ssize_t eco_mode_show(struct device *dev, struct device_attribute *attr,
 		result = 1;
 		break;
 	default:
-		result = -EIO;
-		break;
+		return -EIO;
 	}
 	return sysfs_emit(buf, "%u\n", result);
 }
@@ -749,7 +748,12 @@ static ssize_t current_brightness_store(struct device *dev, struct device_attrib
 static ssize_t cdpower_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
-	return sysfs_emit(buf, "%d\n", get_optd_power_state());
+	int state = get_optd_power_state();
+
+	if (state < 0)
+		return state;
+
+	return sysfs_emit(buf, "%d\n", state);
 }
 
 static ssize_t cdpower_store(struct device *dev, struct device_attribute *attr,
-- 
2.43.0



