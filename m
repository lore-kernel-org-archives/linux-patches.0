Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6192C231C9C;
	Mon,  2 Jun 2025 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874603; cv=none; b=Aer30nO/4zZDf5CAwM7/JJcmbqkU9aXcBMuvIGRR/UnmzSYULdEMuGKVIH74f5MCMjoukwNzyChNkX/ovPzjDXQNKQZ2stxsuAQwhhT5bgEgtxDA9mlCceSi3GyHqlOZWt0mCvCx/qHUaDyCR8REOFsV4fN5YmrlTDvduHFdKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874603; c=relaxed/simple;
	bh=NmovvHZ83CDjL1Y90mr06epUCMlVzQNtTkfFnTGpf4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfpoNiHagINM0GzLC+jDGsFfsUcl2Cct7cfVIy+T3a0qXcaoY9N6AITjrihMZTFD7TktlCLGs74zvdrHBGb6UbAWSrM/k2pgfWJTXn6+F7Dx+qIk5FYME2SUjI9Oq1OkuacUlPsEOvnxJLo7X/R0h7VgR4KwNSFAWSPfErQ49BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFjrnro7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFjrnro7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60D7C4CEEB;
	Mon,  2 Jun 2025 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874603;
	bh=NmovvHZ83CDjL1Y90mr06epUCMlVzQNtTkfFnTGpf4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFjrnro7NLxvDWGRizSfAP2QbyOJ1aImt6w/0oL6NZuX1oZ5uKLsqYU5onB1BZ/qH
	 FXK+i9yk96pH4pYogvLuyWVCM4GXYFEbOgh3V8bSNeVDKs98waAhNGQ36mQki8igEn
	 ztRQqXfAkV+4UINxjRkLi389kqgREHeVJoRlqu50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com,
	Petr Pavlu <petr.pavlu@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 5.4 047/204] module: ensure that kobject_put() is safe for module type kobjects
Date: Mon,  2 Jun 2025 15:46:20 +0200
Message-ID: <20250602134257.531970151@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,7 +946,9 @@ int module_sysfs_initialized;
 static void module_kobj_release(struct kobject *kobj)
 {
 	struct module_kobject *mk = to_module_kobject(kobj);
-	complete(mk->kobj_completion);
+
+	if (mk->kobj_completion)
+		complete(mk->kobj_completion);
 }
 
 struct kobj_type module_ktype = {


