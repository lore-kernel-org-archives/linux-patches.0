Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44B18C913;
	Tue, 10 Sep 2024 09:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961846; cv=none; b=nJ6YrsZDy/R5gMM9eeyIszot589FPgsUzNchN4xzbl6QgbqGY/ZBatagKdhiqfcfPnbe3N+G0YbRZwNq8gy7NNnQZY7jzVvJw+AeYRuYmh/TegDG1mws9/SlTY1EV93eoadvRkqMN688ut+NKc+mMTDV8Oi8gXN7Oq8FjHe1BKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961846; c=relaxed/simple;
	bh=YmdfpbvXpwRoBVzv+f7tMjWgcn5bcAUKIWh7NrDJUAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe5OF8VHzVtR9Hol4qsswvCsvwqZOsn5/fPE4NMCMUNrhNQgsT9lMa6rnHw9awSHR8jh4l4S6lqiNi/LIBVjWSW8A0B4yZtfa8ymQkQLA9vt50hB/0sg1rp5QZFBuYvKVlzTT0HkbFUsPFBCZcsgipmAQz9qBK4oVC2+hLXay/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Trtc0uNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Trtc0uNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF054C4CED1;
	Tue, 10 Sep 2024 09:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961846;
	bh=YmdfpbvXpwRoBVzv+f7tMjWgcn5bcAUKIWh7NrDJUAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Trtc0uNcCHcpq4OegPcKDXXIOPZLgwXkPOL/M7teC3vFaerln02ijwegc69weXCg7
	 Z2JwN9zYM2oyhMxvlBSdocevwTmymEsn0u3X3yAtXQeqSRk776Z9W0VGAicC+lhn8j
	 ZonSipY1FIm94XIQBKfdvLukdVx8TQJL+u/IAh2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 209/375] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:30:06 +0200
Message-ID: <20240910092629.535250859@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 824ac4a5edd3f7494ab1996826c4f47f8ef0f63d ]

The pointer isn't initialized by callers, but I have
encountered cases where it's still printed; initialize
it in all possible cases in setup_one_line().

Link: https://patch.msgid.link/20240703172235.ad863568b55f.Iaa1eba4db8265d7715ba71d5f6bb8c7ff63d27e9@changeid
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/line.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index d82bc3fdb86e..43d8959cc746 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -383,6 +383,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			parse_chan_pair(NULL, line, n, opts, error_out);
 			err = 0;
 		}
+		*error_out = "configured as 'none'";
 	} else {
 		char *new = kstrdup(init, GFP_KERNEL);
 		if (!new) {
@@ -406,6 +407,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			}
 		}
 		if (err) {
+			*error_out = "failed to parse channel pair";
 			line->init_str = NULL;
 			line->valid = 0;
 			kfree(new);
-- 
2.43.0



