Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1B350851;
	Tue, 26 Aug 2025 13:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216176; cv=none; b=bU/EyCrga26NcTFHwRBt/JcYJ1R00ZNnVg5L+QakeADU4dlWrlDKyq/dUitLVetEPrrR9ox1ifWoRm28G305Ggy2h9W/yAOzBtS9sM5ffEORvR6n+pbyQfd2YsyYfuZkcYzZSOCaY4rWSgRCEg1iRoI2T+r6aFgfGBBv9a97I1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216176; c=relaxed/simple;
	bh=RmcfBBdtOU2JX/TbevEafoiuYmvI8IRKhWGewa7QHBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+wbHcM0xOrl52Eyfy8kJldTDpkg5Ms1yHXIQv2gPtaAgmZU2KcvbBoaOnKXhZLX0pgBnuI77vTeHqH/2V07/8Q7wRTvEx+eTxS3S3sVG72v5J1vi3wBYolfDxhYt6EhsIWMO+5eISTofRbYt5Xhmx+5UCALE+HPDZmLVMYSVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tS/rZI/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tS/rZI/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D314C4CEF1;
	Tue, 26 Aug 2025 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216176;
	bh=RmcfBBdtOU2JX/TbevEafoiuYmvI8IRKhWGewa7QHBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tS/rZI/g8Yf6o+ba4Hqym/7GbB5WcsRJPPLF8wPh0+dw07LbC2J9b2P0+6ZHtQK0a
	 DageaXgte+hDaiiD36SHSZgsa4JpcA1B0YZ0Nj/86xUva/68dz+GsDNGln//UBSdEu
	 EhZCrlLZlgJvEw+MdGzVSW9L2siAP4ty69Qv6ooQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/644] PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()
Date: Tue, 26 Aug 2025 13:06:45 +0200
Message-ID: <20250826110954.166640659@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 89d9cec3b1e9c49bae9375a2db6dc49bc7468af0 ]

Clear power.needs_force_resume in pm_runtime_reinit() in case it has
been set by pm_runtime_force_suspend() invoked from a driver remove
callback.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/9495163.CDJkKcVGEf@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 35e1a090ef90..26ea7f5c8d42 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1714,6 +1714,11 @@ void pm_runtime_reinit(struct device *dev)
 				pm_runtime_put(dev->parent);
 		}
 	}
+	/*
+	 * Clear power.needs_force_resume in case it has been set by
+	 * pm_runtime_force_suspend() invoked from a driver remove callback.
+	 */
+	dev->power.needs_force_resume = false;
 }
 
 /**
-- 
2.39.5



