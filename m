Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781C533E355;
	Thu,  2 Jul 2026 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010244; cv=none; b=IDNjbt/Ngjw/OPQHYupsbSv1hEEyo0sSBv9W/cTUp5GBrLTsj1ZiE2SaLzbyG6L3lRT8lFsACUcmc+3f2emBA1T0forG/xT0TdCAx1WsrEb/bt1mgYJdn9AU/aeUfGB2vGYJCSk6KGb+6plOoB6LrJur87QPsOe7zJWX+dN5/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010244; c=relaxed/simple;
	bh=frotsmf05bJexqtgoQPLKysvR6g9C8bqGjKkdL0rzao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdrzxK6rK2cR3apyXY92h+hCryQjn9r3OT0zFnzfILPmZHTjV3H4rPL6WISpy6szlpLaKFnJ6KGd0315E9xdOLXLnHEOx+9gHfQJO+eIjep6HoI9OdNjJaXsFiMNlHPCUPv5oYDkGxzLN5dnpOrUBt/E3aNO1c7pbT787GS0mZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t102u71h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t102u71h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9651F000E9;
	Thu,  2 Jul 2026 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010243;
	bh=V5Q8P440fD69VByTGDzSkPYbKeWDsu274Sj6ExIQIOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t102u71hWnSBDA9kuRXJdSySzqdfUCDmW2X3rY0r4EovIaz9I3A0qFW8NtUtgRp6R
	 C44KjmkrGGisMIJ9qThCH8xtb0yU2P15/KcXGh+Kr2Ky45zKFFwAetcnWQO9gbZZJJ
	 vGsRZnEZTenjdzqJlKk/7hVnQOZ6zuHJ0yKV+bsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 6.12 035/204] dlm: prevent NPD when writing a positive value to event_done
Date: Thu,  2 Jul 2026 18:18:12 +0200
Message-ID: <20260702155119.392791090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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
@@ -576,7 +576,7 @@ static int new_lockspace(const char *nam
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	/* wait until recovery is successful or failed */


