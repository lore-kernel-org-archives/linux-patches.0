Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F58FBEF;
	Tue, 25 Jun 2024 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308144; cv=none; b=Na3O7EoT5b6n3dzCbZ/I5xD+lKGSvQ/KVabIshVuZMSQNKl+jDohVCvNkkz1szSvvZjCXr4R06NXEqNlvEhG35lijckpYZ1KRR1U6e1+yIf/F5P13ij6jLhvJsRqx0ZVQCn0TXaMVmfQfQef+/cE5pns4m5JpIfYaa32cDE2nss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308144; c=relaxed/simple;
	bh=1hP7OOinenUejmszbiWKCurM5FCJGYcUVEciQhGCQyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I7qxJfmby7432ztcpXs3b4y0EzIBXYh9FVsZhx1oM5WIhL+Ulb/KaX9kg7wymB7/KO3Q6hI2K0k3PTMAI+RyyUt4DmDD24kwJIufJgteKkU73KZ0V4w85w7XuiJJOY+VLjG37jzni0WEwQB9lFXLhY7dUo/I3EuSMTIHMM7Z3bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUFIIp1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUFIIp1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D35C32781;
	Tue, 25 Jun 2024 09:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308144;
	bh=1hP7OOinenUejmszbiWKCurM5FCJGYcUVEciQhGCQyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUFIIp1cWXOA3mnQrQ3cDlK/XBhHfh0gn4riwAOhnKfzcDRTreyUJy3zso9KPjFgs
	 BUgld9DYJge7z/DxCNTPDCU0ux7Ag09usC20FdZBios/QneJwsNF8T4cr7jZlJM6NW
	 jqTZYinfFaRT/jB9TAXOj6Hx5pNm2UDZFYp0VLyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kees Cook <keescook@chromium.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/250] wifi: ath9k: work around memset overflow warning
Date: Tue, 25 Jun 2024 11:29:39 +0200
Message-ID: <20240625085548.868218166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 61752ac69b69ed2e04444d090f6917c77ab36d42 ]

gcc-9 and some other older versions produce a false-positive warning
for zeroing two fields

In file included from include/linux/string.h:369,
                 from drivers/net/wireless/ath/ath9k/main.c:18:
In function 'fortify_memset_chk',
    inlined from 'ath9k_ps_wakeup' at drivers/net/wireless/ath/ath9k/main.c:140:3:
include/linux/fortify-string.h:462:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  462 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Using a struct_group seems to reliably avoid the warning and
not make the code much uglier. The combined memset() should even
save a couple of cpu cycles.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240328135509.3755090-3-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath.h        | 6 ++++--
 drivers/net/wireless/ath/ath9k/main.c | 3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index f02a308a9ffc5..34654f710d8a1 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -171,8 +171,10 @@ struct ath_common {
 	unsigned int clockrate;
 
 	spinlock_t cc_lock;
-	struct ath_cycle_counters cc_ani;
-	struct ath_cycle_counters cc_survey;
+	struct_group(cc,
+		struct ath_cycle_counters cc_ani;
+		struct ath_cycle_counters cc_survey;
+	);
 
 	struct ath_regulatory regulatory;
 	struct ath_regulatory reg_world_copy;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a2943aaecb202..01173aac30456 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -135,8 +135,7 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	if (power_mode != ATH9K_PM_AWAKE) {
 		spin_lock(&common->cc_lock);
 		ath_hw_cycle_counters_update(common);
-		memset(&common->cc_survey, 0, sizeof(common->cc_survey));
-		memset(&common->cc_ani, 0, sizeof(common->cc_ani));
+		memset(&common->cc, 0, sizeof(common->cc));
 		spin_unlock(&common->cc_lock);
 	}
 
-- 
2.43.0



