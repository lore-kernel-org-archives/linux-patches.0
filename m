Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B1983CC8;
	Thu,  5 Sep 2024 09:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530350; cv=none; b=SDoRuCGbZb2/nRA6+c7H4jufqijaYYinsQF1dCDwYp7rW8KyGb28gSJEvEeK4RjPdtH68Np6pD4D1yBCBOJaSp6smvGQlzkju0THAuvaoDaEIc0iLJWAh+OzYFHPzST+d36kwo9jqTegAtNgLo4FTRP0SDz97BEllFyUsoQ8y3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530350; c=relaxed/simple;
	bh=y82+R9/W6lPZBKuV9N0Ef96GLCFtciRnMWbLLKdtKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4KvdEKFVzsXUTZVfqWMBlgacpmYqnn4VFSTAgcxHG6NGYqjmLHI68oioLSf0YGoYGM+8K8wSdwUS0H3VB/p4KPPAxxZghN9X7bpA84yJo1vw0ACj67bXuz6P6rckOz1CT9XgDuodSfDSXFpr6IzYNdoq/BUJ6+3qsf+bZhSAFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDH4WyPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDH4WyPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC25C4CEC3;
	Thu,  5 Sep 2024 09:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530350;
	bh=y82+R9/W6lPZBKuV9N0Ef96GLCFtciRnMWbLLKdtKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDH4WyPKKsWNexts3pLDzr4qUR9pGeIX75MP3CrirfYr0D+m39FLOJF94opzQDU0+
	 t1INFDOYgMxRMSVdWc6JHwxUzknLjATgayDVlkV1m00qKA1hTRoGPzwocct3S8YW6W
	 2nQORS67oMHuc1nlN4nbmmk5qMfU3DEo/H1Zjkkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/132] media: v4l2-cci: Always assign *val
Date: Thu,  5 Sep 2024 11:41:26 +0200
Message-ID: <20240905093726.091275382@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 7417b1b1f36cc214dc458e717278a27a912d3b51 ]

Always assign *val to 0 in cci_read(). This has the benefit of not
requiring initialisation of the variables data is read to using
cci_read(). Once smatch is fixed, it could catch the use of uninitialised
reads.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-cci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-cci.c b/drivers/media/v4l2-core/v4l2-cci.c
index ee3475bed37f..1ff94affbaf3 100644
--- a/drivers/media/v4l2-core/v4l2-cci.c
+++ b/drivers/media/v4l2-core/v4l2-cci.c
@@ -23,6 +23,15 @@ int cci_read(struct regmap *map, u32 reg, u64 *val, int *err)
 	u8 buf[8];
 	int ret;
 
+	/*
+	 * TODO: Fix smatch. Assign *val to 0 here in order to avoid
+	 * failing a smatch check on caller when the caller proceeds to
+	 * read *val without initialising it on caller's side. *val is set
+	 * to a valid value whenever this function returns 0 but smatch
+	 * can't figure that out currently.
+	 */
+	*val = 0;
+
 	if (err && *err)
 		return *err;
 
-- 
2.43.0



