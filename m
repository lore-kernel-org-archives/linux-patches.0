Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85A91F5820;
	Mon, 23 Jun 2025 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715336; cv=none; b=qnBlD/Hb7xyyqqJNdbUfWK8IrmyI7empyw57FrxkqsHcfOQSS+uVdkuEZU8lraEEouozpDBgFV85RAnThmJXiIR3nut2V8U+aUmqLGFMPFvLZl0hQkpOiwlaeyX1T5jbAyrxCug6ebNKDHjo820mQSPNdIjIp2Fs5Wl97UdzdMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715336; c=relaxed/simple;
	bh=m1oU+AsIsWMeKtTZP758s56Z4C+35wXtiYl0Uxjoois=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foLiKLUJmZ+fS5EfZt9cRBbk7ZT5LpbYz9/UdkvdFVJVU0NcLbtp09mTwKGJAJCgHZU/CYX9aITofStw/311EOTrKL4Run2WLBFfEXUc+33Kcat28yUk+cR+gn/GUOwhN8Rtt7huQVGlzje3DE83fV37VbMnse/msfD9qoNLwaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej6TK/Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej6TK/Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418E8C4CEEA;
	Mon, 23 Jun 2025 21:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715336;
	bh=m1oU+AsIsWMeKtTZP758s56Z4C+35wXtiYl0Uxjoois=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej6TK/Fd0lJiBHOgNO9tTAz4WeWFYhHqLvdDqLkLj11+V5PHOM7Z0exgP9dqgSbu6
	 nOy9AaCvCC3myFq8uWyRI3i3QQphcf5FbWieIlH+1vl+dz1D8SBTZfKvlCijF/pwi+
	 izrSeh2B3RjHC8U/AVVdnyq5j120/GasX2u4gsN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/414] ACPI: bus: Bail out if acpi_kobj registration fails
Date: Mon, 23 Jun 2025 15:05:13 +0200
Message-ID: <20250623130646.427796452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 94a370fc8def6038dbc02199db9584b0b3690f1a ]

The ACPI sysfs code will fail to initialize if acpi_kobj is NULL,
together with some ACPI drivers.

Follow the other firmware subsystems and bail out if the kobject
cannot be registered.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20250518185111.3560-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 16917dc3ad604..6234055d25984 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1444,8 +1444,10 @@ static int __init acpi_init(void)
 	}
 
 	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
-	if (!acpi_kobj)
-		pr_debug("%s: kset create error\n", __func__);
+	if (!acpi_kobj) {
+		pr_err("Failed to register kobject\n");
+		return -ENOMEM;
+	}
 
 	init_prmt();
 	acpi_init_pcc();
-- 
2.39.5



