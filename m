Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC17418C02E;
	Tue, 10 Sep 2024 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962552; cv=none; b=LUgrxfocInVyCS23DX8pRR+f2XhwWTbDw3PpQD8Ga5DyqGSyzz4sp/X7n3W1J6j8g275m3jRpiHud2qFxjEzosal4VnNzC9ATBjTHzrEuowxWddbzl2nU6YYJrfsxdxRwctIUA2jJ9V7t5lUB1GZyuqoDFSNGJJYX3954x4TTd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962552; c=relaxed/simple;
	bh=tcYRRZ0sjjmmwbnt0HAvg54nZRSx+xPrI1dR7h47V94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWX1tw4cYr+gY3yme4iToziH8NTuT0eYKcBijjSRjKIAeTT7f1K3b2cjEQz0osqCMKWebJ3bdk+BX83kD0Q9jMMRL1qM43BmEELzM9ZUCq9WyeKgHcpS5TlqCJQKw04WkGaQpvLljxe5MbmErsfCn1IjbsjUZ8WWoRjGXxT8HMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8MTnXDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8MTnXDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA40C4CEC6;
	Tue, 10 Sep 2024 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962552;
	bh=tcYRRZ0sjjmmwbnt0HAvg54nZRSx+xPrI1dR7h47V94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8MTnXDW0PZ06OODkEMBaLNNRNe2yjGKrUXxHNhgRJr+5fM/yw1q7prXrkiJkW9kz
	 Xa6GnOE77khw0AZWS83qE92w9ULJ4fTDxr9/K9sDX4zm1VrYPeSufnbdMVUylj17jp
	 mYJzhCtUbkP19Y3+vBdhjeGxU9Tu3zbPngYXJCZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/121] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:32:28 +0200
Message-ID: <20240910092549.362007096@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d6a78c3548a5..de0ab2e455b0 100644
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



