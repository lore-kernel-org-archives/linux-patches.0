Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7720312807;
	Thu, 27 Nov 2025 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255146; cv=none; b=oREYLljtiQhp7hGC1Sbnq7lvF4hw0qj7ILSWt9HIbrj9QJwgMyAVL0i4rZQPOWcH3weB6lYrePz3d7ca2l19UwLBfffAIHBg2pc9B6CE/lPHWXKxJSXm7OEl0ZdBCnOXlNcyLqrv2yGGP/H0fIhVnJDBnsljrd4UNeUhawzR2cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255146; c=relaxed/simple;
	bh=2fLNih6JhnpcV1568ZAgITrXeXH7533SZVMUhFiENAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKcFYY8Y3nzqfccaoXkEJJwKEOzgX3+Zbq43VlmYLIkXyX1x0022gllf4GBzdyfWhn5MRKlbOePPTIoCtkDjxhRdY52hDqTGbkt9ntYL9xOoQgS51686M+CI08KZWme8lyS6nd/pf5jy1mxyVCwnwhffjzCgOwCOtgVLagj7/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bc/I9Yxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bc/I9Yxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29101C16AAE;
	Thu, 27 Nov 2025 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255146;
	bh=2fLNih6JhnpcV1568ZAgITrXeXH7533SZVMUhFiENAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bc/I9Yxc0m2oKcxgxarEYTQJ/ymakphF2pjF7iGrceY1tdZHN4x8X0//CamgVXtbc
	 MuTd9UcRzV43DUgsVjTkW7u7uM4yS975GqPYmkttWhoykkVy2gVp+j7F2tIpi6LaSR
	 E+vKaexvP4PXKXgDTYytvjbukHNcrMPYBft/HUs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titas <novatitas366@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 003/112] HID: amd_sfh: Stop sensor before starting
Date: Thu, 27 Nov 2025 15:45:05 +0100
Message-ID: <20251127144032.836752330@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 4d3a13afa8b64dc49293b3eab3e7beac11072c12 upstream.

Titas reports that the accelerometer sensor on their laptop only
works after a warm boot or unloading/reloading the amd-sfh kernel
module.

Presumably the sensor is in a bad state on cold boot and failing to
start, so explicitly stop it before starting.

Cc: stable@vger.kernel.org
Fixes: 93ce5e0231d79 ("HID: amd_sfh: Implement SFH1.1 functionality")
Reported-by: Titas <novatitas366@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220670
Tested-by: Titas <novatitas366@gmail.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -172,6 +172,8 @@ static int amd_sfh1_1_hid_client_init(st
 		if (rc)
 			goto cleanup;
 
+		mp2_ops->stop(privdata, cl_data->sensor_idx[i]);
+		amd_sfh_wait_for_response(privdata, cl_data->sensor_idx[i], DISABLE_SENSOR);
 		writel(0, privdata->mmio + amd_get_p2c_val(privdata, 0));
 		mp2_ops->start(privdata, info);
 		status = amd_sfh_wait_for_response


