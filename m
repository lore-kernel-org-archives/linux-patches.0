Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64F47A6C;
	Tue, 14 May 2024 11:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686578; cv=none; b=WjedKu6Ppz/P1n1nY5xNgFUrhOTGqqWBYaUki7oMZM5YjviXHKMHzxg/F7wFYya2cdcHMAMbAMZqy2LaccK/QhQpZamtvvzTdb43q3cLgsN1l7s0sm002fg9LE9mGSJbX4booJUOq5fTLXCLTUSLJ3PFsxb46gg0B01F+kEF3Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686578; c=relaxed/simple;
	bh=a2U1cisUZyeaSROHoDeviiAqb4FG89i+nRZv2x4O0iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvnsUW33nAxt7fTjrfXKtXY16JyAiVsKsH1Z/+09ChrlXa4AisHbM/jBNdEAD3vmuxCD5u1OAfN9PBrO4q01aHa4AKokEYqFJfOhjEnDr0Ed3JXt/7pn2FdVmKgpgBOZy30Lmbk0HskyEwH3z0P1M1uD1RG+AUIBTHIkiGPh0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLcTVP0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLcTVP0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55077C2BD10;
	Tue, 14 May 2024 11:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686578;
	bh=a2U1cisUZyeaSROHoDeviiAqb4FG89i+nRZv2x4O0iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLcTVP0LRxhlkTPd9iojP7Gdy5AZtEheQvl43vawngqIDVFtzIlHr6ouFsI6akaIp
	 Ti4PIMqQMz2Q8gQPXzxmw2YZwv3+Btos+Rc92FThoaHEOE1DCBvEqRWE7ECXDdqEm+
	 T+sogzCY0cC5p+vOAjqR9UoplQmbVtzG26sKu4EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/236] hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()
Date: Tue, 14 May 2024 12:18:37 +0200
Message-ID: <20240514101026.249565588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit 3a034a7b0715eb51124a5263890b1ed39978ed3a ]

In ccp_raw_event(), the ccp->wait_input_report completion is
completed once. Since we're waiting for exactly one report in
send_usb_cmd(), use complete_all() instead of complete()
to mark the completion as spent.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Acked-by: Marius Zachmann <mail@mariuszachmann.de>
Link: https://lore.kernel.org/r/20240504092504.24158-3-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 0a9cbb556188f..543a741fe5473 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -140,7 +140,7 @@ static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 		return 0;
 
 	memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
-	complete(&ccp->wait_input_report);
+	complete_all(&ccp->wait_input_report);
 
 	return 0;
 }
-- 
2.43.0



