Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E5D1A5BA4;
	Tue, 11 Mar 2025 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706806; cv=none; b=teW8Sh2OTKxWgRa6KiCjBPO9giVcrDRkC/allfGIcN52fhX/Pn+2dkVb7W2btLcr5RZ7Jr2CheJxnWST/WCrDURvylJBH1S1rwClyKn0ouytsx479RcpgSE/MdSmT1b3vXG1OmzvsBWWWFgYaf6ieI0bRR3cl4thrigdi09bLVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706806; c=relaxed/simple;
	bh=zdS//MBlJ5C7xbpP4XEziOi2hUfUtRY/fFwf0YVQr4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRUcdQaAgVP+T1DtACw4+XStB9wMyaLNDXJ0QxhEPjIf7XhaBuWemE4bkrn45ye4Rg5/uWL/05pIrFOkxnLBmf6Yc6YULb0MjsLSSgtfTN/ThOWYAFO1zqz72XYyJGZ0ZS0Qk3yJuZESrQoqKXiYc5lulZmJ87vsx19U5yii1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbgAAC7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbgAAC7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8153CC4CEE9;
	Tue, 11 Mar 2025 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706805;
	bh=zdS//MBlJ5C7xbpP4XEziOi2hUfUtRY/fFwf0YVQr4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbgAAC7wxDPdGTRaIcJzqYSXsUZjx/qL8owhOUvEidee4JM2IkaYEvDQvQ+5aWUBD
	 i4WnOAW9HeF1fCMM1Ts/TC3sUzpdOaCL5V/v9RWpffYXNY1Groji1G9RxHZksL8Att
	 uRFoRun7ZaMMzttn7o5JqW35TauWCdpYa31qYgXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 5.10 172/462] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Tue, 11 Mar 2025 15:57:18 +0100
Message-ID: <20250311145805.148853151@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


