Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4134C33FE;
	Tue,  3 Dec 2024 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238247; cv=none; b=Cp3AcpwztTDXQ/1s0MTyrfurCLeGeDUawtD+nnwBYtcDhvHOxteOIhhGztOghmOyb88ApyU9YLU3QmkrQLaP8ZLDuxkQYEafjhLy1BckQ1mAgkRSi0vwm9AdL5aqMVMiXjaCBoTQHD2gC/yOAz/UVyyK9Sbu5db8PM8oxEETZwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238247; c=relaxed/simple;
	bh=0zel8kHPZ5uY/Mx02KSPhOlHIim/Cq2sdxdEZmehYXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNX3+54shI31RhxkmWD+T8dS3ak4PzZfbUKec6fC/fKmsh1mF0rZD7EP7e76I8luPNLiFTJx9SFmLIARtCW5juCw/ueunLWfIorV9r+l3Njo1SeeoER3M/cHkmf+z525Gc5nEaVrJv2UQvo7tY0MkYmLRISXUJqQ3oCRIhM5Nqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCAunBdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCAunBdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CD3C4CECF;
	Tue,  3 Dec 2024 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238246;
	bh=0zel8kHPZ5uY/Mx02KSPhOlHIim/Cq2sdxdEZmehYXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCAunBdmXMfak9qADABh5jBDFP+ysf+6oDP0tljl+4LqoD48GBIYklb0UVaN/jcb1
	 5+wuSCOJ4/QwQ0L6xtkuUgv2q4AvODMsI7ZQWEj9x2YoSbEjbIN9PuVtDr+HUFwZ5P
	 CixfpUOeFDU+iT6R9/m8p8nkXmaeSlGBSTM/XxD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 213/817] platform/x86: panasonic-laptop: Return errno correctly in show callback
Date: Tue,  3 Dec 2024 15:36:25 +0100
Message-ID: <20241203144004.064377419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



