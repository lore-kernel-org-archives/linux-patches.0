Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274692DE1E2;
	Tue, 12 Aug 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021181; cv=none; b=DuQg59AK4RTmtT7n2k+U6pabM3C8pqhsTus/a/gTZGqk3ncMYBlpOQWCaDBKebiE2ayLTtLA1tpS03DBViECX/PSu8EEePumi2VGWRtzPSmBO7NS0OHbTg2jnL+Z8i+VKXzkwo8RSHWdQ7G+Wda+Sz6CaRcVw5Vzjk3kpV3FDq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021181; c=relaxed/simple;
	bh=VGKSShirpawGBOaGTJUrDedaDtX/zwSMdtL+Lw2OfTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU9r6ufV7P7i12R2jphUuLjt6dy5kiF1baklP/zMyVqrdMDBsAppgMbGS1cVUPhuzZ9KnqPMUKjSMoC0lCr8XEP3KnhrDqpypncvfwBTEOdqVRHk/HndOMNfOhtBFtz8VwcwrXBiu2Eu15+4F0tfrHrVnRZ48ZIv3Q8xruoZ/fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc7QnXOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc7QnXOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CBDC4CEF0;
	Tue, 12 Aug 2025 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021181;
	bh=VGKSShirpawGBOaGTJUrDedaDtX/zwSMdtL+Lw2OfTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yc7QnXOgfMzpXtT4mILPfFjaqrFGNr69lkpBvx4HDiJO9aXKYFn9TSk5WzwT4E8+i
	 RfE8+tcntwebC9CLrBQyL4GfQZAaTIH4UpohULbD+ckMb62K7EG8cRHD5doSfcidQI
	 u2U552IEM7Z5m7dKB1dGcD5VXglZKjW7CbRXoZQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/262] um: rtc: Avoid shadowing err in uml_rtc_start()
Date: Tue, 12 Aug 2025 19:27:42 +0200
Message-ID: <20250812172956.175650146@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



