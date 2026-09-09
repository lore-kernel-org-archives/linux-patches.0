Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3118955409D;
	Wed,  9 Sep 2026 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962721; cv=none; b=RwfHaFezr8aLqkcMlhbIdIuGGyVGIHsnVgE3bYIdlRxKpYDIRAUut2ViefFALjZh40U9GOBNUEdT2zdlpVCgGNpsZDpkXVTan0/KOH9JVvx0eT1Rup4MPIeecyfwiUjH+hbY827NMeaxAltaLhDAJvmysJ79pFCkBaO51ot8TLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962721; c=relaxed/simple;
	bh=Sv3nsHQaSd0kA9P+STJw8BO6GOt9y24Kc1lSyu7Gr7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyhAEEe2Bip6y7mPKBfstWUch1gW5ldICtCQk5aDq601L5CLGfo/K58vgYbc6ND8hn4tN/T/UP2IYnfbnCwgzWlDWvJgw3BmObYdd8P5IbD9ZtzmsG0VJSL3l4BU0ixNZXb0sp7h3H8cGnfEmOPkz/z6A5svL105Y2725hqxLvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESjYdKAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESjYdKAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866221F00A3A;
	Wed,  9 Sep 2026 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962720;
	bh=USWutun2NJiR2SCM0p4ohwvDt6g9U14hWwNfhZx4fgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESjYdKAFWs2gociv5qk0nUjWIh/LkN43J6HPw59f19WXUOA1b5lSxPU/ZYOLUTfmm
	 JmqTZgl2uvSzW5ToOrMNSrAiFiYGk4NZ7a0o0iEyHwsvDNyie4suoLPhOBUQ7qiv8Q
	 fxohpjrgzlzdlNh96j8MkT8hnXskPlKpbnbG6joY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+051024d603432b4ab395@syzkaller.appspotmail.com,
	Hillf Danton <hdanton@sina.com>,
	Biren Pandya <birenpandya@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 350/556] media: cec: disable delayed work before freeing an interrupted transmit
Date: Wed,  9 Sep 2026 15:40:30 +0200
Message-ID: <20260909134242.971197423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -965,7 +965,7 @@ int cec_transmit_msg_fh(struct cec_adapt
 	 */
 	mutex_unlock(&adap->lock);
 	err = wait_for_completion_killable(&data->c);
-	cancel_delayed_work_sync(&data->work);
+	disable_delayed_work_sync(&data->work);
 	mutex_lock(&adap->lock);
 
 	if (err)


