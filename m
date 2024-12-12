Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5742C22969A;
	Thu, 12 Dec 2024 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022093; cv=none; b=tCGMorPSQCwl0aBzHfSCZaGtZb2JFVMn9D2dr0mKzbOiIfGNdVIa7CZVZfMLv6sjtjGD+jULkP/n0HwlPmnNTSQ5ZMeSkDiq7c+DFQwVbOoDbc2wd47A/uP3YB2T8xHa2HLi+ac2UrkkHwma9EwxcwmfonZLWnx1mWGiU7uZAiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022093; c=relaxed/simple;
	bh=F/mfNcoMOc4m7pjH6eTFLcjyvUqJV3Zs7rRtXN1ROXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5gU4WZHpKc0b66JuBzi+u7jgd7fu/1fVoklEPVdLB4JRuV825X1RaMUfIZzkTmH8gnKad4OYNIlCLzZoLZCXd3UpMokvj4CumTEtg5f1Pioi0shILlwc++fn+HhLSLpn69MtLY2r2IRX1VHWGGKQsusjjdhA2AapHcXKCu8RiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7zzoRqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7zzoRqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E454C4CECE;
	Thu, 12 Dec 2024 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022093;
	bh=F/mfNcoMOc4m7pjH6eTFLcjyvUqJV3Zs7rRtXN1ROXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7zzoRqEiUxRnSIvhmqQT/+LFoktfeBS3duZ+SX7249PHYH0+z9bUCy75tQzao2JQ
	 x8A9cTeYf4YiYNZtCY7+IoOOQ1JS1dPnjvwSUjuWaRo7qNjryFbLQcYTqD3mSZaoPw
	 QnMluwShXojt9wdr/u0lok4nMSCODit3hWtsIHEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/565] platform/x86: panasonic-laptop: Return errno correctly in show callback
Date: Thu, 12 Dec 2024 15:55:40 +0100
Message-ID: <20241212144317.221589582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26f4d15c3bf13..e412a550f0983 100644
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



