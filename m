Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C450325BEE8;
	Thu, 27 Nov 2025 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255069; cv=none; b=pGHKL9RgkL/zhILYWCs5AFFbJOpfenPkfqGi6xUInO8XckzS6O98EpttmrYGJSf9MwoahUNTcHtv1J9hVMOE6mnYEYgY89B5zRbMud6fYRHT0pMudsnLmDEgXSLHqvCQej+eVVt967FnfgjH6Glvjqm8Cz6CN1YlP/UO7b+UeNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255069; c=relaxed/simple;
	bh=JR55J47Pylrhz4QmcHZuX1J7I4yKLsXVprUwkh6CTJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT3GwYHLl8cZIaz1d9AZCHKGLEczTSSHpIrvP/4VbHcdMr3YLNyaVwNH03BF5uJw6FfGEC8V5UuZWzARGmHu7hB3T3LnchPtusJPDHeIrBtd7wLRCTmAlLKUkgENry5yHXmUAQEJndZOmhtA65p1+VlOxjpnKUzp8wNK2u0gBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cD93320p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cD93320p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B08C4CEF8;
	Thu, 27 Nov 2025 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255069;
	bh=JR55J47Pylrhz4QmcHZuX1J7I4yKLsXVprUwkh6CTJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cD93320p8cNbEPfkwkQPRgOmcqz6wd+UL1R9I20WgZTRD4Bbc3VSJfd5DKW3o0Q8s
	 nAdp4ZXueUNzcfwVOrg34xsYyA4b+IvHjvn5FKpI4J/cneA/6itexIXI9Ylkehok/K
	 gTU3SBzzj+oPpy/QNr656rGe5A7i6Yb5KvIisw3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titas <novatitas366@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 83/86] HID: amd_sfh: Stop sensor before starting
Date: Thu, 27 Nov 2025 15:46:39 +0100
Message-ID: <20251127144030.870142065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 4d3a13afa8b64dc49293b3eab3e7beac11072c12 ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -163,6 +163,8 @@ static int amd_sfh1_1_hid_client_init(st
 		if (rc)
 			goto cleanup;
 
+		mp2_ops->stop(privdata, cl_data->sensor_idx[i]);
+		amd_sfh_wait_for_response(privdata, cl_data->sensor_idx[i], DISABLE_SENSOR);
 		writel(0, privdata->mmio + AMD_P2C_MSG(0));
 		mp2_ops->start(privdata, info);
 		status = amd_sfh_wait_for_response


