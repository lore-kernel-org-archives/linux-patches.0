Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EB01DE4EF;
	Sat, 12 Sep 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222097; cv=none; b=CpIk1YRwKyS3Boxbij2mTIhCneicWtQtwmPuhK7hgk/aSa05/QreDUm4YE/J5CSAPJ3o1pLwgKJfUG6z946a/FiAKIYftqvw/EmYsipO7GPBFZgaUEz3AyGLlrStVA8QCaBduV65/lG7EMXtQCMfvBS3PSyB2jMa6FTJ48/5d2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222097; c=relaxed/simple;
	bh=2r0Ef54J6WiLrB5nyzIFWgJ5hHYl0ClrN28Y01nNo0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amQyYGSUL3VT+bO8czLXxazVSb0p5EmMxZyXdNtMf6eIXWzXsb5r+rB3qpCu7zuKjEgl5xWKnhF8ZECSsitSRvgnbnRiCNqUJyNFBBl9PLgrpnXoaaMxozeCXzi3TlZ8KR7PbuhYqG5C8tzRUMf1wnv5lT5xX/Oii4kmJx9Ltm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lt7JhFmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lt7JhFmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B805A1F000FF;
	Sat, 12 Sep 2026 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222095;
	bh=Xp7Lw9rFcCnFcpcOMtUAmmujgbCVU7YlFPpXfL85x0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lt7JhFmy2S5Po/pVn7Tr+nfQ0xYfL+xFAM7BfyeBiLvavB0iufyhPaHiMCLNX2nwm
	 0HHYCT+nzUgE2CzvEozIMgI9xLWmfJ44s+qIB6slAgrPyPqe3jsVxfoqY4ZgQcCjzO
	 mp/kxmjbunUQVAFyMUtxhC8+7lRzvAL6uSajLP60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ae8e7884e451eaed5b4@syzkaller.appspotmail.com,
	Tao Yu <tao1.yu@intel.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.6 0518/1424] drm/gud: validate TV mode names before creating enum property
Date: Sat, 12 Sep 2026 08:49:10 +0200
Message-ID: <20260912065618.892159382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Yu <tao1.yu@intel.com>

commit da1ea35fea67ad841f4ada28dd61b41be65e5437 upstream.

The GUD protocol returns TV mode names as fixed-size
GUD_CONNECTOR_TV_MODE_NAME_LEN entries and requires each name to be
NUL-terminated.

gud_connector_add_tv_mode() currently passes each fixed-size entry
directly to drm_mode_create_tv_properties_legacy(), which eventually
reaches drm_property_add_enum() and strlen(). If a device returns an
entry without a terminating NUL byte, strlen() reads past the end of
the slot and can run beyond the allocated buffer, triggering an
out-of-bounds read.

Validate that each returned TV mode name contains a NUL terminator
within its fixed-size slot before passing it to the DRM property code.
If a malformed entry is found, reject the device response with -EIO.

This fixes the out-of-bounds read without changing the handling of
valid devices, and avoids silently truncating malformed protocol data.

Reported-by: syzbot+9ae8e7884e451eaed5b4@syzkaller.appspotmail.com
Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Signed-off-by: Tao Yu <tao1.yu@intel.com>
Reviewed-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260819072835.4074130-1-tao1.yu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_connector.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_connector.c
+++ b/drivers/gpu/drm/gud/gud_connector.c
@@ -400,8 +400,11 @@ static int gud_connector_add_tv_mode(str
 	for (i = 0; i < num_modes; i++) {
 		char *mode = &buf[i * GUD_CONNECTOR_TV_MODE_NAME_LEN];
 
-		/* The device is not trusted to NUL-terminate the name */
-		mode[GUD_CONNECTOR_TV_MODE_NAME_LEN - 1] = '\0';
+		if (!memchr(mode, '\0', GUD_CONNECTOR_TV_MODE_NAME_LEN)) {
+			ret = -EIO;
+			goto free;
+		}
+
 		modes[i] = mode;
 	}
 


