Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904681422B8;
	Wed, 19 Jun 2024 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802886; cv=none; b=KbrEBcM51rEB8/5v312VtkuCBRejvOmBFdPBbnxlpVuPCvjsutSv7ZzArxh7lNs2JKiURm/s3dfqH3+bFI6jsZqXoEwvpc9xLAy9BG6QJClQWwKo+4J8xqXSmBThc3k+Vk+3lVh5OzP4wMGzih3yAC95sP8J4hftf+aAOSAB2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802886; c=relaxed/simple;
	bh=T6DtTw0o8xeOichsBlv7Q/6kkVWIObpSqNnH+t4v9Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDCwF1nITbmbz08vFwxRNLp5RfVKo3G0ukA60eEmCJFh70jHBMdl+LSNie5PaplpDmE40r5DGk1Z9s5b6pobTQspahAqjLXbMGT8unDTKSx9DjilQNfi+gxsPG9nwnev1b/9LfwDGq4vbYxhzIqu2ktNkm3ol7uSzYhRLlpvMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmECkZbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmECkZbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17622C2BBFC;
	Wed, 19 Jun 2024 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802886;
	bh=T6DtTw0o8xeOichsBlv7Q/6kkVWIObpSqNnH+t4v9Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmECkZbNl32GNeqMvKzazLbz6KPr5nlK2bPiZ4DaXeT9EOz2fmeiQguILb2hb4n9i
	 xpsJuIiV8gYWonXxuDqVSdO4cBw/yBlBNvl0mjI8zMaLkRrRD0XxQ4WqnWCMOO2LAt
	 P0vaiguLe4yGvzRg6t/q1EdhxtgBrkGHA8CZ1iBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 049/281] ptp: Fix error message on failed pin verification
Date: Wed, 19 Jun 2024 14:53:28 +0200
Message-ID: <20240619125611.738004488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 323a359f9b077f382f4483023d096a4d316fd135 ]

On failed verification of PTP clock pin, error message prints channel
number instead of pin index after "pin", which is incorrect.

Fix error message by adding channel number to the message and printing
pin number instead of channel number.

Fixes: 6092315dfdec ("ptp: introduce programmable pins.")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20240604120555.16643-1-karol.kolacinski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 7513018c9f9ac..2067b0120d083 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -85,7 +85,8 @@ int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 	}
 
 	if (info->verify(info, pin, func, chan)) {
-		pr_err("driver cannot use function %u on pin %u\n", func, chan);
+		pr_err("driver cannot use function %u and channel %u on pin %u\n",
+		       func, chan, pin);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.43.0



