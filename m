Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFB9348C66;
	Thu,  2 Jul 2026 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009910; cv=none; b=pQxSgnmpneLoCBc5STaxNX4wKQnHwuglqKXQMPTa1fAfZPMBAv/d9306furj7nxZzy3v8CsrBwgDa6+gimQoCsM5yxHtQaj1az5iYqJ5or8EO53FQ5Z269oS2g8vwSEg8IdBp30ZPTAKGEx2dCjzd+4mWn49y320tw9OhhntNrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009910; c=relaxed/simple;
	bh=o9A2oUrkhzq4KpkxdrBIBjnJ0igeqbj8p+mFX5PiL5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLhV7dmbCrK3P+2u7vZ4qGozxTzCrhxk5ssNQCbC3jckpa+tPscjG+OuSdY6Y39O3VzyVrfJeN7TDIYERPa7E4GeH7wga8e3JTnruUaUZ/Q73reZQrVpkShTw7YNjrj4so4wt4KM7gYBh/Fs6LzH/0a/P+VXXGWdCcCj1kGZJG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZhOARbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZhOARbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE311F000E9;
	Thu,  2 Jul 2026 16:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009909;
	bh=MpO2fSAmRzwyFQB1TeKmA3sI6yoXP3hvDMQZjp2ii58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZhOARbxXLCDDJuF9PWYc90o2iFcUW3+x/KWiDQ5L0otgEXQ86/3m7Kj8d0haNYwf
	 bYxm8igExITsaFU4raz32/7xO4RbaokguvTjU4yNFTbIQpwOljQlpNkPoxxb5VrajS
	 2K0jypLQ1ykXnKnytxlnEVq2YO6jPo4BrQ/pyxYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 6.1 038/129] dlm: prevent NPD when writing a positive value to event_done
Date: Thu,  2 Jul 2026 18:19:17 +0200
Message-ID: <20260702155112.942749372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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
@@ -657,7 +657,7 @@ static int new_lockspace(const char *nam
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	/* wait until recovery is successful or failed */


