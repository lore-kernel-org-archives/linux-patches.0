Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A791487CD;
	Thu, 12 Dec 2024 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016702; cv=none; b=h/h3ownXpmzjTrug+M9unXWz0BV+j3PHmgvyIHIKNFmOPRDUDj5iVBIABcJT3v6HUaM7tOm7W550d0jDomeKrcZ70bmUHY2LndDwsVzkaxl8OATy4823Q07WT+1/kuVaMRs0Pqxr3j1t5tUQ4FEcd3ZAKkUgqX+LzkAPYBxpzvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016702; c=relaxed/simple;
	bh=Kk+hqbOAGzpxJbIEDwf2oZT+knLTOB6vmaVO39MEVhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLLpG+8gIdJ7dLpvuLdtn4EGcXBKkBEolnUVnSUVJOdjYLY+qvTUjYFDF/rH6tGycWAhw9mkg7/kLtN4w0BBoxQpOtlzoN37iXPJZ0oX8MlqPQio5vE3rpMqBRMlDVXD31nF6Ec8PpNiXuMKKi7XMthoEPVlPFRm3N+vUNyTxyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2adpmsVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2adpmsVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F746C4CECE;
	Thu, 12 Dec 2024 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016702;
	bh=Kk+hqbOAGzpxJbIEDwf2oZT+knLTOB6vmaVO39MEVhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2adpmsVWKgvUXRr5nnkpyFueDqZNgeQsnkM43l3QwILZkdjklwdZ0KLs1RzZEJ50M
	 SyT34u7UpTwOCQFGbq0+304n4djooMMDRHhHkE5YvSdrMwlZ69nPHb/7VyNl002vS8
	 D3JVIYCqPcHNQo1cs+hccP1kBPNtkkdQ0zk9ikhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/466] drm/display: Fix building with GCC 15
Date: Thu, 12 Dec 2024 15:57:24 +0100
Message-ID: <20241212144317.648410111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit a500f3751d3c861be7e4463c933cf467240cca5d ]

GCC 15 enables -Werror=unterminated-string-initialization by default.
This results in the following build error

drivers/gpu/drm/display/drm_dp_dual_mode_helper.c: In function ‘is_hdmi_adaptor’:
drivers/gpu/drm/display/drm_dp_dual_mode_helper.c:164:17: error: initializer-string for array of
 ‘char’ is too long [-Werror=unterminated-string-initialization]
  164 |                 "DP-HDMI ADAPTOR\x04";
      |                 ^~~~~~~~~~~~~~~~~~~~~

After discussion with Ville, the fix was to increase the size of
dp_dual_mode_hdmi_id array by one, so that it can accommodate the NULL
line character. This should let us build the kernel with GCC 15.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241002092311.942822-1-brahmajit.xyz@gmail.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c b/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
index 14a2a8473682b..c491e3203bf11 100644
--- a/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_dual_mode_helper.c
@@ -160,11 +160,11 @@ EXPORT_SYMBOL(drm_dp_dual_mode_write);
 
 static bool is_hdmi_adaptor(const char hdmi_id[DP_DUAL_MODE_HDMI_ID_LEN])
 {
-	static const char dp_dual_mode_hdmi_id[DP_DUAL_MODE_HDMI_ID_LEN] =
+	static const char dp_dual_mode_hdmi_id[DP_DUAL_MODE_HDMI_ID_LEN + 1] =
 		"DP-HDMI ADAPTOR\x04";
 
 	return memcmp(hdmi_id, dp_dual_mode_hdmi_id,
-		      sizeof(dp_dual_mode_hdmi_id)) == 0;
+		      DP_DUAL_MODE_HDMI_ID_LEN) == 0;
 }
 
 static bool is_type1_adaptor(uint8_t adaptor_id)
-- 
2.43.0



