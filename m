Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3701612D7;
	Tue, 20 Feb 2024 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463491; cv=none; b=AHVBH2XtADokFieZJnULbdFCWESVTksSlPM1B7qZRc2O1Yakd9nF8ADaajTyvbaQ93exw7jR8CkyxvQo4NXsdsusiCVvOk5ca46uq+c2/+ifMCUxIpp/Sg4ol548N1oSsgo7qw9elYOQ+NqFA+PG+bYcH70kcjZz0pNx1OAKylE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463491; c=relaxed/simple;
	bh=fRnd8t/FjAlMSRiX/b44SGkR2IDMo4350luXtwhjPkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM1dp9xhfSXPWXNJ2lOHVnQBGDZu9Lf1/AStsQULvF7/KMLhPmZHoSBQNIkPx1COSCB/8IBMBzQIzwbJjnTiDkaeCeXNowJnG0an+jMAz/nfeWLOAOvJbxjFTxMC1NwJivRL8pE79KGqcXEbD9+updGMKZFbaBbp+T+ATi4OukM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDPJBzX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDPJBzX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EB2C433F1;
	Tue, 20 Feb 2024 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463491;
	bh=fRnd8t/FjAlMSRiX/b44SGkR2IDMo4350luXtwhjPkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDPJBzX708uEBkE+3pUyE7ZzpkYW4ThEGwfEbvvFYDioFIQg0CpL6pUV3svLOfloo
	 kkurUiemcrNK0VJ95AGvtuVcMEYs8YfByMJMjsW0mztWGXeAu2sCENAaZeoxkUqFxP
	 iBae5OZloc8SSHUHh0MR3PLsEcdsLH6omwce3P6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/331] wifi: iwlwifi: uninitialized variable in iwl_acpi_get_ppag_table()
Date: Tue, 20 Feb 2024 21:52:17 +0100
Message-ID: <20240220205638.258327931@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6f1919234f3f..359397a61715 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1088,6 +1088,9 @@ int iwl_acpi_get_ppag_table(struct iwl_fw_runtime *fwrt)
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



