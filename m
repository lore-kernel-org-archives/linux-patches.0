Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B1A18EFD4;
	Mon, 28 Oct 2024 06:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097300; cv=none; b=CD3+NHL8guXWJCEc69DztjiEr815DPv23Nfou4ySRDPWClyoIDasELAqYBh1wm6Osz1njBTjeee7aMxm0MG0mrq4Jh6MPmPzEOS5MSRRvdB54mQKDPuQ0+ZEZvuGsTvSWEJNr1FHiBX9SKkpgQkF1qISfI3/5w81IyIsJJIN5X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097300; c=relaxed/simple;
	bh=Ze6c0BOWosKtr8hTsw4NHTlRZWNjhtJrs1QQo3qm4o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc1Rv8JHCJzX/ZS8T+1B614B2bD/2DW2tbA/01G9S7HkdI5l7KN2SdezDUnT7RJa39OlZwcvjek0h4q3nZsMGCMLVoeWKO0Y4ig8w4SB2dRcBd51HfvUKqWKxfVp8hee21kq1wa1o3NMJzRLLPVAKaXH5NaXNJGqxya2XdaDglA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXokfrRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXokfrRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69444C4CEC3;
	Mon, 28 Oct 2024 06:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097300;
	bh=Ze6c0BOWosKtr8hTsw4NHTlRZWNjhtJrs1QQo3qm4o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXokfrRNH5O4TyoX5NYgdP03tc+WL47l2vXJ0FOk+/RsoxnRRT/i7ba6X9oJ3nIDE
	 ab3QQzVIPOvqKhiuXiK+dPEEV0168HdXf+zePbm5q7LdLOylLWUargwIBuyZ0cL/Se
	 wGZusmifY4dJkM4aloWRlSOMqwBfR4TQ2XekjT4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/137] usb: gadget: f_uac2: fix non-newline-terminated function name
Date: Mon, 28 Oct 2024 07:25:00 +0100
Message-ID: <20241028062300.498285828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit e60284b63245b84c3ae352427ed5ff8b79266b91 ]

Most writes to configfs handle an optional newline, but do not require
it.  By using the number of bytes written as the limit for scnprintf()
it is guaranteed that the final character in the buffer will be
overwritten.

This is expected if it is a newline but is undesirable when a string is
written "as-is" (as libusbgx does, for example).

Update the store function to strip an optional newline, matching the
behaviour of usb_string_copy().

Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20240708142553.3995022-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9499327714de ("usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 55a4f07bc9cc1..79d1f87c6cc59 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2060,7 +2060,10 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 		goto end;						\
 	}								\
 									\
-	ret = scnprintf(opts->name, min(sizeof(opts->name), len),	\
+	if (len && page[len - 1] == '\n')				\
+		len--;							\
+									\
+	ret = scnprintf(opts->name, min(sizeof(opts->name), len + 1),	\
 			"%s", page);					\
 									\
 end:									\
-- 
2.43.0



