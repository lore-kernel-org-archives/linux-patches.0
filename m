Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7488F30ACFA;
	Tue, 11 Nov 2025 01:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824909; cv=none; b=Azb5JLWhNV4ee9gjkjuxTwC4boGKUfJC887rFCXkXEsIJJuHjvv0GS3JihLvDA4a4H0jnd28adroHRXYnjWJ1TMpuA1FZLjj30c0CErmDUk+lU6Qh1mjjZ3NUd0hOxeXvbgna4n6D+bC98VO9gWNM12HkrG0IE2GOZsl+ywqqx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824909; c=relaxed/simple;
	bh=9DjPcGxZjKHvfBLgAHkFuqsfmXWJgrKbUZv0AJ4l9pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9PhA/9pB1RL0CqnHpJuT/jKrOyUK6Xi7RUEoOAWzmN6zJQ0Lf5H4lHqd9KwApzGUWvalbRn2fUQ0aydOBMfUyFv5LJTSpf3YRfxdExlK/G3uzFfLfACVNQTbj6qNHm12Wc+Yt/1eQgu+SVHDCLJgRoSQxRj+yHtkyUVSdDY9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIYOXzUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIYOXzUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4F3C19422;
	Tue, 11 Nov 2025 01:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824909;
	bh=9DjPcGxZjKHvfBLgAHkFuqsfmXWJgrKbUZv0AJ4l9pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIYOXzUcBleMGeUG4OCIcl68cIeeMzGBHtCCatpxZHq2rlu1fKd42fFsp6N5iybxB
	 CMFa7nwQgzEkPz7B6wN+t+RNkWu+OHYO2hEQSKIFnT/jfbPjdXD1GT5bUKlhxenWYZ
	 ETHEt2kBr+QncgHJJVF8g7+N2CeU4QUB1wx/dXHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/565] bnxt_en: Fix a possible memory leak in bnxt_ptp_init
Date: Tue, 11 Nov 2025 09:46:25 +0900
Message-ID: <20251111004538.870387179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit deb8eb39164382f1f67ef8e8af9176baf5e10f2d ]

In bnxt_ptp_init(), when ptp_clock_register() fails, the driver is
not freeing the memory allocated for ptp_info->pin_config.  Fix it
to unconditionally free ptp_info->pin_config in bnxt_ptp_free().

Fixes: caf3eedbcd8d ("bnxt_en: 1PPS support for 5750X family chips")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 650034a4bb46d..6dfa0ab74c332 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -1040,9 +1040,9 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	if (ptp->ptp_clock) {
 		ptp_clock_unregister(ptp->ptp_clock);
 		ptp->ptp_clock = NULL;
-		kfree(ptp->ptp_info.pin_config);
-		ptp->ptp_info.pin_config = NULL;
 	}
+	kfree(ptp->ptp_info.pin_config);
+	ptp->ptp_info.pin_config = NULL;
 }
 
 int bnxt_ptp_init(struct bnxt *bp)
-- 
2.51.0



