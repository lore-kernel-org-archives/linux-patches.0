Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529211D049A;
	Wed,  2 Oct 2024 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879923; cv=none; b=oTLBoI1Lc1h9P0VLzdit4zJlFtqL7XMd26Jwz8xvZMQOjvyFJ64MXF9K1LI3eyssjgnblm5riocxivVvthKZ0E/uw0e8QQXlghaY0OCX0ArbPvM/DHPo5hzIPzPCiUZOE168hARfhcYzftkAI2rzxL0B9HXMYOnFl/mMotW2wFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879923; c=relaxed/simple;
	bh=QxiTuc9QazreoUtN+sIYaSek7qyxwcuaSD8LbJY5bY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSbStyITsdto5ub1IhaYN3uHq6KR5xYdTLG6hFH8DLJoHZfIB0E5RwEKYnQjEyKP1xko84SyFOXMO9cjDR0OHKnRtesTjxhFWsDmbwc3S2iFROoH1BTxmK7Goxv1bUGvzCkGz60uyp/FI8LZtwvvHUgjJJUlwrLbz/bDc/7vzAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI6qV67z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI6qV67z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF04CC4CEC2;
	Wed,  2 Oct 2024 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879923;
	bh=QxiTuc9QazreoUtN+sIYaSek7qyxwcuaSD8LbJY5bY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI6qV67zrDmChptxeITS7Ez8Yty/nOlDWzy95Ui0KP8eA+fwYyRBROmVhjLHaBrpY
	 6p3SZPCjlyYJ0tJK2vBAIKhLD16IO70Nof/L8W1Nh2QqKYqhmvOCSrhtPmJhG/1TEN
	 L1Gn86dEZ0bixf1s71GsXME7LWzDNxopx6E5LGTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/538] firewire: core: correct range of block for case of switch statement
Date: Wed,  2 Oct 2024 14:58:43 +0200
Message-ID: <20241002125803.466057855@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit ebb9d3ca8f7efc1b6a2f1750d1058eda444883d0 ]

A commit d8527cab6c31 ("firewire: cdev: implement new event to notify
response subaction with time stamp") adds an additional case,
FW_CDEV_EVENT_RESPONSE2, into switch statement in complete_transaction().
However, the range of block is beyond to the case label and reaches
neibour default label.

This commit corrects the range of block. Fortunately, it has few impacts
in practice since the local variable in the scope under the label is not
used in codes under default label.

Fixes: d8527cab6c31 ("firewire: cdev: implement new event to notify response subaction with time stamp")
Link: https://lore.kernel.org/r/20240810070403.36801-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 6274b86eb9437..73cc2f2dcbf92 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -598,11 +598,11 @@ static void complete_transaction(struct fw_card *card, int rcode, u32 request_ts
 		queue_event(client, &e->event, rsp, sizeof(*rsp) + rsp->length, NULL, 0);
 
 		break;
+	}
 	default:
 		WARN_ON(1);
 		break;
 	}
-	}
 
 	/* Drop the idr's reference */
 	client_put(client);
-- 
2.43.0



