Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248C2D9787;
	Sat, 30 May 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158103; cv=none; b=hnbLsRax5sL7SuTzjSi2xNkKa+EMG35qLrYJb7Si3JoErfvOmGYqyPPeR3swpMyEZX06Qb5kkExVC463z0K8vEFqOM+AfuKevvT9R67ncOUBAzjQBxVDaQi/q1xP+W/KTiWsOSFs05CtHMUCV/pNNJDX5eNEgtRe6271lvruUek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158103; c=relaxed/simple;
	bh=nojabvDpOeXeYRkS5DB06zrmz5hE2HoKEOxwqdXUC0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eenOj6wmMhQbJbPVe94v2ksWWQcPybVC02A7BLR7DQBvsI54Lv4gGq1FKsMVANHLZ1IMPo14ykYU4jJUhFnI9mcL7jucMfD2CY+urgYWO0ds45rEE+cFtj1JP6xL+4VmxlEvqgoXi0kqATU6PrHgGbScZ+QVAPYh7y9M8Vr7R/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+PreYk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+PreYk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80BD1F00893;
	Sat, 30 May 2026 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158102;
	bh=/vzjBwQmeafup3VZueUrlHqG/KSvf6GASFRPUqmrAuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+PreYk5zffIGGuZ12VW7QxfA7GRkFPz0yfvb2nMhQmKPptMbYWVjgqeQ7K0AB7Z0
	 tf5+V0bjxJS7t/H1l4wnYIpLsD4tVSp8IG3JsSJxiY6yLFsQ192aQqnogPMsM92ROv
	 /hMzdBhsEizUazvUaX2E4cE8lp3r5ZNVzbg/mCfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/969] HID: roccat: fix use-after-free in roccat_report_event
Date: Sat, 30 May 2026 17:52:24 +0200
Message-ID: <20260530160301.017876108@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 6da80e442fdd1..420e4335c3e83 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0



