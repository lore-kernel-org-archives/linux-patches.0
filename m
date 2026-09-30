Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F1951EDE8;
	Wed, 30 Sep 2026 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792856; cv=none; b=abJ7KSz9lCVsxbbUhw0Chz7L6la0xXD8Da48WNiLPcZC4/t6OXsA3quPHKSswWr8Jiu+WsqLuQdiqrUDAIkmEY3RbO6t0IJXCwB9Yfli5jqbxmng2s6Yzurunn1otbMFrHPkggV7C/HKbrWpmKaXAjIJXm9U2t3ooov8UDixBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792856; c=relaxed/simple;
	bh=diJn8iTRP32U8myUHffuRzoSiKdg6dYRzgrs6P+0bLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVyp4oJOcSN5ITKF+1ZFMkBkIg05X8lC/e6LaHfQQOegK3tPkJ43ugxVBl0UBNDuR/CxuFwYV0IIvQ55+SQw8+JiIUZoFC2krBUienHeqndZYfExnPIOY3uAETAaKDHJgsqQ1in4je35qH0JDTFwCkI0Ck5ysfh8vvab30t//x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sn88gK+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sn88gK+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BCD1F000FF;
	Wed, 30 Sep 2026 18:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792854;
	bh=YBVPTmpwIlmdmOnpvx/D7JFEeU3rfVxxhc1N5zDQD/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sn88gK+CDTszXZEw3TuFZ5MjW+x2Fgmzn6gd5XBwOXuR7+ejdx9L74zbTM8p+Pw6e
	 cbqsY3hbD7bd9UVQcd48ZytTvOWAdTacFZ/jy3K8Cvkj8CVOKCV2YIPIk/3tlq68fk
	 s5axRBrazLR6yfiLgpiyo6VmRRO5nYSQgWcLjWFc=
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
Subject: [PATCH 6.18 049/395] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Wed, 30 Sep 2026 17:25:11 +0200
Message-ID: <20260930152341.698183121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d578b476d9797..116b5ecf15d6f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7887,7 +7887,9 @@ megasas_resume(struct device *dev)
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



