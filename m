Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96901152DE7;
	Tue, 20 Feb 2024 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464535; cv=none; b=e6nIzl8R2GYrLUzO0vZrGJ6HRuQbp3N/ysKrXn0GYg2If2i91MU/4V2cvEGJvCC+hywhD/8yo4ZYoScnNkDCQNNjj05ta7AwaM6jUPjplcdTo9bsSrznWtVRegmvpUq524pa1U4QStFqsiVh7V8GxZH6YKQWrA3JhLebTyHzXCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464535; c=relaxed/simple;
	bh=Ak+rjnf96buxx4581viUNEdvVDvPzK/WMMTNS7JyyTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQFnUPceRACV/UBpEiKnykVRvUrLot0ZUsvtm0er83ANKpmYlZlmAjGPtJtXhUKvR1ygx61r3zo8lWpjKmDcwUTk7dfmWqz6N0Sdv7AiKURHlqUI9TYgqz7GQAeSOb7SjfU+91y29x7ytyaW9+fp46MV+2TpV/EPqDZHAdSKqqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+qSrjDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+qSrjDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC63C433C7;
	Tue, 20 Feb 2024 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464535;
	bh=Ak+rjnf96buxx4581viUNEdvVDvPzK/WMMTNS7JyyTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+qSrjDt6HkmlX4qHN+MhROc5kGMKPtLvndyFQh3ujSAXvXiMMFGHIjKS9MGag6/i
	 TpBxevXccGJ1b+mAoG9T2NVlnN3Ctsr9vNkP9++XSDLEur8yariuxBCEZJs/gP84Of
	 t8mVQELMerfQVXjAUdZvuS+E7xFU15X8GpIfqOAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/309] wifi: iwlwifi: uninitialized variable in iwl_acpi_get_ppag_table()
Date: Tue, 20 Feb 2024 21:53:07 +0100
Message-ID: <20240220205634.061424180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index d73d561709d3..dcc4810cb324 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1116,6 +1116,9 @@ int iwl_acpi_get_ppag_table(struct iwl_fw_runtime *fwrt)
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



