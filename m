Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8849133435;
	Tue, 23 Jan 2024 01:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971892; cv=none; b=dmXNwAfZpmWfQwrC2+kvC4EFyGs3MvlQGrCX3yp8kVY7wzhk6OIcidwcA7u21TdhNQ+VBKeOPM+Al9cWPf6F4Lr3YsKhkCRnt6AZatU5h8SRSNraF6wlniR8nlJW5pRxQDTNe/Jzbavc/3ilhgvZyS6dpGZJCUVSafbugUKHdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971892; c=relaxed/simple;
	bh=dZnbMliJHDNMgrvyN2J8iBlHNpT9VpBLWX72ZHn/D3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D55menaWhuP5Bj6nYmDDA4rdsOE/YbW8Of4tW8YD6zhjaijUU5HQxnOXoOputF/VvNi8pj9thxHVvfUiA0V0xac0vguwZvWVSaPCI8aIDOZTQpFXiZPElOdSanVhaMhf8fRSIt4fo84Wqtwteu3UDeMVuvS7I8lVtUjG7gmFYMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taDUMKfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taDUMKfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD6DC433C7;
	Tue, 23 Jan 2024 01:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971892;
	bh=dZnbMliJHDNMgrvyN2J8iBlHNpT9VpBLWX72ZHn/D3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taDUMKfMenrlGmaS3QnwaUEAxBG1GbzlWJDTX0FRBEEpj/IiKC/sXvAzQW6W17kKs
	 4/GgwjTpoOb8+Goo3C73JrrZtfGAva1D2l6DGXl0mmvBRVnyfRnEMiPP2e25zlOwtm
	 R0d/ZJdk2R8tS+c2syZpfLkxyIVK5iGDUrBu2u9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/286] tty: use if in send_break() instead of goto
Date: Mon, 22 Jan 2024 15:59:22 -0800
Message-ID: <20240122235741.891087819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 24f2cd019946fc2e88e632d2e24a34c2cc3f2be4 ]

Now, the "jumped-over" code is simple enough to be put inside an 'if'.
Do so to make it 'goto'-less.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230919085156.1578-16-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 66aad7d8d3ec ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a45e6e1423d8..1c76e77e2d07 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2477,11 +2477,10 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		return -EINTR;
 
 	retval = tty->ops->break_ctl(tty, -1);
-	if (retval)
-		goto out;
-	msleep_interruptible(duration);
-	retval = tty->ops->break_ctl(tty, 0);
-out:
+	if (!retval) {
+		msleep_interruptible(duration);
+		retval = tty->ops->break_ctl(tty, 0);
+	}
 	tty_write_unlock(tty);
 
 	if (signal_pending(current))
-- 
2.43.0



