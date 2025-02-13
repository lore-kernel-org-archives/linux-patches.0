Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B526B0AD;
	Thu, 13 Feb 2025 15:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459682; cv=none; b=L6Hvgk+KE9ANZFyu9hgEQZ7r5FGecQBt50wN8BPxiCjc1opYEMq2UjuQZEIVGyhW+469Y2HRZx5GbBK3eyd04pkb5pEQTS1aexUJoTMopR1mGbFOEupY5KUQd0qlVhTp49z03w3od+NFaH+WfoqEIIh5HZr6In3kSW2uzaGr5fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459682; c=relaxed/simple;
	bh=EB5iW4eN4Or9jcVX9Y7IzSgitopaqSJnaWv9ztwEij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPI1PZepH4UH+jwVq55Q/CGqLgHwLSrZSA09ZZviADsutV3LRExPoguC4wUiqLXX2q8SjZSwa9TMP2tbGpqM0fuUIKdZPlzxgkLUjYWhaXbIjidmp9mqfnRYDRQUvzUIC6Nj3Q4HaZtQYEErjqeyRYnM8p+oFicpafrGB7hBEB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAAOzV1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAAOzV1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0B0C4CED1;
	Thu, 13 Feb 2025 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459682;
	bh=EB5iW4eN4Or9jcVX9Y7IzSgitopaqSJnaWv9ztwEij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAAOzV1tzkcQoJBhulNcxmSMrSMwwWh9wImtX8w6+sV1eprg2Dz4nDiQ6UIZzyxvr
	 fQyhusPPwZn8sTbO90of381wF3bBHAn+oDbbz23cB/6ltBNPz6JKzTKfCyd/qvPCZI
	 HdnB4ASFVevK7Rexav84Yl36eN1R/z/WYTPhSSps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.13 333/443] accel/ivpu: Clear runtime_error after pm_runtime_resume_and_get() fails
Date: Thu, 13 Feb 2025 15:28:18 +0100
Message-ID: <20250213142453.474926592@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit f2bc2afe34c107a02ce829a4039e85514feafe55 upstream.

pm_runtime_resume_and_get() sets dev->power.runtime_error that causes
all subsequent pm_runtime_get_sync() calls to fail.
Clear the runtime_error using pm_runtime_set_suspended(), so the driver
doesn't have to be reloaded to recover when the NPU fails to boot during
runtime resume.

Fixes: 7d4b4c74432d ("accel/ivpu: Remove suspend_reschedule_counter")
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129124009.1039982-3-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -309,7 +309,10 @@ int ivpu_rpm_get(struct ivpu_device *vde
 	int ret;
 
 	ret = pm_runtime_resume_and_get(vdev->drm.dev);
-	drm_WARN_ON(&vdev->drm, ret < 0);
+	if (ret < 0) {
+		ivpu_err(vdev, "Failed to resume NPU: %d\n", ret);
+		pm_runtime_set_suspended(vdev->drm.dev);
+	}
 
 	return ret;
 }


