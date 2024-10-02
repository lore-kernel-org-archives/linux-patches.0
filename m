Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7A51D0E28;
	Wed,  2 Oct 2024 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878325; cv=none; b=QSSami64THJQnsq/j1+JNb+95LccmdebXNiBdwvq7KKWulKEc6exNeIuz5bzcvi002GRjAW7alydIqWjjfwRKUOoQjYLmjAoPihk4GH67AALZeUbs+MIwkq5/UMa4sa9yLJ2/WezNmrL8K+KeXAn2LHo18KpqWZhGrvpOZ6lpdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878325; c=relaxed/simple;
	bh=mZywu8NCO8Nl8x6fzkzfKcQ1ObnqnJsh/I13P+HDgSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxXJa2ur1R8ZEu2XFm/+3+ocj71oDOG47MW7BRYyuWyluR2qVAHGHi3YwMJsTJ7cZ0ifLYX/kkyFCybAv+oMufMlOgV9vEq0g0E3bZZ8UXQtWbD1D4vDdxDkLNghNfgm8ZdjhygnG8thbNqCB8Urcq8G/Ilv0xgqIy3pxFWmqiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhnhrs5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhnhrs5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6287CC4CEC2;
	Wed,  2 Oct 2024 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878325;
	bh=mZywu8NCO8Nl8x6fzkzfKcQ1ObnqnJsh/I13P+HDgSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhnhrs5ntDMvBOY02Zs1rvH0kIti3gU+hjXA9a8khoBCNiUfiEviQyPCJwrVC94oH
	 /zwkFW2bTvsYT3USqN1PBtWbDyASAAbRzgmvaBculbBStr/O0JDpGEisZ/c2UWoywd
	 laoxVYWDFP+UFnEraiRwHXK0WS+ZFVx0bjoSU9E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 334/634] firewire: core: correct range of block for case of switch statement
Date: Wed,  2 Oct 2024 14:57:14 +0200
Message-ID: <20241002125824.286445305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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
index 9a7dc90330a35..a888a001bedb1 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -599,11 +599,11 @@ static void complete_transaction(struct fw_card *card, int rcode, u32 request_ts
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



