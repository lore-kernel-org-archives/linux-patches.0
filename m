Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B03F23BF;
	Wed, 30 Sep 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796640; cv=none; b=L/syN6n0/NN9p+/ntgrdaCvBMeyYr4yz6hG608P5oqaUX0dKuftS9UXbDbUOBMS+ffUGyJ6midR2/fJ9BC0o2+LZ2aJQtOtFAiP1bpwhqQTtspDlCZT8zWtIeyz8NL72KUlXcd0CqmRAp92kfhkBQVRfNKFnBn3LYp+SFYcxqoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796640; c=relaxed/simple;
	bh=Q7M+hL83Qi4zbUPie89O44or6QO530fL1VGuqDLLzgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc/iTWfQaUN3M3iTd34G6cM0F/sQolc+sL43FTuchUzUs4W5MsgrBTfHSXA4qRNUkG2eXdQVAir5qwcL8R5G3Uf/GBJUWw4LTTvunY8kIzo5Onp0joFsi6lf9cTpa8H/HaSdZ+YisOEotmrVkjljcMmCE0Ui7n4janMeQiZY+tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwTNjPZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwTNjPZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115DB1F000FF;
	Wed, 30 Sep 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796638;
	bh=lgQipk/FBdKU3TvZzevUhfh+TagCHRrWg1bwwmu89NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwTNjPZ+wXD0vY4PJNIsfBkVxSLwMiPJ4CJWTOlmnrL/1290lV/uvgEFm+laH1iWS
	 RDGsbHZ0inzSZoJ+Ri3EBuMZNvDmi8L5ARf21X3aiaMSf+6e8nd/th39dd+vqon9OY
	 LZqQCjIzkE0LQVLKOqEGge0VEh2DQze39nciCEWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Bezenah <wbezenah@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0983/1193] s390/cio: Fix cio_update_schib() to not cache invalid schib
Date: Wed, 30 Sep 2026 17:27:47 +0200
Message-ID: <20260930152456.085832273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 29d9e5835d89223aa913dcf7b942cc1c148bdd25 ]

When pmcw.dnv is 0, the contents of all SCHIB fields are unpredictable.
Zero sch->schib in that case to prevent subsequent code from making
decisions based on unpredictable data.

Reported-by: William Bezenah <wbezenah@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Fixes: 8c58a229688c ("s390/cio: Do not unregister the subchannel based on DNV")
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/cio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 7843c69abee6c..28888abf6bd41 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -453,7 +453,8 @@ EXPORT_SYMBOL_GPL(cio_commit_config);
 /**
  * cio_update_schib - Perform stsch and update schib if subchannel is valid.
  * @sch: subchannel on which to perform stsch
- * Return zero on success, -ENODEV otherwise.
+ * Return zero on success, -ENODEV if the subchannel is not operational,
+ * -EACCES if the subchannel has no valid device.
  */
 int cio_update_schib(struct subchannel *sch)
 {
@@ -462,10 +463,12 @@ int cio_update_schib(struct subchannel *sch)
 	if (stsch(sch->schid, &schib))
 		return -ENODEV;
 
-	memcpy(&sch->schib, &schib, sizeof(schib));
-
-	if (!css_sch_is_valid(&schib))
+	if (!css_sch_is_valid(&schib)) {
+		memset(&sch->schib, 0, sizeof(sch->schib));
 		return -EACCES;
+	}
+
+	memcpy(&sch->schib, &schib, sizeof(schib));
 
 	return 0;
 }
-- 
2.53.0



