Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EEE1F80A9;
	Mon, 21 Oct 2024 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507367; cv=none; b=GqY5kpyDHaELnB0Sg+Mj2nmghFBYnnJenm7eJ1mwzjGXd7wy2ULV9NPn4WH6X5t/7pRkpynfBeFyQBkmYHAUDLnLRptbuRi3Va6GBlqPGcOJQLPWT+t/uhro//vb4Qv9IS8mHkZ1WTyH88Pj5uAS4S4Kbvts8SeE02cu3c7+hao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507367; c=relaxed/simple;
	bh=ITP7AAbyfIWHapZNbpHIeIqmcShew+mWVl/ynasQKBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXkUqi2JVEDKL6x3jTae4BPH0qgSr0DgJo9ooAZm4HNl0C4/K8zz6EgHCw1Y5jVmeiPHS0qhqw3BqAijE6uknog3Op+aJrX9aFnMZT/i+RXGuoMWL4zgKeCfS5O7veOFXxil9xVPwGTkkN1FHKK0R9AwXPmxgiqWpdyLVyPSJ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnwVy2yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnwVy2yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666FCC4CEC3;
	Mon, 21 Oct 2024 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507366;
	bh=ITP7AAbyfIWHapZNbpHIeIqmcShew+mWVl/ynasQKBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnwVy2yyuIXma9UXU1iPFZ7VJeLyTpdT1Fgt9gk579ABdjFJ8C3+ZGIJFK3l6Ag40
	 0Tk79UAOHCLqE7plkOQ60c4hqQbGMR951w4H+JN0qQiXQ2TA/nb7pyaQhvcFVX9VGm
	 goyC0ucteTSCP5X3gV+w01Iun7vDAdTmCl5voVls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH 6.1 52/91] drm/vmwgfx: Handle surface check failure correctly
Date: Mon, 21 Oct 2024 12:25:06 +0200
Message-ID: <20241021102251.850277081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 26498b8d54373d31a621d7dec95c4bd842563b3b upstream.

Currently if condition (!bo and !vmw_kms_srf_ok()) was met
we go to err_out with ret == 0.
err_out dereferences vfb if ret == 0, but in our case vfb is still NULL.

Fix this by assigning sensible error to ret.

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: stable@vger.kernel.org
Fixes: 810b3e1683d0 ("drm/vmwgfx: Support topology greater than texture size")
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241002122429.1981822-1-kniv@yandex-team.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1591,6 +1591,7 @@ static struct drm_framebuffer *vmw_kms_f
 		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
+		ret = -EINVAL;
 		goto err_out;
 	}
 


