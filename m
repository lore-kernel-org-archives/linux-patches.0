Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE08245022;
	Mon, 12 May 2025 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072203; cv=none; b=BuuI/t77nit2H6VsLhx9BdOEo9JeB34/4QzIzD/Bc8/ilWNi7Ay/lz84t81bZXVByenCicuom+46aLywm3qRHLY9XDgVLV8+/8xHxt6Ut8VAYmSwuHpVHPamrTzTGa5QInjDQokavHx1KrYfNPJYXOCcgj8Hyzwz3nVfc7VtH8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072203; c=relaxed/simple;
	bh=PzHaGJqLbZIvolEzZ/73ZA1RVxyt/PFEx4crTjfbod0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bgd7aHNNQgZkmkRzMqyUQBJzG+pAFXZ/yuVBlRSpQafnyFHt5hhZWtrL4kx2gLvJoPKNsk0DQvo+JHB0AKt7KUUcLcEAcL0f9R3YegT3MINp7XjyftJoWTTiKEyp15V7nZjPHIY956iDKI6gbq0VbSpGM2+ngWIPJohEvEUFmwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abvo7IVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abvo7IVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D942C4CEE7;
	Mon, 12 May 2025 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072203;
	bh=PzHaGJqLbZIvolEzZ/73ZA1RVxyt/PFEx4crTjfbod0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abvo7IVJXurAvPfeGebsxiTik2LjmNMFpo2oLhAHFSxnOJp06Fa2xRzQ1jS2WRWBd
	 2rt/eYYfxqfylKiKlb4bsG9CkDl1E9DK0hQtJrtt7hSoBh1y7SQsMOrDk0XusMwlVu
	 NWCqCNggFMEBUMMd6QlU9ZRW3HTCfB6WnfyDwN3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com,
	Petr Pavlu <petr.pavlu@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 6.14 127/197] module: ensure that kobject_put() is safe for module type kobjects
Date: Mon, 12 May 2025 19:39:37 +0200
Message-ID: <20250512172049.565482030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -949,7 +949,9 @@ struct kset *module_kset;
 static void module_kobj_release(struct kobject *kobj)
 {
 	struct module_kobject *mk = to_module_kobject(kobj);
-	complete(mk->kobj_completion);
+
+	if (mk->kobj_completion)
+		complete(mk->kobj_completion);
 }
 
 const struct kobj_type module_ktype = {


