Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2B13E9C1A;
	Wed, 30 Sep 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796631; cv=none; b=hcuL1NDev6j6CkrFbpEG4ceFpIde2t0mSltxZx4uNwcbSLoCawvp/ijI2b9K+KJS8rwP38h5XM1U77n2zYFp6alfPm798t9LhlQY+Ac4jjZrBrPKI1YvA4E0xiQXwPeFP0gOYEFoHlQC6PqkpjX4Rvhw9gn6WiwId0st+SMdTdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796631; c=relaxed/simple;
	bh=96004hWZWb/JWx4DFeBeJjxx/+2a1LmL+nG7/rJT8vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiHeHErum6Kq+I/FE3IzfhA9k2qrl4Xp2r/RWKawDmX1WI/fI9N+g8el0fuKlmaoNyx2Fi5nWSSr2yBbNb2GTK2EypFwvB/qTyISbncVRrPpgouyA/JciRRs5Kz9c/35gJmFx+2TfFTBqo82YJuRFgUnxgawgkLB1DWb/tI9jyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i08fPIZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i08fPIZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A48B1F000FF;
	Wed, 30 Sep 2026 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796630;
	bh=zjHVCCMmSmxgpt5AlQ9d6tbIjsygfEsuLm9FkvY4m44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i08fPIZypTbFrZZ6Vlz55LNKYDMN17wzA8/Kvxhk7LnH6lAdqFmb8u6vpM8eVNVef
	 68hKbMBDe4XHezMn6gZKwxLaTNa0SucYJ0wfTsjwnahpY2W+RzVy0BpWHWmMcOugtW
	 6Yre7fH5yA98lEmfSvixQcvVNxBlHqcPiAMZpq68=
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
Subject: [PATCH 6.6 0980/1193] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Wed, 30 Sep 2026 17:27:44 +0200
Message-ID: <20260930152456.017739988@linuxfoundation.org>
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
index 54f66142e14a8..b3f1a45a03b5e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7871,7 +7871,9 @@ megasas_resume(struct device *dev)
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



