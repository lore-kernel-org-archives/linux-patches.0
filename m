Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677C04F55A5;
	Wed,  9 Sep 2026 14:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964388; cv=none; b=qKVQWQj/rb9aKqmIySu88tt355oOXsNqk4YXKFvNvTc2loXTfDEeqwlPyNftkOzjoVVzbeL0IlUAI0qaf5APYTqosNXeZjhip5OX5MdN98yCl5aQKsWGdWwxxSKfgqMWiblY/BJQkSidYeN1QAIHnE58yxREWniq8Zkfut0xkEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964388; c=relaxed/simple;
	bh=vLl46vgF0hXe5hXj6HwFcBWk8i57qs4Eg7pvNUTXQ34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loRFFKerf9FJ/sgp+Ex47H5/Uh7wZ4Us/ih4hverFqrhV1BjSQXGX9KMRFInbr/Dl5AiQl/72aoA4cmb1zwxZDStXm/Q0W8mpeYkhYq5WpPJldQ5rvYjz4eRm1WNcM7WgoSONNv1p2JS4fpH4BAYRAe2Of0+gdo0QbAqNAaIaoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dt0ur3nM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dt0ur3nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19601F00A3A;
	Wed,  9 Sep 2026 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964387;
	bh=7c2EqwmtrOENkfXVUrQaffpfqmOxKC5q65Wd5FY8VUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dt0ur3nMl/wOO82VgMLlOpbJ07q9dVP4CeWcRhOtBFapcwBLJqWTRX+eYlX3p93lA
	 /Z/BQAs41L6Ki3L1FIJxsPwndgn1L2Bo0jdVQUROtikFQsjBJ0TmJ1Z3TkIyO94m58
	 ZNKP5u2zU0G5Xs76/N9QQXxzpY6isglUJCKs8nCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.18 406/583] drm/sysfb: simpledrm: Improve stride validation
Date: Wed,  9 Sep 2026 15:41:31 +0200
Message-ID: <20260909134252.053465350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit df6533f11688aa30be3bb883c7637f4ffdbb7cbd upstream.

Validate the computed stride against the maximum value INT_MAX.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 7bfa5c7b28d6 ("drm/simpledrm: Compute linestride with drm_format_info_min_pitch()")
Cc: <stable@vger.kernel.org> # v6.1+
Link: https://patch.msgid.link/20260625094509.157581-5-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/simpledrm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -706,9 +706,15 @@ static struct simpledrm_device *simpledr
 		return ERR_PTR(-ENODEV);
 	}
 	if (!stride) {
-		stride = drm_format_info_min_pitch(format, 0, width);
-		if (drm_WARN_ON(dev, !stride))
+		u64 pitch = drm_format_info_min_pitch(format, 0, width);
+
+		if (drm_WARN_ON(dev, !pitch)) {
+			return ERR_PTR(-EINVAL); /* driver bug */
+		} else if (pitch > INT_MAX) {
+			drm_warn(dev, "stride of %llu exceeds maximum\n", pitch);
 			return ERR_PTR(-EINVAL);
+		}
+		stride = pitch;
 	}
 
 	sysfb->fb_mode = drm_sysfb_mode(width, height, width_mm, height_mm);


