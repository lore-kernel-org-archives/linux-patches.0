Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D53389104;
	Wed, 30 Sep 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786326; cv=none; b=RSo42lQwAEqUWLGaBel7Etr1OcDEZyhPc9fA08psBVa5juhmLQ10Z4kukB+hBjtNvZ9890MFJR8NYIpfGTVqwZEfjImo2RYDjW2km4FOqiKyQqUg58WUykWki7R3nWXmXsb6Y5cJ+/KVrvejs5L860iaPvWmA2wur+gV3AsWESc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786326; c=relaxed/simple;
	bh=MWsXrxNNY6EwXKudB+leyfnrfF+fOrZ99aeX6Jjacro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0byW9xridXh02CC/KUiKA4OejSQn9wKdxwxQOZNOCV6L4CwsTvN+HDorgR0LhLBSFAjJatrjuetv3SUMmC5UgEcYQ1+f6Yb0EtD6CsWvD8hmXwwn8mGc9A707ZbjWo9Hx78IYtgM8aGeuI+0hwEdlF93NreBOJ4z9PqNrJkM7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWmwFLRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWmwFLRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0E31F000FF;
	Wed, 30 Sep 2026 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786324;
	bh=dAW5dKHNiNrigmH4s2lXutGoiuGzb82rqNnAgRCSNWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWmwFLRhxI3L3p4ptfREmFVF5n0S/13p2S548VX645Ey+00ORb2XDJoXlQ8IeH84T
	 UZiLMF3JQh/il/9ry++OlwpFkhAaB9hBl6d4sGF3RcbEfM51Jgt9cMZ1yR43lvUkby
	 Dzfs1XucJq1TtNBx9yNOKyUXCNCFUxZKZ7+J8CdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 821/982] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152434.394336989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 42d1221d321e55afc7bba9109a77aaf5a817c8a3 ]

Protect the megasas_get_ctrl_info() call in megasas_resume() with
instance->reset_mutex using scoped_guard().

megasas_get_ctrl_info() may release and reacquire instance->reset_mutex.
Hence, calling this function without holding instance->reset_mutex is not
safe.

Fixes: c3b10a55abc9 ("scsi: megaraid_sas: Update controller info during resume")
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0d398029b2afe..483df636fe865 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7872,7 +7872,9 @@ megasas_resume(struct device *dev)
 			goto fail_init_mfi;
 	}
 
-	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
+	scoped_guard(mutex, &instance->reset_mutex)
+		rval = megasas_get_ctrl_info(instance);
+	if (rval != DCMD_SUCCESS)
 		goto fail_init_mfi;
 
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
-- 
2.53.0



