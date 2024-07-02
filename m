Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7046A1514DC;
	Tue,  2 Jul 2024 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941229; cv=none; b=jiSIICEuOjBjye7eBeWc2dxEz6E/Vl13w8hJkEVE6y//9OYxqSsnvI24L9gonXHdcWWq7eojYsl/y9nQQ8K7lUJ6IoeBt0zxjioY8D8EbKBo5f7+xXL8+NXZS/jgi6R3235QQ3VCqGbu6lItWYmgrK8QNVLb9jJEdpOayqQ/8SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941229; c=relaxed/simple;
	bh=SapN4vWpsvNQLK6wHDuAQJsLZtzyOelUnpWkaSKxVBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+6iPzyVMponjZU7YE/LLaNM13I/vEQ2FbBuhZpG1fZEK5YN3aczHWo0uiKZ6r9dUwXl5wI69xv7WwHB4PbARG0gwDHiRJ/t00EU/O6y9rfr0ZyQ14iTGD8HYFVnwZ23W3f17NLnwFCp0CJjZLKjIbgvzoTkU0ihWUTtrlouqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4TPmTX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4TPmTX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE46EC116B1;
	Tue,  2 Jul 2024 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941229;
	bh=SapN4vWpsvNQLK6wHDuAQJsLZtzyOelUnpWkaSKxVBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4TPmTX4DT2EpWfBZRbTEoGdEPJRBhcZVW5rtcTA+AoZkwFqMnFF2w/sJq2wFH2WU
	 ROuk5vjc+dswUcJwBduVObAZC4fVKyFJr9b0Xln/fuhuJ1Y5H9N1hF/0GPxWjvQ6p9
	 r0cO3iymG384WKoQ4x/e4JWcal106eA5ai62QgEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 140/163] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes
Date: Tue,  2 Jul 2024 19:04:14 +0200
Message-ID: <20240702170238.353168015@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 6d411c8ccc0137a612e0044489030a194ff5c843 upstream.

In nv17_tv_get_hd_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). The same applies to drm_cvt_mode().
Add a check to avoid null pointer dereference.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081029.2619437-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -260,6 +260,8 @@ static int nv17_tv_get_hd_modes(struct d
 		if (modes[i].hdisplay == output_mode->hdisplay &&
 		    modes[i].vdisplay == output_mode->vdisplay) {
 			mode = drm_mode_duplicate(encoder->dev, output_mode);
+			if (!mode)
+				continue;
 			mode->type |= DRM_MODE_TYPE_PREFERRED;
 
 		} else {
@@ -267,6 +269,8 @@ static int nv17_tv_get_hd_modes(struct d
 					    modes[i].vdisplay, 60, false,
 					    (output_mode->flags &
 					     DRM_MODE_FLAG_INTERLACE), false);
+			if (!mode)
+				continue;
 		}
 
 		/* CVT modes are sometimes unsuitable... */


