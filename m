Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05455242D65;
	Sat, 12 Sep 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224538; cv=none; b=SdSWXd/qidwZWMtVG35Io+FN7lp2QviIcKRHUNiadjpzcmjxgiBhV+9ClWO4WBkzeU/yWJsFvQ5WkVNCnTjgDQbNUj0L1S4qjdxI4XZ1y6ovmcmN46K5g7SqKVorlnKiU9E6MEPFCrZ4AhMVTNIHdDh4qdLsJKcAY+zXXcMQTZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224538; c=relaxed/simple;
	bh=VFPLTym+ckTqkwAmjgRK5UoyZ2gscSkCy+m+X9ensuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB/HuWxRCRVrDsk4pASwOU1ZMDQ/IIqz1bRvwU5Ewnwl8ob8Sa8i5sb5RiUx0pxjgcTmxyo1YEvf3CO5TDx1liHmnll5vvvF3Tq/iPEvfEhi1QL5QsnpIB6Nd3jZ/BxjPNygQzHupPqLxgWTaUsgALD3hnYHl1UBHUOdYQ3kNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcmlBGll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcmlBGll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743A01F000FF;
	Sat, 12 Sep 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224536;
	bh=TTFQEOBPkAb/okEINIWr7s3ta9WrKVg/A6EAlYo36t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcmlBGllZ6D1N/at6Qo2qXJCS2xeddM8Lw++YyzNA2/COiEIxOfeWq5dk8rBAB+RP
	 AAJhWdoASqtbN6QQA+88w6loP/0RLzg+/vfbPgCJgW/+9WNbazUalvzfp3970ZYo9t
	 tRyDqR4+kPTniIAaWxN0MIzFa8Q9rnZegVVtEIBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1014/1424] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 08:57:26 +0200
Message-ID: <20260912065630.019361029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6645856f0df3aeecd45519cb611415b4b89c2223 ]

tty_cdev_add() drops the cdev reference when cdev_add() fails, but
leaves driver->cdevs[index] pointing to freed memory.
tty_unregister_device() later passes that stale pointer to cdev_del(),
causing a use-after-free.

Clear the slot after dropping the reference.

Fixes: c1a752ba2d6b ("tty: don't leak cdev in tty_cdev_add()")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260731181844.11330-5-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 117abcf366d95..6781bac852cf4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3157,8 +3157,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
 	driver->cdevs[index]->ops = &tty_fops;
 	driver->cdevs[index]->owner = driver->owner;
 	err = cdev_add(driver->cdevs[index], dev, count);
-	if (err)
+	if (err) {
 		kobject_put(&driver->cdevs[index]->kobj);
+		driver->cdevs[index] = NULL;
+	}
 	return err;
 }
 
-- 
2.53.0



