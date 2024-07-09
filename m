Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A717B1581FF;
	Tue,  9 Jul 2024 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524008; cv=none; b=MpheUEh0fyIEKvOtZ9y3LR3GRwTuXBV8wQmdWgUg9JD+zonyNLMXimjDwnKQ8AP+/VX/YKVrBQSX/d+CYfPxSbSNO3edVGbEj/tIc/mvcFPlwz+aEnPU+fZi0k+fGfINPsaNKPFHrb3uhydvbcMbb9oVfNF4rtZRolDbwtlCAh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524008; c=relaxed/simple;
	bh=UQAzdznwAJuxpKuTv2oBnv5k4mc4+G6yd0wZ2L6hNbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0z+NYxRNkgV9N27ZH6ll/hkzvlNcykUCwM1bnV5r6JFycbeVkZOeZ2pvRRj3psSGFEKePY4X+0qT/i6VaoKpuunYKBfdNg6H5l94QoYSOnsFFwcU5W3UKkTNd5WjMnAmkrQA2UBIcsXRAMutP082qLMiMieVnNU3O/i/U3+nvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXRDGsg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXRDGsg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FEEC4AF0B;
	Tue,  9 Jul 2024 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524008;
	bh=UQAzdznwAJuxpKuTv2oBnv5k4mc4+G6yd0wZ2L6hNbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXRDGsg6REXGvfNJ0lnYQCKwLwSM5lYYnc6NZP6Q8KUH1NjsvoKo6ZTuVolUmHRX8
	 /eeTwVAWltvfmH4QW4Au6UufLtHU2VugtBxnwVcnEY5J77ZVNK5Ab3iBUrCOdC0thd
	 6BE3f4nb/1LaFOP4Z+LbmTItgejYPnGeULnEc4HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 041/197] media: dw2102: fix a potential buffer overflow
Date: Tue,  9 Jul 2024 13:08:15 +0200
Message-ID: <20240709110710.505420401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@kernel.org>

[ Upstream commit 1c73d0b29d04bf4082e7beb6a508895e118ee30d ]

As pointed by smatch:
	 drivers/media/usb/dvb-usb/dw2102.c:802 su3000_i2c_transfer() error: __builtin_memcpy() '&state->data[4]' too small (64 vs 67)

That seemss to be due to a wrong copy-and-paste.

Fixes: 0e148a522b84 ("media: dw2102: Don't translate i2c read into write")

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dw2102.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 10351308b0d02..f31d3835430e7 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -786,7 +786,7 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 			if (msg[j].flags & I2C_M_RD) {
 				/* single read */
-				if (1 + msg[j].len > sizeof(state->data)) {
+				if (4 + msg[j].len > sizeof(state->data)) {
 					warn("i2c rd: len=%d is too big!\n", msg[j].len);
 					num = -EOPNOTSUPP;
 					break;
-- 
2.43.0



