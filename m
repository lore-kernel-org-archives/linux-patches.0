Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B38634E;
	Wed,  5 Feb 2025 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765590; cv=none; b=olm3uN4hsV1OObQaG4JuG92RRM0XzjcZHQbSgm9YxpKBroTMM5fTVVX5SzEMUH6NnT6kd+vLTKH3LYmKOBRyRO55R3G0A84AOy3g5cDncrae9oAOCdBrmif1cnaVLIagXYyfEnR6yDtfVAgILxgwL56RJFEqn3EcddjAPdu6JGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765590; c=relaxed/simple;
	bh=vLeS9xZcLfPcfYEJomkDME8vIFD8Zjlo/nOlm93+2l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV5a4Rzt6DYSrHZaEqV4eVytYjEVW16QZLH+TA6H4iSwbOgvav/HIECJGTnk59ORQeF59Zr1hofGdhWq39O+SUmALa+VbjfWCpyuHQilFd2L9EludrfRoIfQp76BpcvzmtjmayBxckQyGGUqbavdNV0b+cJozB3JXFDDlJxETA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEa6XDnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEa6XDnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053FEC4CED1;
	Wed,  5 Feb 2025 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765590;
	bh=vLeS9xZcLfPcfYEJomkDME8vIFD8Zjlo/nOlm93+2l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEa6XDnC3h2SgSTcA0oF3kQiTwzfZuMSTJOMIrzFZoJNcTwIP79EI55zsNuf7dvfN
	 P0i9dRMfC+Ifnc3EVqUNQv3Qd+Qwd1oGrzi6+EhaPPkSXY3Zr3dpGTTwDfegWn8bre
	 e4OjRBDdhLJg2XGknN1YQxOt7Z649rsSwGnOCSeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/393] media: rc: iguanair: handle timeouts
Date: Wed,  5 Feb 2025 14:43:20 +0100
Message-ID: <20250205134431.060478165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b98d5000c50544f14bacb248c34e5219fbe81287 ]

In case of a timeout the IO must be cancelled or
the next IO using the URB will fail and/or overwrite
an operational URB.

The automatic bisection fails because it arrives
at a commit that correctly lets the test case run
without an error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: e99a7cfe93fd ("[media] iguanair: reuse existing urb callback for command responses")
Reported-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66f5cc9a.050a0220.46d20.0004.GAE@google.com/
Tested-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 276bf3c8a8cb4..8af94246e5916 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -194,8 +194,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 	if (rc)
 		return rc;
 
-	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
+	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0) {
+		usb_kill_urb(ir->urb_out);
 		return -ETIMEDOUT;
+	}
 
 	return rc;
 }
-- 
2.39.5



