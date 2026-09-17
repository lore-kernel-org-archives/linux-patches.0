Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB0F4F96B3;
	Thu, 17 Sep 2026 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661310; cv=none; b=Rcih5xgVMX28a+Fu0FmvVjHcjRDaqHVFMG1C5/zX/qQuKasEX1j6bt1oQl/r7LSCre62dyhPuFKkpfGkcQH+WOAH4Lu76EsKy/n1aDaW9f8vPlZjHrce5N9Kg2283zGlf5H0DwWElVS9/2ksUD994fWqM5skfK9Ou/637XtJHzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661310; c=relaxed/simple;
	bh=gsQf6eniFY6K69I2lff4JTkRALVZCsIcYjZfsNQMaVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SC8hUIgKaGcW5kjjMStjNQWnwop0E8LzxrYzska1Lr833IhImjd7jwGwkaD1Vbt+DuSRlxScD0Jq152XEOzlFeRIusAaPfZxWNlm4EWcT2ctNWMQ+2UdIqEkxgzcbHmpZVVNyB2xGl95eUca7MmMfI1cztoSQbcSIbM6V8vtsn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tq1+kCaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tq1+kCaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C1F1F000FF;
	Thu, 17 Sep 2026 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661308;
	bh=LcP55YviaRoyGbIkJQpKJCHOtgqmpVO5KM6p/ZvtgjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tq1+kCaJiJB5y43nDXBWiBC8xCcVKVE915m/2OPsaUcjxRNa3MqY78eLoHoLufi3n
	 ps7Yej1r6YA/chPJJHtDTMdpWWBtg3b20saQOXfudY+sd67Y5Z3QYAT1yxta/tHi4r
	 S4ToCFlSL4RRi1F9GqinHXQ4tZjxXKEQ9J2Mzctw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0152/1250] drm/amdgpu: add first record offset check
Date: Thu, 17 Sep 2026 15:59:07 +0100
Message-ID: <20260917151556.193362244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 4073cdf6713b7c170e35bf055354580cc52085d6 ]

check the upper and lower limits of first record offset

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index dafa46a9656ca..652aa085b6263 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1439,6 +1439,14 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 	}
 
 	control->ras_fri = RAS_OFFSET_TO_INDEX(control, hdr->first_rec_offset);
+	if (hdr->first_rec_offset < control->ras_record_offset ||
+	    control->ras_fri >= control->ras_max_record_count) {
+		dev_err(adev->dev,
+			"RAS header invalid, ras_fri: %u, first_rec_offset:0x%x",
+			control->ras_fri, hdr->first_rec_offset);
+		return -EINVAL;
+	}
+
 	control->ras_num_mca_recs = 0;
 	control->ras_num_pa_recs = 0;
 	return 0;
-- 
2.53.0



