Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A051596E;
	Wed, 30 Sep 2026 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787102; cv=none; b=nJ7O7pfNQjAT3/yEo9HwbiStp+zcXtEPpFrR05myWSBJzXRiUFfzj3CCX5fMDtSI+lnt5obL+5OEZ9uW8fUTwEtkISm2spZ8GcnheiXoAbIduYKQj4rrtxx86gu3l8fYh/4rd5v477mDMGvMbYqNm0widf5eYspbpgTsyUmGPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787102; c=relaxed/simple;
	bh=EL88ZaJbTJp/PaBFafA9dyciqhFDx8117lfl9sxZRWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBTCWxcsu3unBfAwLNoloIKOWgKW88kccL8F33w0nzDmV2n0ejSshQnForl8ni7H7OdW5yO3Hi4O7qRX9b2S5f00no2HnuGA6xvXPEl3MeVbIugOzQtRs/ErWikdtlvjoDKs5k6TglYMmknKbjDXuhzgsCXUo0RBVm4eHhp9lfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taduAg1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taduAg1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321D51F00893;
	Wed, 30 Sep 2026 16:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787100;
	bh=U+u873t0tDBmhHN0KpwcaqJEm2bvfxrvxnVA0y67nmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taduAg1xEYiA0m3GxOV2agaUuc/WJ0x3ckEOgOtYbo8ou4JmuaMmK+qyX3J0cZb7+
	 7bYuw965yEYZ727BQYUTOz6DsHttEOu4jkVtpAPvU/Xwuy5SQuuAMNKTwK2Gw+W4K9
	 fwvU37+0yfEgQ2wkEC5yS8ZLmPOpQg/3twuI+Yeg=
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
Subject: [PATCH 7.2 058/457] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Wed, 30 Sep 2026 17:22:43 +0200
Message-ID: <20260930152347.291350349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index d83abded2039b..f25ed22195fa6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7886,7 +7886,9 @@ megasas_resume(struct device *dev)
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



