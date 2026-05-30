Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87AB32F770;
	Sat, 30 May 2026 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166126; cv=none; b=F5gIEQkj92nwIzb3mw8J8h4ri5bc9M4LbyFbk5Uzx/zoyc64OytF4MQrnZ1RP15LYuxXwd2NiEhkiAmmrmNBGPZb8RRuqxzCuTG9dC28UeHTMA9O2zbIl8t9dYb37XmlhS27dQIoaJgnP1VSDZuqiK9lAkW1Xd50MjHoQXKrZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166126; c=relaxed/simple;
	bh=s/il88bBuKKjpfMpMKc6kskShOIyoSI5kikhCjlK70E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMBsiNe8wKvr1ZRnVcQ6eN0GTOs8n9HlXeKXRGzmeDsh9qtgLnm3oOtAAr/qJjyBmb29noT4wR16gfLwuuru7En915GLfbac2QN7pkPkP9nShtLnHaAIoDspNQ7JvS9vJR7XywvZ3mqPQpUwn1SGYWbjmEJgwUCmk931EARkXVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy3NePyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy3NePyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9521F00893;
	Sat, 30 May 2026 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166125;
	bh=FCEVLQZzfbDlub5CdC0OTsBtce5RoiXlkZLNrnlO0JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vy3NePyMQ1zDdULUzi1TZLpkBtqsJS5OF1k+wigVE7nwQIh32XbHKr8mmS4uzqntr
	 rzivTcJ/w6HqC3zBWO+f8TbABhf1dxAbY+u3uHeTVZCvXATNacqyOepL8uMnixY8vT
	 fKqYUYBL4Mq8Qq5BuLpY9iiccMhehULFiDH73Z0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 5.10 247/589] dm: dont report warning when doing deferred remove
Date: Sat, 30 May 2026 18:02:08 +0200
Message-ID: <20260530160231.485851072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -328,7 +328,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


