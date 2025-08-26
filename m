Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06F221290;
	Tue, 26 Aug 2025 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215747; cv=none; b=F7LYS5NDxrhPYjE9LDtcwAX+jbeLk/Rn28CFjbDlwlP+/hIQqf611yqYu3zwyJ9JSXBrWQUh8tOf0OUKKWf6UamOAjz3u9VWIl5mOb74MYWLnj2Sr1fucZN3bKSACRJcaZgtzBSF9R3VTeU4r0vixqnDAsu2+ygVUrQDUxZCkIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215747; c=relaxed/simple;
	bh=PDK6Eo5Kh+t3187ubBDmyW67tp/tpXz5mNuGE7HBp+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7pE498tRVb8v9JeP73TS5XOmHsgHEh7kJriIcSzEDTiE/MBxiDP5ilr1KzczVfEEV34R7/Gsw/iv6omwkHGHyXasweZwKz1YAv8mf5Qj51hnwh8A5z6d5qnp5l11DI3NEhym9Rz1/zVu2Gquscv3oiUaguU9qt1oXLqiV/O9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PO79JOx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PO79JOx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B737BC113CF;
	Tue, 26 Aug 2025 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215747;
	bh=PDK6Eo5Kh+t3187ubBDmyW67tp/tpXz5mNuGE7HBp+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PO79JOx9bbmD2k7jEleKFF29at7GnKkqa2meE6aKU3xJnxrIQIUBHt4Id+xz1xpyS
	 JIrSYsDv/S7PVSP2EQeNPuENEEGwvtYhB76Y5EEjEN/6NiFt0USfJWN4e0MCiJ3FBH
	 AHBNSaiHPPsmYsFk6G7dM754Uvklb8PlYFJ9xUYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/644] um: rtc: Avoid shadowing err in uml_rtc_start()
Date: Tue, 26 Aug 2025 13:04:01 +0200
Message-ID: <20250826110950.201176840@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 4c916e3b224a02019b3cc3983a15f32bfd9a22df ]

Remove the declaration of 'err' inside the 'if (timetravel)' block,
as it would otherwise be unavailable outside that block, potentially
leading to uml_rtc_start() returning an uninitialized value.

Fixes: dde8b58d5127 ("um: add a pseudo RTC")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250708090403.1067440-5-tiwei.bie@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/rtc_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/rtc_user.c b/arch/um/drivers/rtc_user.c
index 7c3cec4c68cf..006a5a164ea9 100644
--- a/arch/um/drivers/rtc_user.c
+++ b/arch/um/drivers/rtc_user.c
@@ -28,7 +28,7 @@ int uml_rtc_start(bool timetravel)
 	int err;
 
 	if (timetravel) {
-		int err = os_pipe(uml_rtc_irq_fds, 1, 1);
+		err = os_pipe(uml_rtc_irq_fds, 1, 1);
 		if (err)
 			goto fail;
 	} else {
-- 
2.39.5



