Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A336340410;
	Thu,  2 Jul 2026 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009918; cv=none; b=g7m294X3m0iyJ9WaFN5BYNVfX22PY+dHMDzyK1XO09cMldvNLMt1MTwHYoGKbOvWPLPGmUL6qWOlLkMI4QJ/2+y6m7KIxVV4N91/Kpbwuu5m/QZL2RiXthAAkmu4858YmiXn69FFSntO7NcO++EpWBvx3gElDwoJYT3gTUUDjek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009918; c=relaxed/simple;
	bh=mmYZYvldZB/ODuhQuKvqsLLa/ArLUiJPS/H2EjoXijI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdQ5MaWNGJ/gLFIKtk9au9KJAEPX0RbIKohEUkp64c9Q+HGT2OwNvSLRFIBM1faV90sMkYRgCK0N4mlhQaSAU4YcXYV+8a94yL4fJY4gonNud8NIM/I9YvygwEjzSwDG6RPNWGmZAark0OoDzPdyasbNIhjBKnnzjrlCURkogPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfuZne0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfuZne0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7FE1F000E9;
	Thu,  2 Jul 2026 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009917;
	bh=yI6TZvLp5Vd1mzlNQCSOXqM8FnDXh+Cfy4WP0otcASU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfuZne0ZVGzHHrr67GPrygPYv7SoWAjJLF+IWVtFZ3TAZojCLA1u6VRZJq1rI1v3p
	 R71SKXtgAv1LkjcAoYOjzkRIegcqk83kSNrrhZMaR7Ciu7weMmGdvCe30alBB5TAlb
	 9b6fBZcBt7HsjiJsKQV+WPTitXA5zom98V1JJEAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.1 040/129] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu,  2 Jul 2026 18:19:19 +0200
Message-ID: <20260702155112.983166420@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

commit a287620312dc6dcb9a093417a0e589bf30fcf38a upstream.

A KASAN null-ptr-deref was observed in vcs_notifier():

BUG: KASAN: null-ptr-deref in vcs_notifier+0x98/0x130
Read of size 2 at addr qmp_cmd_name: qmp_capabilities, arguments: {}

The issue is a race condition in vcs_write(). When the console_lock is
temporarily dropped (to copy data from userspace), the vc_data pointer
obtained from vcs_vc() may become stale. After re-acquiring the lock,
vcs_vc() is called again to re-validate the pointer. If the vc has been
deallocated in the meantime, vcs_vc() returns NULL, and the while loop
breaks (with written > 0). However, after the loop, vcs_scr_updated(vc)
is still called with the now-NULL vc pointer, leading to a null pointer
dereference in the notifier chain (vcs_notifier dereferences param->vc).

Fix this by adding a NULL check for vc before calling vcs_scr_updated().

Fixes: 8fb9ea65c9d1 ("vc_screen: reload load of struct vc_data pointer in vcs_write() to avoid UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260604060734.2914976-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -699,7 +699,7 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
-	if (written)
+	if (written && vc)
 		vcs_scr_updated(vc);
 
 unlock_out:


