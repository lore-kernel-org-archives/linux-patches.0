Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23E9217705;
	Thu, 12 Dec 2024 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016348; cv=none; b=XU8jGUr1IzQJBk08nZ0IjyIXLS8UMRztFnxUtkxZw8HJKjp4qTFOVo4hMmJNARS/MMMukKcyBiktNoF7T47S3g584WaUNiyF4uZijI1B7ZieEASGsfyNFHz5ztubCSS9+4CR9LFgOkRUOKYlvGAzoJJDEsD+RfGl7yibo5SWpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016348; c=relaxed/simple;
	bh=BV8GAUdrdkFdL22+WLbfHQmwGZnvz09bKTexGmQRurw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E65rDU6VL0Zke4wXFYp5iEBosfMqpkS7Hn/Ak+7Z+pWjY9gGm5s3JWx+JpblT3stkhnHJ930/FAQBULc77WSnXtl0zfIis6uMKjBDHLEPxgYjNODPgW+8W96b8LJ4ruh/uqfEDVx3CRvbeqkHZH6wRl3xNUrLMp+MPoKNARcmiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPiymGwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPiymGwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466CAC4CED0;
	Thu, 12 Dec 2024 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016348;
	bh=BV8GAUdrdkFdL22+WLbfHQmwGZnvz09bKTexGmQRurw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPiymGwBU9WtCg/tg1+OFmLskWO73yGpDidr81A2hxMbz39RR52vcKXRC5yo8JMLw
	 OpDHl5gaXA1TC38btphUBGJu6Z8W0q4gZ2sHSKZmWJcZ2CjCZ+eJij+oTVRJM0iF8n
	 9eYVxYpFEAC24yCMBUzIpUjGloxuKSPYFwD2/lt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Lo-an Chen <lo-an.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 174/466] drm/amd/display: Correct prefetch calculation
Date: Thu, 12 Dec 2024 15:55:43 +0100
Message-ID: <20241212144313.674152497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lo-an Chen <lo-an.chen@amd.com>

commit 24d3749c11d949972d8c22e75567dc90ff5482e7 upstream.

[WHY]
The minimum value of the dst_y_prefetch_equ was not correct
in prefetch calculation whice causes OPTC underflow.

[HOW]
Add the min operation of dst_y_prefetch_equ in prefetch calculation.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Lo-an Chen <lo-an.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -1222,6 +1222,7 @@ static dml_bool_t CalculatePrefetchSched
 	s->dst_y_prefetch_oto = s->Tvm_oto_lines + 2 * s->Tr0_oto_lines + s->Lsw_oto;
 
 	s->dst_y_prefetch_equ = p->VStartup - (*p->TSetup + dml_max(p->TWait + p->TCalc, *p->Tdmdl)) / s->LineTime - (*p->DSTYAfterScaler + (dml_float_t) *p->DSTXAfterScaler / (dml_float_t)p->myPipe->HTotal);
+	s->dst_y_prefetch_equ = dml_min(s->dst_y_prefetch_equ, 63.75); // limit to the reg limit of U6.2 for DST_Y_PREFETCH
 
 #ifdef __DML_VBA_DEBUG__
 	dml_print("DML::%s: HTotal = %u\n", __func__, p->myPipe->HTotal);


