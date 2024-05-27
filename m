Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66402D518;
	Mon, 27 May 2024 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836613; cv=none; b=dbdMDAGYWXYF48uPVojV4vlk9iDrPNMFVULR6iIffLXnuHuhw+JdEt5Hy2cgi59F5aeNMI3qUOmPKa4lMTTrEQCMBlQrSBk49hPq2MK57Edlz9pBwTin6y8k/rTdOPNsHcmKRqEw5PZ5M+zp64qRSd6Z9e0OM0awIZiteEdC6Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836613; c=relaxed/simple;
	bh=st70cTuNPs7w+GJ+QfpSr3bRuvEJGhfZJC5qVQApDvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyq8gSHLGlj9Ky9gW1dcoympVxaJcSZtk5yITnfShAAygF1t7xbVSj8/OAlAmLyNyobS7W3uKiO3FzgtPSyJMsXZbooc9N4dP+ecEdTZ4ALV1/cTdz31oMz/yZW2rDzR+8lN48vYzFrHIWrYQ1FjoHjCl5px2lUIFSDU1BeRIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7eFsxEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7eFsxEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2285C2BBFC;
	Mon, 27 May 2024 19:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836613;
	bh=st70cTuNPs7w+GJ+QfpSr3bRuvEJGhfZJC5qVQApDvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7eFsxExFHzsXXqAyoN6bNG+nhBKUfmtdV0WLie5g0rzMS11dQEnfmerdXnQS63C1
	 TyA1Lz18uq90KxLINkFbD0XJ9vstW+C7rsKMr/oGdtCAjUVK75r0xSuGo8RWTbu7/4
	 u0OWTtsLEbXSv/wWtyigkX1XYR2pgf3eNa4MVu/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Christian Lamparter <chunkeey@gmail.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 121/427] wifi: carl9170: re-fix fortified-memset warning
Date: Mon, 27 May 2024 20:52:48 +0200
Message-ID: <20240527185613.143272379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 066afafc10c9476ee36c47c9062527a17e763901 ]

The carl9170_tx_release() function sometimes triggers a fortified-memset
warning in my randconfig builds:

In file included from include/linux/string.h:254,
                 from drivers/net/wireless/ath/carl9170/tx.c:40:
In function 'fortify_memset_chk',
    inlined from 'carl9170_tx_release' at drivers/net/wireless/ath/carl9170/tx.c:283:2,
    inlined from 'kref_put' at include/linux/kref.h:65:3,
    inlined from 'carl9170_tx_put_skb' at drivers/net/wireless/ath/carl9170/tx.c:342:9:
include/linux/fortify-string.h:493:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  493 |                         __write_overflow_field(p_size_field, size);

Kees previously tried to avoid this by using memset_after(), but it seems
this does not fully address the problem. I noticed that the memset_after()
here is done on a different part of the union (status) than the original
cast was from (rate_driver_data), which may confuse the compiler.

Unfortunately, the memset_after() trick does not work on driver_rates[]
because that is part of an anonymous struct, and I could not get
struct_group() to do this either. Using two separate memset() calls
on the two members does address the warning though.

Fixes: fb5f6a0e8063b ("mac80211: Use memset_after() to clear tx status")
Link: https://lore.kernel.org/lkml/20230623152443.2296825-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240328135509.3755090-2-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index e902ca80eba78..0226c31a6cae2 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -280,7 +280,8 @@ static void carl9170_tx_release(struct kref *ref)
 	 * carl9170_tx_fill_rateinfo() has filled the rate information
 	 * before we get to this point.
 	 */
-	memset_after(&txinfo->status, 0, rates);
+	memset(&txinfo->pad, 0, sizeof(txinfo->pad));
+	memset(&txinfo->rate_driver_data, 0, sizeof(txinfo->rate_driver_data));
 
 	if (atomic_read(&ar->tx_total_queued))
 		ar->tx_schedule = true;
-- 
2.43.0



