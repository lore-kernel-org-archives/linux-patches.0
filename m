Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74DC1AE877;
	Tue,  9 Sep 2025 00:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757377836; cv=none; b=dQh/7vtY0dtE4E8+xA0KT0OAuBEF0/Yho3aW1iHhI7DarezmAE5+GJURoOcRAP6NfVxMKep7qD7myf3daDZlaIG3l8ATXZXau4+/sHrTxNnH6r8uTA5p7PufkbkRaVz8sZ/exJZiReGHmGLPej3xS5Drdp4bK0n4vEVuKVMksuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757377836; c=relaxed/simple;
	bh=N14r0/SABgEudW5rS+xaVZzKlMdVkIgR5xCVzinsLCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihnP/bFS3z++4RLo01Lx9N5eF/Rr/b12cHtb8uuztT8wCHW+ofbPwuSi5jt8IZ3gWnyjtki8jUPuwlTkNAIv7IVHOTC9RDLRUpnDTJvZUtT3l0d8y1J3KF/5Sl2jJvD8L8sqHPHtRucwddaDhZee4pHx7eMXqUQW/7L/yI7ipvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DktfTSPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DktfTSPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F11BC4CEF1;
	Tue,  9 Sep 2025 00:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757377835;
	bh=N14r0/SABgEudW5rS+xaVZzKlMdVkIgR5xCVzinsLCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DktfTSPBTbBt9Y4crTSScNrqLS0Udupbt8ZTlj+WeCVnk2A3978n8E4PQ6HHk90Km
	 Y326gBnQqIzpySYkHHNXJ8i289B600/XpmEX7YqeW63JPhFTSCcyaiomA1tuncsQ6+
	 2WYUC0No68P/3W4pqQC+1NOROtf01D8Kr/m1ceAxW96/fCP/7KaVCTLIeSwMYJQOcT
	 yawuCJ2VCdh6h6z9H27cjQC5Y6OIhYhnyZIOahVq6YAOy+x6k6aKenLuc+O5KJ2iZq
	 ByfeVBF/PD5VLU9riih3BMfE7Ez6CrHP3sCevBtBBP3HTD8xWrWiHRHHoTsUZ2ATZO
	 1QCn0c0ZdUCTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.4] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Mon,  8 Sep 2025 20:30:15 -0400
Message-ID: <20250909003025.2493540-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909003025.2493540-1-sashal@kernel.org>
References: <20250909003025.2493540-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.5
Content-Transfer-Encoding: 8bit

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit aea3493246c474bc917d124d6fb627663ab6bef0 ]

The ALSA HwDep character device of the firewire-motu driver incorrectly
returns EPOLLOUT in poll(2), even though the driver implements no operation
for write(2). This misleads userspace applications to believe write() is
allowed, potentially resulting in unnecessarily wakeups.

This issue dates back to the driver's initial code added by a commit
71c3797779d3 ("ALSA: firewire-motu: add hwdep interface"), and persisted
when POLLOUT was updated to EPOLLOUT by a commit a9a08845e9ac ('vfs: do
bulk POLL* -> EPOLL* replacement("").').

This commit fixes the bug.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/20250829233749.366222-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the kernel code, here is my
backport decision:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Clear Bug Fix**: The commit fixes a concrete bug where
   `hwdep_poll()` in `/home/sasha/linux/sound/firewire/motu/motu-
   hwdep.c:114` incorrectly returned `EPOLLOUT` despite the driver
   having no write operation implemented. The hwdep_ops structure at
   line 279-285 clearly shows no `.write` callback is defined.

2. **Long-standing Issue**: This bug has existed since the driver's
   initial implementation in commit 71c3797779d3c (March 2017), making
   it an 8+ year old bug affecting all kernel versions with this driver.

3. **User-Visible Impact**: The bug causes real problems for userspace
   applications:
   - Spurious wakeups from poll()/epoll() indicating write readiness
     when write is not supported
   - Potential busy-wait loops wasting CPU cycles
   - Applications receiving ENOSYS errors when attempting writes based
     on incorrect poll results

4. **Minimal and Safe Change**: The fix is a one-line change removing `|
   EPOLLOUT` from the return statement. This is about as minimal and
   low-risk as a fix can be:
  ```c
   - return events | EPOLLOUT;
   +    return events;
   ```

5. **No Side Effects**: The change has no architectural impact and only
   corrects the poll semantics to match the actual driver capabilities.
   It cannot break existing functionality since write() was never
   supported.

6. **Subsystem Isolation**: The change is completely contained within
   the firewire-motu driver's hwdep interface, affecting only MOTU
   FireWire audio devices. There's no risk to other subsystems.

## Stable Tree Criteria Met

This commit satisfies multiple stable kernel criteria:
- **Fixes a real bug**: Incorrect poll() behavior violating POSIX
  semantics
- **Already upstream**: Merged by subsystem maintainer Takashi Iwai
- **Minimal change**: Single line removal with clear correctness
- **No new features**: Pure bug fix, no functionality additions
- **Low regression risk**: Cannot break working code since write was
  never supported

## Additional Context

My examination of other FireWire audio drivers shows this is the correct
pattern - drivers without write operations (bebob, dice, digi00x)
correctly return only EPOLLIN flags, while only fireworks (which has a
write operation) returns EPOLLOUT. The fireworks driver actually has a
similar bug where it unconditionally returns EPOLLOUT without checking
write readiness, but that's a separate issue.

The fix brings the motu driver in line with the correct hwdep poll
implementation pattern used by other ALSA FireWire drivers.

 sound/firewire/motu/motu-hwdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index 88d1f4b56e4be..a220ac0c8eb83 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -111,7 +111,7 @@ static __poll_t hwdep_poll(struct snd_hwdep *hwdep, struct file *file,
 		events = 0;
 	spin_unlock_irq(&motu->lock);
 
-	return events | EPOLLOUT;
+	return events;
 }
 
 static int hwdep_get_info(struct snd_motu *motu, void __user *arg)
-- 
2.51.0

