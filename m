Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DA022D4C3;
	Mon, 10 Mar 2025 17:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628352; cv=none; b=WfbRh1hgbULlYxKiDdBk+Agldmq0WDEgNTrigySkrM3ADLMsieBWZMDYQrrZ0iZdMtVGFYb2QPJnijVgQ6pS+VrsKK7nDI4HX20uBRVnDXf8PNqCXVkRJ82aVH2eZNgGISaRXAgVIo1KtOreudjO10/0SJtsYCVqYnmstm3MwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628352; c=relaxed/simple;
	bh=iGQiihMkQOQy3tyUlKQEnNP5YmUCrHKsU8dKEoZs0+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5937qsWOW9Qr/yNCK5i75SJgX7S63qAlQ7a/Z01UWki4sAlm8cJKcQli1BexWChA1EhszSSJasL9Nh8uJN11hHnkbjE1DNDkgPW66yUMGpPX4EI2RHIeNh8w1W7wxx2qUOghE7wbnoDUi7vm9yk1m7N/zAVnIiibtmSuY2D3uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tr7z/fEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tr7z/fEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91931C4CEE5;
	Mon, 10 Mar 2025 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628352;
	bh=iGQiihMkQOQy3tyUlKQEnNP5YmUCrHKsU8dKEoZs0+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr7z/fEFEKczjMSyhjc6gI0eQdd8hZC8mUh9usrwKIV/lD2tSCy0JoGD+g7GfB2gf
	 sEiUCYjfr1+k3FoT00h55EmIQqOblJGr9Cl7prYrhhSVzsAeNMUZbcO0AcZbpQOCR7
	 sOZYdhL+78wmq2H84TkZOnr0QzeK7fWccIRcwXm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 029/109] wifi: nl80211: reject cooked mode if it is set along with other flags
Date: Mon, 10 Mar 2025 18:06:13 +0100
Message-ID: <20250310170428.710853099@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

commit 49f27f29446a5bfe633dd2cc0cfebd48a1a5e77f upstream.

It is possible to set both MONITOR_FLAG_COOK_FRAMES and MONITOR_FLAG_ACTIVE
flags simultaneously on the same monitor interface from the userspace. This
causes a sub-interface to be created with no IEEE80211_SDATA_IN_DRIVER bit
set because the monitor interface is in the cooked state and it takes
precedence over all other states. When the interface is then being deleted
the kernel calls WARN_ONCE() from check_sdata_in_driver() because of missing
that bit.

Fix this by rejecting MONITOR_FLAG_COOK_FRAMES if it is set along with
other flags.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66f7ac50ed7c ("nl80211: Add monitor interface configuration flags")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e5c1e55b9e5c28a3da7
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://patch.msgid.link/20250131152657.5606-1-v.shevtsov@mt-integration.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4050,6 +4050,11 @@ static int parse_monitor_flags(struct nl
 		if (flags[flag])
 			*mntrflags |= (1<<flag);
 
+	/* cooked monitor mode is incompatible with other modes */
+	if (*mntrflags & MONITOR_FLAG_COOK_FRAMES &&
+	    *mntrflags != MONITOR_FLAG_COOK_FRAMES)
+		return -EOPNOTSUPP;
+
 	*mntrflags |= MONITOR_FLAG_CHANGED;
 
 	return 0;


