Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C184C330B00;
	Fri, 17 Oct 2025 15:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715982; cv=none; b=p0HtbfPsCueFisP5rtMlaWewf6JZ3CfwdJVVIUA8eofeQTQuH1ZL8ORFa8o7o0+EmVxLtRUxj7Vfzuzb3mbIAN4PLzKGFoeDwpmW5iVxraS2fgA6/lPNVqdgqsKACFv9lSabI7vRZTP2aE+I5nmZX+Q8XvwzjAA9RXK2t3nwKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715982; c=relaxed/simple;
	bh=3oL+DNgzjdEtkNT3S4oLs4ktTl26m90yT5Kvw33mQKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGQ44dDrlYJY+959iE48Vs+DKdHKss+k2j1S4pmDzUB1BDsJvxOvJ6+Kj52/HVoMhU+taMw5MrIP9BfFOEIdviAb8EMJdbF4HFIkIUHp2wYLG6RltkNIC19FH8VUC+QU141nWgWoeAEGtnYmjNpJUX4hxOobukhyXym/Ibop9oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXi88zoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXi88zoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD64C4CEE7;
	Fri, 17 Oct 2025 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715982;
	bh=3oL+DNgzjdEtkNT3S4oLs4ktTl26m90yT5Kvw33mQKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXi88zoMgh293FM1kHVGCMfWxDZJSt86OqzJERkeuT3CpeCG9HojcpB3RFtOBiLNm
	 jku/jk3A85ERH2GnAxBXoetxr/LV0xosaQso60rFY9gchTa9JDh69vbw42sosMMjJ+
	 BiVnciLf5XNQvSgQb0LRwe6NvT+1eSOlKI1oMo1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/276] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Fri, 17 Oct 2025 16:52:04 +0200
Message-ID: <20251017145143.540214881@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 11b3de1c03fa9f3b5d17e6d48050bc98b3704420 ]

The cpuidle device's memory is leaked when cpuidle device registration
fails in acpi_processor_power_init().  Free it as appropriate.

Fixes: 3d339dcbb56d ("cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20250728070612.1260859-2-lihuisong@huawei.com
[ rjw: Changed the order of the new statements, added empty line after if () ]
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 74459ac13f4bc..6b71082d474f9 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1403,6 +1403,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		if (retval) {
 			if (acpi_processor_registered == 0)
 				cpuidle_unregister_driver(&acpi_idle_driver);
+
+			per_cpu(acpi_cpuidle_device, pr->id) = NULL;
+			kfree(dev);
 			return retval;
 		}
 		acpi_processor_registered++;
-- 
2.51.0



