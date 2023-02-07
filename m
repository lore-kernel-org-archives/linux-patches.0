Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178033212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB32C433D2;
	Tue,  7 Feb 2023 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774880;
	bh=LgqKwwZA3qMH0UexjZfQa3eNHKU9SaP3GiAjkt9QdrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhcQDOMg7sMYf8htE6KTa9XHtm9sFKF+kdi6seO7qUSUq3lV6AQ+zwtM78lWGq+gb
	 GTQjhk6zNMvnT8RmiVpUTULn6z/bhhcDg4A+wWTKY3S1erTZksD7VT44Gssa0SkJbc
	 s2ihYwzvtAYxq+3DsyOynui2mHu2bTKAVbmPxClk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/208] ALSA: firewire-motu: fix unreleased lock warning in hwdep device
Date: Tue,  7 Feb 2023 13:55:19 +0100
Message-Id: <20230207125637.256001246@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit c7a806d9ce6757ff56078674916e53bd859f242d ]

Smatch static analysis tool detects that acquired lock is not released
in hwdep device when condition branch is passed due to no event. It is
unlikely to occur, while fulfilling is preferable for better coding.

Reported-by: Dan Carpenter <error27@gmail.com>
Fixes: 634ec0b2906e ("ALSA: firewire-motu: notify event for parameter change in register DSP model")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20230130141540.102854-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-hwdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index a900fc0e7644..88d1f4b56e4b 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -87,6 +87,10 @@ static long hwdep_read(struct snd_hwdep *hwdep, char __user *buf, long count,
 			return -EFAULT;
 
 		count = consumed;
+	} else {
+		spin_unlock_irq(&motu->lock);
+
+		count = 0;
 	}
 
 	return count;
-- 
2.39.0



