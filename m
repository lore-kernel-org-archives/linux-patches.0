Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF034481A90;
	Fri, 15 May 2026 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862118; cv=none; b=FiXftobUWWbGYdw5yQkKYSbo9xd4Lo4GbQdn9iCpryaJ1lYz7ZL4l9ycirBNlRkeOcb1Fz8JEm6bjhiYPdERn6vgkrUtGFdzZycZGwipx7qzF3C36y7Uz5ewxoxgBTbQAlfChP1kznNUu2RxQEGTqLzIu9P4ltDdc5ZMip9V1y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862118; c=relaxed/simple;
	bh=/H/RtRh7e+FcncFepzQ1wPxUlaH1Mz+4Aut9eXaxwBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWDFUBmTcUqke6M3K1xFDl9v5sonw2wzKHeTsk2iPtyEK7mbqvKgE8QS/mFNSHg6LU8vO6stnvuYo1YWQpjj2yv97o8vJXREQ0vMNULiPkaVStaCjyXPSXCJa8rt7Ezih9APxs1iAUIdK6x2LMggQGtOOEhTcRPIvMeuLnYvzV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BV85uugd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BV85uugd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44284C2BCB0;
	Fri, 15 May 2026 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862118;
	bh=/H/RtRh7e+FcncFepzQ1wPxUlaH1Mz+4Aut9eXaxwBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV85uugdWH8bdm7qeocCn67L8FUpnP+h2WWzxo0R1g8dvtkvmdRjQdciTDOyVFned
	 R6SB3DjPsS3WS7ajbJ5U8oCM7UopJsRShJVwIp70Ff5UCtpiAh3EcWK7QeIxiTp1lY
	 OcVGzHmi3RPDIzPNwJIm0TYo4eridTI0HWUhY8dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 108/188] drm/amdgpu/vce: Prevent partial address patches
Date: Fri, 15 May 2026 17:48:45 +0200
Message-ID: <20260515154659.672353225@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -656,6 +656,9 @@ static int amdgpu_vce_cs_reloc(struct am
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


