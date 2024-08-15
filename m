Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AB19FA90;
	Thu, 15 Aug 2024 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732296; cv=none; b=kaHiyiQyXQCQcXjV+uAsXpO/9zYyNWx632ZpAkvuqAmhR0uE5qjaE/8Tic+mUJ1V/IdD7TfoJjTDPflQMbpczKTcaWvK6xn6NNpj68TnblL0CcEe39dTSvVxuwb8+mz60+6wptRvdTqC4mrLc63P3em7vkkM+SwJ0sBdKWjMxOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732296; c=relaxed/simple;
	bh=rgUaxsmtrrUIDVV50SAmqh3g16rSSbhQxalwPkrpfGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIHrv5HE+sxSJqAIb3J7ffx57IVwKtZ9SebTms3gHuU06hVnJdh+YBdQKG5bhQznBdmLL5Ais9gajA/icPsJbEUYRN0ybkQjy8VV1DmMqzqqb1HfGNAK+HaGpOpw0BcMewcDp6zHIXTpnyEYOnHIy60ffXgD/cT96ZdZRfoO4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJJfOjNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJJfOjNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E370C32786;
	Thu, 15 Aug 2024 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732295;
	bh=rgUaxsmtrrUIDVV50SAmqh3g16rSSbhQxalwPkrpfGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJJfOjNTGhNq1YxVyES++MOxT8SiEGjjVLPhvkqgBbniv9NMg7nsn6w9HWX+AuSbX
	 VTfqP5/QA7It4juofkIBw/O5M1WpNVVEKNStIoLhy2sTW/uyn2SEAQtosexG+jHuxX
	 ZJYGQrmKjAgQ5TmzS3v0/Cv+QhtwfxACBrdOIUI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 5.10 135/352] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:21 +0200
Message-ID: <20240815131924.473903573@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -508,6 +508,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


