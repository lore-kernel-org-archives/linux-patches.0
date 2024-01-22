Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B163714DB4A;
	Tue, 23 Jan 2024 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969365; cv=none; b=bDQGLRexjTOjpn4cMphUSgHc+TeUDafGY4by+VfjqcnlVwZLppUP0dA+k7iWdcYvhM6rYBLAOid5c/otBMMEUk2n2Y/d39lM4dAovA8zeRbS+dIx9MMH6Wa1SYEcEmf/uevTIm3RBt8DCkAVksJmFfORazI+HdyAsxlygQA4SNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969365; c=relaxed/simple;
	bh=HzM0q1sLMLW+/SAyGxXdsdvN51eH8QX2zHn/WNnydtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlveFMsnlNqCa5Gy76cXtgv8dWti/TQa1Y3tjCDK53IoXHiYhO5ktCuZJDimZeU6F4irE9CL+zt50AKbBqNu2jqd+LIYBQT2Q5hPK/ONPX7TGbDB8NC5BVJIx8OTqwodpjt96qv2amQ1FNjMD3x9d+LLle9ngfmHY3yJ/xaDsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp5hVTip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp5hVTip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C45C433F1;
	Tue, 23 Jan 2024 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969365;
	bh=HzM0q1sLMLW+/SAyGxXdsdvN51eH8QX2zHn/WNnydtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp5hVTipUjVplAfYABEEpYTVGWDggcAQXvhkmyzP13m1JJ96HbxQwAO3FD90BQTqj
	 1y4vAw+81KJjR4bsKkQ8JohejuPzkVj6wbf9mXltdT+pOt+7PJtP4cwhck5cTsw4+T
	 v7Gso4eyJAVCRtAsQDhDPCHdWCeg0ZrqmuNG6/Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Deepti Jaggi <quic_djaggi@quicinc.com>
Subject: [PATCH 6.7 197/641] firmware: qcom: qseecom: fix memory leaks in error paths
Date: Mon, 22 Jan 2024 15:51:41 -0800
Message-ID: <20240122235824.128478448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 6c57d7b593c4a4e60db65d5ce0fe1d9f79ccbe9b ]

Fix instances of returning error codes directly instead of jumping to
the relevant labels where memory allocated for the SCM calls would be
freed.

Fixes: 759e7a2b62eb ("firmware: Add support for Qualcomm UEFI Secure Application")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311270828.k4HGcjiL-lkp@intel.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Deepti Jaggi <quic_djaggi@quicinc.com> #sa8775p-ride
Link: https://lore.kernel.org/r/20231127141600.20929-2-brgl@bgdev.pl
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../firmware/qcom/qcom_qseecom_uefisecapp.c   | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c b/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
index a33acdaf7b78..32188f098ef3 100644
--- a/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
+++ b/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
@@ -325,8 +325,10 @@ static efi_status_t qsee_uefi_get_variable(struct qcuefi_client *qcuefi, const e
 	req_data->length = req_size;
 
 	status = ucs2_strscpy(((void *)req_data) + req_data->name_offset, name, name_length);
-	if (status < 0)
-		return EFI_INVALID_PARAMETER;
+	if (status < 0) {
+		efi_status = EFI_INVALID_PARAMETER;
+		goto out_free;
+	}
 
 	memcpy(((void *)req_data) + req_data->guid_offset, guid, req_data->guid_size);
 
@@ -471,8 +473,10 @@ static efi_status_t qsee_uefi_set_variable(struct qcuefi_client *qcuefi, const e
 	req_data->length = req_size;
 
 	status = ucs2_strscpy(((void *)req_data) + req_data->name_offset, name, name_length);
-	if (status < 0)
-		return EFI_INVALID_PARAMETER;
+	if (status < 0) {
+		efi_status = EFI_INVALID_PARAMETER;
+		goto out_free;
+	}
 
 	memcpy(((void *)req_data) + req_data->guid_offset, guid, req_data->guid_size);
 
@@ -563,8 +567,10 @@ static efi_status_t qsee_uefi_get_next_variable(struct qcuefi_client *qcuefi,
 	memcpy(((void *)req_data) + req_data->guid_offset, guid, req_data->guid_size);
 	status = ucs2_strscpy(((void *)req_data) + req_data->name_offset, name,
 			      *name_size / sizeof(*name));
-	if (status < 0)
-		return EFI_INVALID_PARAMETER;
+	if (status < 0) {
+		efi_status = EFI_INVALID_PARAMETER;
+		goto out_free;
+	}
 
 	status = qcom_qseecom_app_send(qcuefi->client, req_data, req_size, rsp_data, rsp_size);
 	if (status) {
@@ -635,7 +641,7 @@ static efi_status_t qsee_uefi_get_next_variable(struct qcuefi_client *qcuefi,
 		 * have already been validated above, causing this function to
 		 * bail with EFI_BUFFER_TOO_SMALL.
 		 */
-		return EFI_DEVICE_ERROR;
+		efi_status = EFI_DEVICE_ERROR;
 	}
 
 out_free:
-- 
2.43.0



