Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8D953ED1E;
	Wed,  9 Sep 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963036; cv=none; b=Tkd9TqsV7yYW6tCRPja0P4EpADQnECsYCq0YsJ2mRexrBYgIIfnPRG5W1lQ0tnhGUbu65YHcREKVYzkYb0NkXIYbSsFFwCdtNqP564ZE3ONIkWwf11+d9GqAVSA7v/4Yvk9dS9D4XtYMMZA0YiwgAySCgS7WerX3wu7h9D1NGA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963036; c=relaxed/simple;
	bh=BsAXIxk2UbbebnG66xfP7S20C7tPae6/pjIWvbPFJzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYo4iW6yaWL0/z1Cygijwzj0tIP4+sWECcjt/yK+XPQqy1G/t5PtVZYJfKI/yfy9dLTSgyKPGU5I6QO7633pPqDwEm4IP/vExkCyLf6m47A3Jvhr7RMcUgX6Hyq/NWeZqCPPpEwtW1iGh9+T+Tq9eVqh1bDFW3BI96nZZDKg6sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJibOffk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJibOffk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B531F00A3A;
	Wed,  9 Sep 2026 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963035;
	bh=bfr+GyUJkoNGJOMP5+RKQ/ERyi4ejdIMHdGx3bpZiOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJibOffk9a/bmGbpnFG0IFjZDW3ViMX0BWSWw7x5ISIyZ7mmTm4HuyDBijNcViwgh
	 lNjiOjQAfzaXvbw0FBLMp3wN0H+nnPoWDG9ztN5V5V6tyrg6xSCYiMqIoTndiCKSmq
	 px4DwzTSaDXuiNOOhKVf2sVCeArEVNJ25dFbe+Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ae8e7884e451eaed5b4@syzkaller.appspotmail.com,
	Tao Yu <tao1.yu@intel.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 7.2 497/556] drm/gud: validate TV mode names before creating enum property
Date: Wed,  9 Sep 2026 15:42:57 +0200
Message-ID: <20260909134247.964138924@linuxfoundation.org>
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
@@ -399,8 +399,11 @@ static int gud_connector_add_tv_mode(str
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
 


