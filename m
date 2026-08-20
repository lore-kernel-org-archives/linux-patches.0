Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB01367B9F;
	Thu, 20 Aug 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238664; cv=none; b=BmlKg2+QSQTR6FGUrfX2WMIkqC/WQaq+LXouf+bgGx996A7K1VdhbGvh0i2PZXjZ5Q5PQ+oXM7a3CCe639LMH5+bNk2rqQc9D7toIFpPX9GOhSNGiI4W2a4D2EWrwO8hAJ96JA1zfsE2bhvnNqSki1kAwWNeWjQM+xiIi2HY8pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238664; c=relaxed/simple;
	bh=J9lBrWE3Jpv+XGwzmTuk2nTslQpqIyqfg09HTw0SalE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwTcNIv4TOp/a4GoTY1FhXTGCH67KXgqSrhY4ptXSb1xNV2ompfB7ME3o1dJpg7vZe5V3/JNIqa9RuJ3h7gkErp6XxrN8fkfXqzbGVeRqv1PaKrmTZa5nYRo9fvy3BoFNNPktJLXjQyjJ2/jH622h7NfZgH4NC7HgXdQTDNpqQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbE93q7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbE93q7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A21F000E9;
	Thu, 20 Aug 2026 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238662;
	bh=p4c/hOeOS55Ggm7wTZ1YioqVdFbJj47BoN90xv4dcFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbE93q7iFZtahOHsvAMajZU+gNDIUO33YxDeUWmoWm38O9a9/weIYiKfhacnZprCq
	 proiL49eRBErEEZ0HYe0pkCuZ0EUjgRl26dyBhsjrf6aLwdErVTd5SBbDK+a0iDchK
	 Hqg0kQvdH1QJNaJuDSWdHSF4zJYpSHnrdrUDscM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 224/228] drm/log: Fix division by zero when scale module parameter is 0
Date: Thu, 20 Aug 2026 16:56:06 +0200
Message-ID: <20260820145251.884529435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 921ac6cb066d09b5765db892d0db0ffaffa98767 ]

The scale module parameter can be set to 0 via kernel command line.
When scale is 0, scaled_font_h and scaled_font_w become 0, causing
a division by zero in the rows/columns calculation.

Since the scale module parameter is read-only (0444 permissions), it
cannot be changed at runtime via sysfs. Clamp it to 1 once in
drm_log_register().

Fixes: 8a4b913df427 ("drm/log: Add integer scaling support")
Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20260730014440.66323-1-oushixiong1025@163.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_log.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/clients/drm_log.c b/drivers/gpu/drm/clients/drm_log.c
index 8d21b785bead6..a3259b8f23333 100644
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -419,6 +419,9 @@ void drm_log_register(struct drm_device *dev)
 {
 	struct drm_log *new;
 
+	if (!scale)
+		scale = 1;
+
 	new = kzalloc_obj(*new);
 	if (!new)
 		goto err_warn;
-- 
2.53.0



