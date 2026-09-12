Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A685360EF5;
	Sat, 12 Sep 2026 08:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201459; cv=none; b=s6IwxMKJELYU/phsrhSJjI9DPz4ruGImJFCCZVZ/lyFw/ewRonvLSzQQHpMa1vmv78v/TJaFOCKPqx6V0VNq1emP3Ce1mYx1TuNlNeeCpW3pgzM6MAY7IlFXMklrFs98/oEMc3epiCjbIf2gIgPaZCngHRfepqeUA58c+3cHXTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201459; c=relaxed/simple;
	bh=6v5Qpe169nlREFwHWp3dQ0Pw1A9QaGD8gjK85X/T8Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJ1+xNDHGay7XBZ17KhXhvlKiHxVvUqeFEN7/PgIk/0/aqicjszjW/4iqyb90I2VlunW0gPQiAMJiyqokkRGYV8KwThlaen6w6IViU/uHsP5+25Owv/qaLzV+nVztY0qJPgS3rVCuqT8j4IvSyp/Xc8QVFcnCEqc65gSgruX8Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kwm7RXWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kwm7RXWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8401F000FF;
	Sat, 12 Sep 2026 08:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201457;
	bh=h5lKIu2vtuifY4S1dMvbSJ2gQ8U21v+1eUSRzgmTT7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kwm7RXWB/MRQErfv4TKtNlykCJ+SofvHKGFA/VOX4Uq3A3EswU4QKuU4p50YRaAt+
	 2HV5nS7p1iRWtPtLKVt5ld36VoAmypTa3/fQqkuc6DkKg1Rwjx3P5LoZlcopV7u3L/
	 3FDJ4c7qex97Ls7fsmAbyWaw9GW0BhQtsfQpJk2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0998/1815] tty: clear cdev pointer after cdev_add() failure
Date: Sat, 12 Sep 2026 08:45:48 +0200
Message-ID: <20260912065712.428257305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index e742bf9d86312..4889076b975f3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3167,8 +3167,10 @@ static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
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



