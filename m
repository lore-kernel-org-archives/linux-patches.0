Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625F1CF7D4;
	Wed,  2 Oct 2024 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876217; cv=none; b=VhZ7rsVf46qhoNWM0chbSm9R3s/eZRpgAlMHwy/qozdV1Ju3Jn6pcIiQLK9kWIBvSm6uYtNp6imNA0f12qEUTT8gCMGDlADFWz0d7enoyccn8ok8InlRwMbdr6JjYhb263d4wYM6ld4VokZ5MPfciS2HVBPWZ8McWp2ubC9hcyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876217; c=relaxed/simple;
	bh=2Gsp9EJwcV+fUKZ4D/OfStu8rFujvT/O06LlrSOUUEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCN+gPhwlYQBtS6dBcl9j0eOjeqZvqFLtquACrUFq5yaGPVKnZWmhYyA1s4fthuTYuu7p79BTSt2tWa5HPnNeeNisnRbNuWrVArRaWPfqi3w8xi7gTuebNBkPbFNsaW2lddwF37dtG39S7rx8O7r+w8gYUA7oEVSHLxW6QcRR1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHiY1Q9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHiY1Q9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA0C4CEC5;
	Wed,  2 Oct 2024 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876217;
	bh=2Gsp9EJwcV+fUKZ4D/OfStu8rFujvT/O06LlrSOUUEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHiY1Q9PD9yT2yAWvXJtfWGLzr1y9oTYdX+06jwQtWNKsxHjTN1jfr4EaNr6WadEt
	 +MDgpChtQntox3Elx60dZb6D9D3JgDaLpm4NjRdR50bBySzmEJlxWPYcLMFRFr/w6p
	 0/dDA7V7yMfKDtuM3Y1iq4sUruxlXuZpuC7aCvQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 369/695] firewire: core: correct range of block for case of switch statement
Date: Wed,  2 Oct 2024 14:56:07 +0200
Message-ID: <20241002125837.177723059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



