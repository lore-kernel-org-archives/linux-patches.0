Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904D18E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVyNbbTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4B4C433CB;
	Mon,  9 Oct 2023 13:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858614;
	bh=SvJOSD1cZJ+7iezcHIx5SOYH3dlicc+ls9nTZQ58dxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVyNbbTTYmY6Cue5eDm+ITg2bjSC6RaUoS6FZl1yCGq7N0/jxH8pBAuoIO788HvWu
	 V7bY++pGZgpV1WH7ZuBgWFJyFJe22Sm8Uad6ZFBiEXF4IG9Bp65oOS+VWkGeroFHtn
	 CdLDEou9JQ5egLVVud2FRrm1Anq6ogXgjD+YmRiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Stephen Boyd <swboyd@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/226] platform/x86: intel_scu_ipc: Dont override scu in intel_scu_ipc_dev_simple_command()
Date: Mon,  9 Oct 2023 15:00:06 +0200
Message-ID: <20231009130127.974004987@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit efce78584e583226e9a1f6cb2fb555d6ff47c3e7 ]

Andy discovered this bug during patch review. The 'scu' argument to this
function shouldn't be overridden by the function itself. It doesn't make
any sense. Looking at the commit history, we see that commit
f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
removed the setting of the scu to ipcdev in other functions, but not
this one. That was an oversight. Remove this line so that we stop
overriding the scu instance that is used by this function.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/r/ZPjdZ3xNmBEBvNiS@smile.fi.intel.com
Cc: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230913212723.3055315-4-swboyd@chromium.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 4c053c715cde0..60e7f95bc5554 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -444,7 +444,6 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
-	scu = ipcdev;
 	cmdval = sub << 12 | cmd;
 	ipc_command(scu, cmdval);
 	err = intel_scu_ipc_check_status(scu);
-- 
2.40.1



