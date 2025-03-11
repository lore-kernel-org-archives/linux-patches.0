Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0DC249F9;
	Tue, 11 Mar 2025 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706234; cv=none; b=EPYiUT2yYYQ1k/PNaEw2Sen0+et8bEXJizpr0Uad+utdR2cSl0g4L0Jq6Wc3qwbhwRJUvJusXx2bvPd0NCpSmRgaV5c4oIKyDejTyWCzJ10Jeg1HBZ/YGTRkflpmTfNBnylrLOj57++pKlcBqMqec4LwwkZCAXpdhD5FT6odCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706234; c=relaxed/simple;
	bh=cVIePDYrJpEDoFDND2gO2HOxUMbZNg+Ml/nLj5PnFLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5IpDlsT1CCOs86ugfXYCnGh/EKL1ENLx51lat+9Wi8FvqxG5hJsZfAGMLgLUHxNQBG3dpFU1FbJFdBKMj7S55SG1Z02LAn7OjcW5fcS5LiasYQWgLx80lG1NuhjDsFRsyZSmYq+c3aH6p5VWZwtHedeIGQNw3evCYkXFLtH6IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LESExDX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LESExDX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060EFC4CEE9;
	Tue, 11 Mar 2025 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706234;
	bh=cVIePDYrJpEDoFDND2gO2HOxUMbZNg+Ml/nLj5PnFLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LESExDX5GAJAmXHU51vgADRqEEFwCeayL/8+7gIeZWsOyqBlZ2AhMCDDWD3n0qXOV
	 limYx5amctmLg9CnV4vdvmzu/V7nFUZqNipJUdZg3ArOhUDEg0umyhrYTthkJunwKm
	 hp0vHoDy+OxQ6t55w+KwNnZeUI82blFmgs+wqAiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 289/328] wifi: nl80211: reject cooked mode if it is set along with other flags
Date: Tue, 11 Mar 2025 16:00:59 +0100
Message-ID: <20250311145726.397721630@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3409,6 +3409,11 @@ static int parse_monitor_flags(struct nl
 		if (flags[flag])
 			*mntrflags |= (1<<flag);
 
+	/* cooked monitor mode is incompatible with other modes */
+	if (*mntrflags & MONITOR_FLAG_COOK_FRAMES &&
+	    *mntrflags != MONITOR_FLAG_COOK_FRAMES)
+		return -EOPNOTSUPP;
+
 	*mntrflags |= MONITOR_FLAG_CHANGED;
 
 	return 0;


