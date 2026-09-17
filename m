Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ABD4F392F;
	Thu, 17 Sep 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667172; cv=none; b=J7Qmp4CZ0S1t+Hkeh0fY2YZR1CvYkHwQr7GXRRTBAYwB9MQhK17VmubT8ykhu3j97LPKjjdpSfTeZKHe7xwV6djv6sLi+h6G3oo5pdWwg3zhHWjSrArvpiuKOn+XrHa29gK6dKSJrnquJd3hhTgajZ8SlwGr94+8m4ULz27OkEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667172; c=relaxed/simple;
	bh=q3VpIYjx/gUhJ78h/fcmhL72c+/CNG8pmY860l2CvCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W3DqQmLpI1mYWuCPkhVrdw3LtcOjEc4XfeZColv65POa1aHSgU1p4JnZFxMeJWXhCsSLWbqiVKM6DnwQkO20eltgiLYfmd/vafwdMsG7IJmgewAR+3lXw85KYln6hyGSbayDSZ2VhZFBdLdwUbj0/JtArtNvBGLTOVWzZRaBMQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5mNNI1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5mNNI1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424071F000FF;
	Thu, 17 Sep 2026 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667170;
	bh=62rE3Fq1tshPLvHp23RW9OtT+GxeExIOD245WIdKafo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5mNNI1csQyo2rTTVC/gEprNVloC+I64GgEIQr+wY7eZpfjsSu1IpRCVzGPxUp4UD
	 aNTCqzwm1XNUAtRhCkWggCHiRSeW48tY5RRF1y76UT9L2PzMeGZtwu8ALtIHxTR0F0
	 ZSRJqtFwLKVQ23pcU9YCnvgwusNkJGd7fOr/OEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1229/1250] landlock: Add access_mask_subset() helper
Date: Thu, 17 Sep 2026 16:17:04 +0100
Message-ID: <20260917151625.601328484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack3000@gmail.com>

[ Upstream commit 45f2a2926b2187d1b08132d2728af50785b007a7 ]

This helper function checks whether an access_mask_t has a subset of the
bits enabled than another one.  This expresses the intent a bit smoother
in the code and does not cost us anything when it gets inlined.

Signed-off-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260206151154.97915-4-gnoack3000@gmail.com
[mic: Improve subject]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Stable-dep-of: 2c6dc7925382 ("landlock: Fix use-after-free of the source's parent directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/access.h |    7 +++++++
 security/landlock/fs.c     |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/security/landlock/access.h
+++ b/security/landlock/access.h
@@ -97,4 +97,11 @@ landlock_upgrade_handled_access_masks(st
 	return access_masks;
 }
 
+/* Checks the subset relation between access masks. */
+static inline bool access_mask_subset(access_mask_t subset,
+				      access_mask_t superset)
+{
+	return (subset | superset) == superset;
+}
+
 #endif /* _SECURITY_LANDLOCK_ACCESS_H */
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -332,7 +332,7 @@ int landlock_append_fs_rule(struct landl
 
 	/* Files only get access rights that make sense. */
 	if (!d_is_dir(path->dentry) &&
-	    (access_rights | ACCESS_FILE) != ACCESS_FILE)
+	    !access_mask_subset(access_rights, ACCESS_FILE))
 		return -EINVAL;
 	if (WARN_ON_ONCE(ruleset->num_layers != 1))
 		return -EINVAL;
@@ -1717,7 +1717,7 @@ static int hook_file_open(struct file *c
 		ARRAY_SIZE(layer_masks));
 #endif /* CONFIG_AUDIT */
 
-	if ((open_access_request & allowed_access) == open_access_request)
+	if (access_mask_subset(open_access_request, allowed_access))
 		return 0;
 
 	/* Sets access to reflect the actual request. */


