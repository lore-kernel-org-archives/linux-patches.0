Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28FB523781;
	Wed,  9 Sep 2026 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963216; cv=none; b=t+NQ+JXyGS35QMtdKetUkmD8WAvYD4MNmBzjpmyGRBBiOjRkUYu2ztQYu/D58hwuUaL9914u4qHgTQPjpWeCz3XqrBaFyOltRerHzEgFyQiOfI2fKazeMWbCDNZ/RdHSvCrqdSLXvDFeM2NgBrGYO987h3umaB2f6xEnd+VhdtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963216; c=relaxed/simple;
	bh=tR9BiWfEhYXupykpml3sblB6DlQbuKepDCA94QJUXcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rH60sv821QuESi1Zk/0TtSOAWI6ZvYQPVw950UpevNjLfOJ5nc5Bl0Hm70wg9r5SFap4IfFPSa5CkchO4sR9LMHzDzcMSOpVe697AvwnnvD2ayDQD1cDEb72lxNSe8kt5S5B5VdUEsQ7BZnMCwdfWSvnFsfmUuLAeh8yeS2TFeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuML/GG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuML/GG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178BF1F00A3A;
	Wed,  9 Sep 2026 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963215;
	bh=nOazrmp1Xc+EA3ACIG7kZ3WJbu5ADpkhMUy1aUf298s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuML/GG61TTzhJiImuOfUIrYGoL6f7iv/OR3EB+GzlriMhQjNcN2MIU/rbEFtTjSi
	 opI2Wu6IsR7SLbPBiEA5BAECwpsf/Wbbwho7c9apNNT/LDLJrdLt8Yi9HePtS8qnjm
	 xXqazwEcWc8RW3aXdvT+YsZVUO8mPH3foKCOG04M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 7.2 522/556] drm/sysfb: simpledrm: Improve stride validation
Date: Wed,  9 Sep 2026 15:43:22 +0200
Message-ID: <20260909134248.786916552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -710,9 +710,15 @@ static struct simpledrm_device *simpledr
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


