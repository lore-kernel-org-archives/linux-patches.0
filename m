Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0A27D786;
	Tue, 27 May 2025 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367585; cv=none; b=nGL8VqcA8nGVBHVXkckSW1KwEdVxhDsjosc9rmP5MhMfZ4yPA8ZYinCaa4gTShG6emRzJFbrn3YKzaQNtRFppFtY4S9dCjScZOwHOSNwa+VYcR7bd7H+zOr0SbA6ccacRVELOMBbFsPczHcu5lTRLeFAg+xAPq3WM3jAO2+286o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367585; c=relaxed/simple;
	bh=W0E2WPTDRMWf4ph54sVZVIIAa9fKUTRtTYJyKELXi10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i36gb9tWj5UWo8gIBocrDOPhApspctMvRmsGnz0EC39UpTQA1ZXvkcRuVGeXyNWQhc+sC2doptzEYTrvLlLaKZnOf6GLdS2Bzqn1TGjbU21DcRh5W96sDtcbo+LQh7FxBNAcg3MnfqMVtKcuy5X2gLtnP17/34BzSliEr05Fr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXPTID8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXPTID8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A1CC4CEE9;
	Tue, 27 May 2025 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367585;
	bh=W0E2WPTDRMWf4ph54sVZVIIAa9fKUTRtTYJyKELXi10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXPTID8bGW6oWxdLpj20o/T4Z+dYvZB8hnU7wbqlKYDwHSy18d+ha42sbu+bTY8qN
	 EioIuyI6aSEibABD/QN0tb1r648oQhPB1XkXw31BIHoaAtprYHZXHM4dgB5jSglLkU
	 Bk+zEQzOe189rAZun+g6vJBzAF+PieoLh4xOmohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 434/783] firmware: arm_ffa: Reject higher major version as incompatible
Date: Tue, 27 May 2025 18:23:51 +0200
Message-ID: <20250527162530.800042949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit efff6a7f16b34fd902f342b58bd8bafc2d6f2fd1 ]

When the firmware compatibility was handled previously in the commit
8e3f9da608f1 ("firmware: arm_ffa: Handle compatibility with different firmware versions"),
we only addressed firmware versions that have higher minor versions
compared to the driver version which is should be considered compatible
unless the firmware returns NOT_SUPPORTED.

However, if the firmware reports higher major version than the driver
supported, we need to reject it. If the firmware can work in a compatible
mode with the driver requested version, it must return the same major
version as requested.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-12-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 03d22cbb2ad47..ca9a27fceb1fd 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -150,6 +150,14 @@ static int ffa_version_check(u32 *version)
 		return -EOPNOTSUPP;
 	}
 
+	if (FFA_MAJOR_VERSION(ver.a0) > FFA_MAJOR_VERSION(FFA_DRIVER_VERSION)) {
+		pr_err("Incompatible v%d.%d! Latest supported v%d.%d\n",
+		       FFA_MAJOR_VERSION(ver.a0), FFA_MINOR_VERSION(ver.a0),
+		       FFA_MAJOR_VERSION(FFA_DRIVER_VERSION),
+		       FFA_MINOR_VERSION(FFA_DRIVER_VERSION));
+		return -EINVAL;
+	}
+
 	if (ver.a0 < FFA_MIN_VERSION) {
 		pr_err("Incompatible v%d.%d! Earliest supported v%d.%d\n",
 		       FFA_MAJOR_VERSION(ver.a0), FFA_MINOR_VERSION(ver.a0),
-- 
2.39.5



