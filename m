Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A7734752E;
	Sat, 12 Sep 2026 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213744; cv=none; b=Be8W10Ilc4+hJE0K4Vb4QyFHgcb1dYDgMpL0Flu4CQCr59q9KoCyX+2VQoSz7nkuMcnQI/a2IywBlxFsn6BNPnJc6CkTTGGHv1uCwozyLtqJmOuYH8fhw+2OIpOJNy5LA9YOfI3TsEhrhHSHq1dwIyb88X58+XdCzaOdiTkoGOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213744; c=relaxed/simple;
	bh=36Ux6iS02vtc9fuAKO812LQLOqXfs52XG9FVQwKSFAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSq2qG0ilI7yxFzRGKyuRiw1Pn1zcy5RlGvNHReZ3+/WFMDpMQq2/8UVlgKiRWVkc3RMoSz1bNA5eyLb2Jfi8i84pB33Vbp3FPEJiygsUQSYseVVCUdGeGiPHzwSFgXZw+5MZEdL8Qpr6GL+9747wwZkgOgLJZqQoi0yoYgLI0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBiAu9l+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBiAu9l+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AED51F000FF;
	Sat, 12 Sep 2026 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213742;
	bh=Ap+9zF73wsXmqLGK+jIqqIJFF9jiU4rS6LWWpKsD2eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBiAu9l+MG5LelW4jeVsrn5CM+6RZjzME9UIrfNFvvg8BVBFXmAIFFppd8E0r9N2z
	 ipBJC7BAF6tqijZ7gx4GqS5dOKyITGfB1XC6CTA02PVAqjjt377qu7H8qUwMzPNtN3
	 gfvZiloaUGjEQhTMt5VjS8sgKIOC8RdHV4i45meg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+051024d603432b4ab395@syzkaller.appspotmail.com,
	Hillf Danton <hdanton@sina.com>,
	Biren Pandya <birenpandya@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0182/1376] media: cec: disable delayed work before freeing an interrupted transmit
Date: Sat, 12 Sep 2026 08:43:28 +0200
Message-ID: <20260912065611.607391471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 0fbd5c2327020858c45b2d1c65775d64cdeca523 upstream.

cec_transmit_msg_fh() drops adap->lock to wait for a blocking transmit in
wait_for_completion_killable(). If that wait is interrupted by a signal,
cancel_delayed_work_sync() can run before the CEC kthread arms the reply
timeout via schedule_delayed_work(&data->work) in cec_transmit_done_ts().
The work is then armed after the cancel, and the data is freed with its
delayed_work still pending:

  ODEBUG: free active (active state 0) object: ... hint: cec_wait_timeout

Use disable_delayed_work_sync(): it cancels the work and disables it, so
the later schedule_delayed_work() becomes a no-op and the work cannot be
re-armed. The data is freed right after, so it need not be re-enabled.

Fixes: 490d84f6d73c ("media: cec: forgot to cancel delayed work")
Reported-by: syzbot+051024d603432b4ab395@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=051024d603432b4ab395
Suggested-by: Hillf Danton <hdanton@sina.com>
Cc: stable@vger.kernel.org
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-adap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -964,7 +964,7 @@ int cec_transmit_msg_fh(struct cec_adapt
 	 */
 	mutex_unlock(&adap->lock);
 	err = wait_for_completion_killable(&data->c);
-	cancel_delayed_work_sync(&data->work);
+	disable_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
 	if (err)


