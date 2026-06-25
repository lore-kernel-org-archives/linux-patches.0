Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AAF2D5412;
	Thu, 25 Jun 2026 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392916; cv=none; b=ZU9XRN/bx7kPujJ7GrNN7xxXl3wQtGBKbswwIHXvGD9s8fDsMvc9/qTDO1B6OKVx33Z8mk87kQK4GArv3OOK4kVOhq2cDcLc4JFrbcghdnMT8Iv/kEv0qK5+sZmeLkoNJvTJcEeVJtYvpq/Dh3e/UJUCQC5I3DJGTCEzH1N6Dj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392916; c=relaxed/simple;
	bh=uy5aw7NxE4B6ii8cqHzAbQKnAZmfhG1w8d1NJqDuYx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuBhraXvw2oxZynXi0MD5sDyU60VlVc0VWQbcryvlfy2bYFkHs9Whtrm9GilDB3DQO3JQ/mZYPi7I2yiS5rzVMOKaDyzJgrxayEeNG1M+D4948+6Vmgn/V0L3SKZeyK4O0pzXRfpgbC3nH7nstXLBVlIoxWDWqwIs4IfSbWSmQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9UhukiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9UhukiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DCC1F000E9;
	Thu, 25 Jun 2026 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392915;
	bh=ekNjmgVpYT8ImWK0zjCwqd2S/rXakdJ0eGhL3ptMjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9UhukiZ5DLPuqiMPmrSjpm0b6Wn3F4OhfufknzoA0ykAqax/VSh0VKtg8I6Pwv4i
	 mboBHUpXG8SD/oKSqpZE2OJWD2USzsG8odkgvUksVP101SQw+8Secatu3C0wHWrGBy
	 A1c6aML8lBmzmEDZ6RamxxL+KmVs2YTixtIl4Wv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.18 54/60] vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write
Date: Thu, 25 Jun 2026 14:03:39 +0100
Message-ID: <20260625125653.615614718@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,7 +686,7 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
-	if (written)
+	if (written && vc)
 		vcs_scr_updated(vc);
 
 	return ret;


