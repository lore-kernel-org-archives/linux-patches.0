Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93126F288;
	Sat, 30 May 2026 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160479; cv=none; b=YjIXPwshG2ble3nQwY4CkElfWED1txlNN5kd1YYGabDg3y/5xd3Gn0H0agT4kx1a5H8UinaX0vyLICutyvI+FA3Wfwrc3HGsNyAMJLuIkuDCNzfoNU1+Y9XQJcX0rlXUBjJSHN1GvSPmOjk2llYmyrrpeT8oOmjPZ0a4udJxE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160479; c=relaxed/simple;
	bh=9NrgzA30flen87cbe1dDmIrJukn52GrmDH1Fimtrn/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKYocaD+lO1Wwf7HKiw3SN99BWe3UNQVRsH1HNfvMLyuBDkFSNDj8zsf1uQbIgW+LCq5bEaJDD5GwlfxVDTN8XdNrL0plCCjO6MCbyUpa63KXWy4gejSsfdpNHdhXbcJCrmcRS7Y7wd5llnkhvXUiz1+vZJ97M+NFBEKQc4UmXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNWZ8c3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNWZ8c3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E47C1F00893;
	Sat, 30 May 2026 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160478;
	bh=iB24yTj9ugAzI/Vg3eBUoJrbZl7V4KbEAFVKstHzhfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNWZ8c3Pl027ARfk8hdyE1OHtofLCd37P2bhdWj3cU/TISx3ejlHtLmkkBh1IU6Ar
	 dYByGaoeZDqTavseTqqNXHSd7dWF6P8GMk2WbWeStcIJYi1auyaVOeX+044B8HYz6c
	 JCyY4nPYqtpibqZ1sFUpmUmTUIS/k1zLz6n0XhWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 6.1 350/969] dm: dont report warning when doing deferred remove
Date: Sat, 30 May 2026 17:57:54 +0200
Message-ID: <20260530160310.022489745@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,7 +367,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


