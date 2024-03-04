Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88E10A1F;
	Mon,  4 Mar 2024 21:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587743; cv=none; b=OGR8h9t8YsaGCpWlBlm1noJwVypqFw+lXcZ+b788N7K2NrCyRrjJoUY1xGn6cx/F/KfO+rZ3cRGvaN/e5xCVqbqVRJO2WPqEw8eU6RJRSx/aEkGb33gd6mUJyiOATFxVkdFnJI1OP2+KlEjCCTEjZVTF/DSX71f1F9y6lBXERY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587743; c=relaxed/simple;
	bh=Lyyu8PI+uGKCMJtkw2VHzZGflWHvkhZdKRfSOU9O9kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pln30si/yPs1QvwV1I2dVbMDUkbf3HK8uhH81AmYehjA+0xcp1RoCPSZDNL8P31Cb/W+RtkvqjH34Z10QsoRKqFD2s3riAgA6bNBJGE/0kzu4VBiISjMy7moixtkxWP2vMQUr7y3XKl0iQMgqre4iqozxZK/ZlLC8Kf/qrCRSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y2XREdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y2XREdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACB7C433F1;
	Mon,  4 Mar 2024 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587743;
	bh=Lyyu8PI+uGKCMJtkw2VHzZGflWHvkhZdKRfSOU9O9kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y2XREdqBJZ9/B6ai0o2iVCW34hcPmktYgoPSF95FguMYkEuqFPoYb5UzIBgFOpka
	 NusvilE1bBIQWunLqF7NiXugbBGgS9jwOLmc85PvvYTVazsupBcD3WFl6MwGdQodvU
	 emrdC6vpV1JG/F+7vMKDyS1BFava8PhLzqeR4epg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Sun <samsun1006219@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.7 073/162] tomoyo: fix UAF write bug in tomoyo_write_control()
Date: Mon,  4 Mar 2024 21:22:18 +0000
Message-ID: <20240304211554.191188897@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 2f03fc340cac9ea1dc63cbf8c93dd2eb0f227815 upstream.

Since tomoyo_write_control() updates head->write_buf when write()
of long lines is requested, we need to fetch head->write_buf after
head->io_sem is held.  Otherwise, concurrent write() requests can
cause use-after-free-write and double-free problems.

Reported-by: Sam Sun <samsun1006219@gmail.com>
Closes: https://lkml.kernel.org/r/CAEkJfYNDspuGxYx5kym8Lvp--D36CMDUErg4rxfWFJuPbbji8g@mail.gmail.com
Fixes: bd03a3e4c9a9 ("TOMOYO: Add policy namespace support.")
Cc:  <stable@vger.kernel.org> # Linux 3.1+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/tomoyo/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2649,13 +2649,14 @@ ssize_t tomoyo_write_control(struct tomo
 {
 	int error = buffer_len;
 	size_t avail_len = buffer_len;
-	char *cp0 = head->write_buf;
+	char *cp0;
 	int idx;
 
 	if (!head->write)
 		return -EINVAL;
 	if (mutex_lock_interruptible(&head->io_sem))
 		return -EINTR;
+	cp0 = head->write_buf;
 	head->read_user_buf_avail = 0;
 	idx = tomoyo_read_lock();
 	/* Read a line and dispatch it to the policy handler. */


