Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C6A151CCB;
	Tue, 20 Feb 2024 20:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462723; cv=none; b=eh/cxN9S9nuL0RrKm89ZVHFFblH6U7FA7nrusbSLAewTQ486hEn3vuNiypYY1hiFt/+J7XXjUWoYCq2S7RqhttTL4OQ7x8pUx83xxrZ0mjO5I/onE9PbBX9LktwPkE+P06W9Vqq6PHxBf3x9mJhtQERnDHLrCk/BmIwH2ezSjCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462723; c=relaxed/simple;
	bh=EkVsbOMRstslca3lEnOFXX7bGxnI+Yr91DUG78J8WLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKOjAu4MrQmpu6PPKz1bv+xB5dX6gIuik1ZRkjkdtfEZpfDpxNmApPac+NFFq9HZqqvoHyckVVdAdYyRjuKfGal/M9Ijff/qTFhS2/kXR+5QaJZwdaBNinyVkvp/BbzPDbepD/oXHlr8kPQza/zqPN2nj0g/AzbqaNzZgmrMZ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDX7vGZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDX7vGZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F9DC433C7;
	Tue, 20 Feb 2024 20:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462722;
	bh=EkVsbOMRstslca3lEnOFXX7bGxnI+Yr91DUG78J8WLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDX7vGZZR0aVFvtyZeMzO8wif5g0G8mn4sscVf1PJBNuAO/uSmf1dHohszkyCyzXn
	 siXtOkgXpaDCsV9+xGo20mMn1s4yA67Y5hW6Qdmo2SSQ1Z5lpsi8i6tCP4cW/p57Co
	 9hF/IuVkAwMiXWOQggx4kTPHYU5MpdVk9W4oWBxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/197] wifi: iwlwifi: uninitialized variable in iwl_acpi_get_ppag_table()
Date: Tue, 20 Feb 2024 21:49:36 +0100
Message-ID: <20240220204841.597906790@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 65c6ee90455053cfd3067c17aaa4a42b0c766543 ]

This is an error path and Smatch complains that "tbl_rev" is uninitialized
on this path.  All the other functions follow this same patter where they
set the error code and goto out_free so that's probably what was intended
here as well.

Fixes: e8e10a37c51c ("iwlwifi: acpi: move ppag code from mvm to fw/acpi")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://msgid.link/09900c01-6540-4a32-9451-563da0029cb6@moroto.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index bdb8464cd432..f5fcc547de39 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1044,6 +1044,9 @@ int iwl_acpi_get_ppag_table(struct iwl_fw_runtime *fwrt)
 		goto read_table;
 	}
 
+	ret = PTR_ERR(wifi_pkg);
+	goto out_free;
+
 read_table:
 	fwrt->ppag_ver = tbl_rev;
 	flags = &wifi_pkg->package.elements[1];
-- 
2.43.0



