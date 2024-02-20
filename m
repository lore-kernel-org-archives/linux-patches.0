Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC512DF9F;
	Tue, 20 Feb 2024 21:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465296; cv=none; b=nhhQoFjVm6L4i/pnyJQ+mDj8F6KZyTiETjLSGgRwnAvxSk87aVBRA+pQkQRGBPSz7ib+YSr3YeEP4siHhwCRo0aCJIAFDhfeauArAwXDk0c/49u4DEtQxqcwSnJyVMvD95Crsn0bJHSZPMnX0PvulaKcg10veZ5yOCP13emWKaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465296; c=relaxed/simple;
	bh=dNBMnyU7QSBvJXRLznPluatkB9cC9iP9fwxgKy6ZCnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHGN16UhpyMmawugZTqTumvLVaxL3xwTJ0WDl5D2iBeJA2s6hvOwG/LCSLFSMuYI0qEOIgl9NTTBxDEA7AmHDrUOOWPhqrqKvbexB2e92ubpCwaWQucGD0oC8TiJ3j4NkKiiRwE8RJ3U2Pl/wZikH6QNOianwfPmjI3RaTBorfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWoUJ+cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWoUJ+cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD91C433F1;
	Tue, 20 Feb 2024 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465296;
	bh=dNBMnyU7QSBvJXRLznPluatkB9cC9iP9fwxgKy6ZCnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWoUJ+cHFiQ0QH1zCFEJ7pS15yDNk1kbBwbvUlgMejCQhpjuDuYEH9jDCn1wYqvjw
	 FuRJKKEPjHUAFNKn0M154ztswZh+rHW/9vOKgmku7ti0hztDNsDVhoN82eInZsyXki
	 57jGWVcc2tSO6v6wKtbWoOiWxr9N8y3rdBknfAMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 299/309] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Tue, 20 Feb 2024 21:57:38 +0100
Message-ID: <20240220205642.448406469@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 741ba0134fa7822fcf4e4a0a537a5c4cfd706b20 upstream.

The unused clock cleanup uses the _sync initcall to give all users at
earlier initcalls time to probe. Do the same to avoid leaving some PDs
dangling at "on" (which actually happened on qcom!).

Fixes: 2fe71dcdfd10 ("PM / domains: Add late_initcall to disable unused PM domains")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231227-topic-pmdomain_sync_cleanup-v1-1-5f36769d538b@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1111,7 +1111,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #ifdef CONFIG_PM_SLEEP
 


