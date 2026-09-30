Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D153F6A4;
	Wed, 30 Sep 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790080; cv=none; b=mw/Laqca1U/h+frOFI8ySG/D0X2aWKmtR4v2Jr7iysKzyj0YpaLZlf2sd36hJXgbBlvhEVbvr6NYylP506iBMJrkXVJdXvQ7MWBWPjLPA6sVe5rLDjC0PsSAA219QwdJP4QtG1bWGVzE+7bwufBZus/spCrb0VJciUDDSNSh4uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790080; c=relaxed/simple;
	bh=LQ8HZCWEGcEdLDQcPeooBNPoQzXLGVO67du5SifxWmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ts6rL+zg1ulZf4ZLjiaWdP6LDelMQmHn+0WOh4/bAUXnliHb8oKMw6YPjVns+PWEBnzugmTeeE67r5pXkrnp4cA0kgmoLv5DJcN5IX66XbajuXtBJWTQN16rSslJltwj6sOtbj7DcMIAepQOt23RB13YjPqgwljsuQIPvt2ONZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZKUjf3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZKUjf3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F52C1F00899;
	Wed, 30 Sep 2026 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790078;
	bh=3Z6q0jTePKbjydNc4E9lnLXJXKJaBYRMayiLHCv9Dmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZKUjf3ekXmYQb8TDjX/m/HL+tCm/87DQRe4KJ6Fw3+L5wWUxVJw2LYhuxCJYVMpx
	 gCXHFMvqMxNj9VB08loreXy1XX1LRZ35Sy5fv09RMbPrxEmlb1EaiAfGji0ps811+S
	 LeDYYpTdMpYWgqW7llizsNCGCovgiymkZ0yXHlEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 704/877] drm/sysfb: simpledrm: Improve stride validation
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152429.875606030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit df6533f11688aa30be3bb883c7637f4ffdbb7cbd ]

Validate the computed stride against the maximum value INT_MAX.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 7bfa5c7b28d6 ("drm/simpledrm: Compute linestride with drm_format_info_min_pitch()")
Cc: <stable@vger.kernel.org> # v6.1+
Link: https://patch.msgid.link/20260625094509.157581-5-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -896,9 +896,15 @@ static struct simpledrm_device *simpledr
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
 
 	/*


