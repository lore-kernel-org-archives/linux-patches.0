Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018435;
	b=WidqVH/6RRRDBCSgIRilNc0pHEFmXRUomHO26f/JpPHcdA96hSzcCtRu8vgI+u7COLlo
	 FQXTXGEZUa5HHXdTYcMZF2/MhaArS9dUJjpsmhyrRUTwIYk45+f8Y+WDPz2vZHeSvlBQn
	 FbiswwxdnfjodGBCsJdPN3QfoHa2mn1gtgy//EdaxpmyUp0HPbnWhdYfEp5m+QZgnpo2+
	 yKypmcw83RdXmLih9wdKBL/567disauI+eUJVoL2R74XT1MH6MC7XS0/DS2DEIhxgRL6n
	 UEqXpGodkCDBI5snt3S7kosdWSaMm8xgex8RrvoA55gZjzx0TuxYlP4vSMVAbllaqPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tP9vgn7WEPOTnSvrscWT5Z99IhPaMsBeEQHepK6lO8w=;
	b=J8KpQOA5BeTZjU5n9pBg1RoePLiWqzc2vLnWrmvDrdUb6lvGNkSHYtbtFpVXMXw0oIXS
	 Mc9shJYYS4bHiEao8QOVRxn1tDpGWFteQ9MKwYvd4SPr5VscLUoO0+3N+HfPzz+WHxTcD
	 BpVAUZPLbkQlkB0U8TRCI0elI+4JOueSTB8ZBDMDbhK3d7YlB0E377BnY0S0S71V9UVvl
	 3buwKah64cqx2jkcMzNPSdu0SQcEIyq/mZ2O35ODHhpAtyuip80hCaSisKELtUFrmMT4D
	 FlxiZRZrt6KeDsPeLoFh9I/zbkeFZWzopjj54N+K5TwB/eT7pt1GKPLzSLVwWhFT3ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnG38W1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF2E606A339;
	Wed, 18 Nov 2026 16:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnG38W1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962F41F000C5;
	Wed, 18 Nov 2026 16:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018435;
	bh=tP9vgn7WEPOTnSvrscWT5Z99IhPaMsBeEQHepK6lO8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnG38W1GEkYTipBd5TXCMr3C2m5/TCvA5wM1DdRo4j6tbfGStl8udAUcN9XgF0kje
	 NlurIP9C7i2ctWx/7u/hON3qrz9pppni+xSWQHTLKqrEj4Xnto5ldx6tAOEG2+QIOk
	 37/LDdxG7+0xB1yVgs9LoaHoTmqV1llBl4vITUfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1239/2651] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118150332.605257190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 900bf42e0ff8009f66ffd4a679c56264957019dd ]

consistency_policy_store() sets MD_HAS_PPL for an external-metadata array
that is not running yet, without holding reconfig_mutex.  But ->pers is
only assigned after pers->run() returns, so "not running" also covers an
md_run() that is in progress under the lock.

If the write lands inside raid5_run() after log_init() has decided not to
set up PPL, or after a failed ppl_init_log() has cleared the flag, the
flag ends up set with conf->log_private still NULL.  The next idle pass
of raid5d() then does:

  raid5d() -> handle_active_stripes() -> log_flush_stripe_to_raid()
    -> ppl_write_stripe_run()

and dereferences the NULL ppl_conf:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000002
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538

Take reconfig_mutex around the update and refuse it with -EBUSY once the
array is running, in which case ->change_consistency_policy() is the
right interface.

Fixes: 664aed04446c ("md: add sysfs entries for PPL")
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260924171345.75894-1-ngocthang2710.1999@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8c56c521a8f8a..b103784a3cb3e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5887,7 +5887,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
-		set_bit(MD_HAS_PPL, &mddev->flags);
+		/* md_run() holds the lock until ->pers is set */
+		err = mddev_lock(mddev);
+		if (err)
+			return err;
+		if (mddev->pers)
+			err = -EBUSY;
+		else
+			set_bit(MD_HAS_PPL, &mddev->flags);
+		mddev_unlock(mddev);
 	} else {
 		err = -EINVAL;
 	}
-- 
2.53.0



