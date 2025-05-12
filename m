Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68B2550C6;
	Mon, 12 May 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072456; cv=none; b=NPyoO55cYG2c7A/V6Kp8xu0W3Jxl8y5gAHBjzPj29envbFB+9QY6ASEt2bf964C6cXPdQ17FH8hMyFUp9AGsR9bpYjgzNt1B+M7pvD0phW1wV0tFlEFApl0/j8R9gxC11PalCaaZlhnAqICoFe7AK8bs6LJwtp9Fb3O4uGHbHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072456; c=relaxed/simple;
	bh=RVl99WHpSOGkKteg7+TUuF+oarf9+mD15CMIb/9XEyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyr9mM+GDodFJuBiqVAzfsV3bW1mFBiMkQr+9XzzKA59O7S5RK/c/cA2gImGRNkR96ccpcSi5qUB+A5hycLUoCJ51ITbjK/AdbuHjkj3XKoDYYzLM22MNBChR7Gxn2rb1MJtX96D8azvJRQMQFC0ptp32Wj3RD6KeGPAAwzaoWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEHpcMfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEHpcMfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E971EC4CEE7;
	Mon, 12 May 2025 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072456;
	bh=RVl99WHpSOGkKteg7+TUuF+oarf9+mD15CMIb/9XEyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEHpcMfxmD0BgvjSaBNElIligX4BP/07vUai5wYjC271W1/sYVRwZ/GmDzDdtr7Za
	 X0fomLzrREl3RWKxnI5XJx2z9BvkGf+vxLQ8KDJvNNBBfa6w2E806ahDZlUv4W/xYx
	 V86xWcQtf8Jqx9Qjygx6XNX+3GGCzpRivJ3VJUHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com,
	Petr Pavlu <petr.pavlu@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 6.1 46/92] module: ensure that kobject_put() is safe for module type kobjects
Date: Mon, 12 May 2025 19:45:21 +0200
Message-ID: <20250512172024.994353387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit a6aeb739974ec73e5217c75a7c008a688d3d5cf1 upstream.

In 'lookup_or_create_module_kobject()', an internal kobject is created
using 'module_ktype'. So call to 'kobject_put()' on error handling
path causes an attempt to use an uninitialized completion pointer in
'module_kobject_release()'. In this scenario, we just want to release
kobject without an extra synchronization required for a regular module
unloading process, so adding an extra check whether 'complete()' is
actually required makes 'kobject_put()' safe.

Reported-by: syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7fb8a372e1f6add936dd
Fixes: 942e443127e9 ("module: Fix mod->mkobj.kobj potentially freed too early")
Cc: stable@vger.kernel.org
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://lore.kernel.org/r/20250507065044.86529-1-dmantipov@yandex.ru
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/params.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -945,7 +945,9 @@ int module_sysfs_initialized;
 static void module_kobj_release(struct kobject *kobj)
 {
 	struct module_kobject *mk = to_module_kobject(kobj);
-	complete(mk->kobj_completion);
+
+	if (mk->kobj_completion)
+		complete(mk->kobj_completion);
 }
 
 struct kobj_type module_ktype = {


