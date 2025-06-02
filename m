Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA69225397;
	Mon,  2 Jun 2025 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875316; cv=none; b=Y7D4qhCuf7WXOuS9HSNU+Qj4aMCxoatJSysDp2M8BGMjIYuqbw5INCw1yZtYPmEJlusAmjPcQNRZJeMBNMPh9TZ8wgWD3Do7yaysaBqe1v4sUcQzH7eQeFwsoqtK7S0ruqtj/Pf5EPWxKz1+MYpLIW3aP5gq3jDHLtegRp1HS0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875316; c=relaxed/simple;
	bh=7F2v1DodzmSEU+zAi5DK2FN6RgJY1QdCXZfoo5QRPgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCWN1dnw5/3DrUV8moJSGaekzKDcdIdPgTvJZ54GI42K/Bj/VXrQw2Ymf5nyNpUDGAONYZSqnJM0jtXegTy7+K0brbYIz27iZ5Dtps0uGPQXzC3mAIXM5l0M/YqmrLPG6FM2lEBkfivEEPjbmvOuCTpC6IjgSC5vNPlWTbZs9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9r//w0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9r//w0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6AAC4CEEB;
	Mon,  2 Jun 2025 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875315;
	bh=7F2v1DodzmSEU+zAi5DK2FN6RgJY1QdCXZfoo5QRPgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9r//w0hxJA0SaZisY2m4I+5XKFlsqKrObwXicjCYfnfnvXgkG+CcjmjHbzkWuXOh
	 yzZISQZsL0B9fHEFXS4JAm5al5unFQuKPTsZO0DJf+6zSeLWBLOHtP6V39Txj0VW0d
	 Fq3wK1j5KNNoLJmTXB1+g/ZkZVvF8vMfpXbY9hEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com,
	Petr Pavlu <petr.pavlu@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 5.10 065/270] module: ensure that kobject_put() is safe for module type kobjects
Date: Mon,  2 Jun 2025 15:45:50 +0200
Message-ID: <20250602134309.845992602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -947,7 +947,9 @@ int module_sysfs_initialized;
 static void module_kobj_release(struct kobject *kobj)
 {
 	struct module_kobject *mk = to_module_kobject(kobj);
-	complete(mk->kobj_completion);
+
+	if (mk->kobj_completion)
+		complete(mk->kobj_completion);
 }
 
 struct kobj_type module_ktype = {


