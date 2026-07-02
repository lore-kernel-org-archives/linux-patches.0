Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997D0318EC1;
	Thu,  2 Jul 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010772; cv=none; b=RrUpY4CbR1qIoY6QnoiwLxPBY/xE45JrTGgVCdgiQj8Cju0KRn0iZFhg38nqv5axDq/YTm83ZlAAtpudqvuKBfyjVz/fT1JPLgA7byoPTkWNLj7p0Dhw4X/zzC0vW24X7JRwqw7OjLQHGZT+/ulERo/FIUgFBRcLw5HihCjxmNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010772; c=relaxed/simple;
	bh=1ZSysurYyrLC2HSp2i3Zl6849nyeg5DBm6W8z5IG9cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPfUQu0ubOmyg8otYWAtk11tSwrEGEw7+1rX+rKqc5+5oH3tBHuB+hzR7gFy3ESyWb/ifyWHeDumNm/RGxZov5eqZLB535u4aDdU8pzH2zgZaXs6aZ98tGk/0/Tr+rrzLtyrxWyd5NCOGSUmkC7Clrc3F6w/1XBd8zvoK8n1kO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw+zDJrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw+zDJrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA761F000E9;
	Thu,  2 Jul 2026 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010771;
	bh=bVyuUQF7MH5Sd8OuRn9Myi9r2e6vxsYrziDyJAhCRpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pw+zDJrl9ctaNDBU7591UkwNmjdulLJ/dcGSVVDuI8OReZGvFwtUDeqX61ukc7FnI
	 50oi3PMuIGYpi0Tik+OVeivXWICukXYfNFrF/Qg3jy3NWtOjww0HZZwLxOdLGAZxwE
	 E4GmVJbx7rogf9a89q/kjrDShC4fx0JsSCu9/gjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 6.6 030/175] dlm: prevent NPD when writing a positive value to event_done
Date: Thu,  2 Jul 2026 18:18:51 +0200
Message-ID: <20260702155116.433332769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 8e2bad543eca5c25cd02cbc63d72557934d45f13 upstream.

do_uevent returns the value written to event_done. In case it is a
positive value, new_lockspace would undo all the work, and lockspace
would not be set. __dlm_new_lockspace, however, would treat that
positive value as a success due to commit 8511a2728ab8 ("dlm: fix use
count with multiple joins").

Down the line, device_create_lockspace would pass that NULL lockspace to
dlm_find_lockspace_local, leading to a NULL pointer dereference.

Treating such positive values as successes prevents the problem. Given
this has been broken for so long, this is unlikely to break userspace
expectations.

Fixes: 8511a2728ab8 ("dlm: fix use count with multiple joins")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lockspace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -631,7 +631,7 @@ static int new_lockspace(const char *nam
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	/* wait until recovery is successful or failed */


