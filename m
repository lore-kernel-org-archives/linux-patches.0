Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACFB230D3D;
	Mon, 10 Mar 2025 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626636; cv=none; b=isJGLKq9FfDOTdC8Tq2wuGXpSl1XvCDMl6KUtUDFBZHczHvRmLJY++KGOmI5bwVlyty5I5mJXhmriOY0CmZ88PrUaCkSk9VOuJBRw9Wb83O+HnRaotSkB8bhXEvvD0Tjv147LCS9NmbxJ53kZ+G175TNWHPRqGelLBIhcH8hJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626636; c=relaxed/simple;
	bh=LRdP6dEUJCXhEIPaXDrtQ5W8wgNva2iiMSNylDmSMpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbFVgkfWlO8L+uc2fzLWN/f/T3v5u5uKjnoTqb2DjPd/jZe6g6/JXvc9/YYriD33T0lrvLHXfwiezUKw02QRYecaucXxvJs3zmq2O/oRB22BldP5exqFaAqNy9jVQB0FIkORkOihNFPnAxRTW3Xz8s0gF6DjOFaumcfJyndKMvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0klVC1Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0klVC1Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14564C4CEF4;
	Mon, 10 Mar 2025 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626636;
	bh=LRdP6dEUJCXhEIPaXDrtQ5W8wgNva2iiMSNylDmSMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0klVC1Hx9I4+3gkvUt90e1C453pFJybqdnG04vdLfvUakGGEmtYAjocv1wJDhardN
	 teAwubK+eSjv3Z74xzuZKdxoLd0/qUd7zz3mtbLIpHaFRUPamKx/DYgc5L3YtYUO46
	 J3AAkRkKkLkxYh0NbjhgaPr5wz3umMkZLh0CunLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e10709ac3c44f3d4e800@syzkaller.appspotmail.com,
	stable@kernel.org,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.13 060/207] wifi: cfg80211: regulatory: improve invalid hints checking
Date: Mon, 10 Mar 2025 18:04:13 +0100
Message-ID: <20250310170450.156412349@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 59b348be7597c4a9903cb003c69e37df20c04a30 upstream.

Syzbot keeps reporting an issue [1] that occurs when erroneous symbols
sent from userspace get through into user_alpha2[] via
regulatory_hint_user() call. Such invalid regulatory hints should be
rejected.

While a sanity check from commit 47caf685a685 ("cfg80211: regulatory:
reject invalid hints") looks to be enough to deter these very cases,
there is a way to get around it due to 2 reasons.

1) The way isalpha() works, symbols other than latin lower and
upper letters may be used to determine a country/domain.
For instance, greek letters will also be considered upper/lower
letters and for such characters isalpha() will return true as well.
However, ISO-3166-1 alpha2 codes should only hold latin
characters.

2) While processing a user regulatory request, between
reg_process_hint_user() and regulatory_hint_user() there happens to
be a call to queue_regulatory_request() which modifies letters in
request->alpha2[] with toupper(). This works fine for latin symbols,
less so for weird letter characters from the second part of _ctype[].

Syzbot triggers a warning in is_user_regdom_saved() by first sending
over an unexpected non-latin letter that gets malformed by toupper()
into a character that ends up failing isalpha() check.

Prevent this by enhancing is_an_alpha2() to ensure that incoming
symbols are latin letters and nothing else.

[1] Syzbot report:
------------[ cut here ]------------
Unexpected user alpha2: A�
WARNING: CPU: 1 PID: 964 at net/wireless/reg.c:442 is_user_regdom_saved net/wireless/reg.c:440 [inline]
WARNING: CPU: 1 PID: 964 at net/wireless/reg.c:442 restore_alpha2 net/wireless/reg.c:3424 [inline]
WARNING: CPU: 1 PID: 964 at net/wireless/reg.c:442 restore_regulatory_settings+0x3c0/0x1e50 net/wireless/reg.c:3516
Modules linked in:
CPU: 1 UID: 0 PID: 964 Comm: kworker/1:2 Not tainted 6.12.0-rc5-syzkaller-00044-gc1e939a21eb1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events_power_efficient crda_timeout_work
RIP: 0010:is_user_regdom_saved net/wireless/reg.c:440 [inline]
RIP: 0010:restore_alpha2 net/wireless/reg.c:3424 [inline]
RIP: 0010:restore_regulatory_settings+0x3c0/0x1e50 net/wireless/reg.c:3516
...
Call Trace:
 <TASK>
 crda_timeout_work+0x27/0x50 net/wireless/reg.c:542
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Reported-by: syzbot+e10709ac3c44f3d4e800@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e10709ac3c44f3d4e800
Fixes: 09d989d179d0 ("cfg80211: add regulatory hint disconnect support")
Cc: stable@kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250228134659.1577656-1-n.zhandarovich@fintech.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -407,7 +407,8 @@ static bool is_an_alpha2(const char *alp
 {
 	if (!alpha2)
 		return false;
-	return isalpha(alpha2[0]) && isalpha(alpha2[1]);
+	return isascii(alpha2[0]) && isalpha(alpha2[0]) &&
+	       isascii(alpha2[1]) && isalpha(alpha2[1]);
 }
 
 static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)


