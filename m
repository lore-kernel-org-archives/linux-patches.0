Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02871D7E5B;
	Mon, 12 May 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072957; cv=none; b=V4u+KCmaL9AQOcX63hef9dnMqaRANlSVfJLgICk+25eFXERfIHmLucfSvrJtbhyavwimRJs63X18flph1Se3b/F3Hf0UI5txf1l9j9g8weTcLzj/s7zWgG/hdmOAZF8YQJZjWaVzY9cqyw5UuOi7N1/umtdjCmCaRtay9wggR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072957; c=relaxed/simple;
	bh=jVtR00rDhofu3t5VmxcpbrOoG5K1hekQ+MlA3NBcVD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFwGaeLS3EDfGb4jHFC7/eShKVgV/Bdw7AZeuwmI6HoOMMGTdMcYCB8aGuuQu7O1yK32rLPPeJvRT4Lcy4kh6yCRAMqoOlMNtG09e4RKCoM3VS56sgr+F8kkxcte1BlSP2CsPeATzh02Wn+HDSyj10WHWfiXkCPp2zrCa3sQz8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NST3L6AZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NST3L6AZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D0C4CEE7;
	Mon, 12 May 2025 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072957;
	bh=jVtR00rDhofu3t5VmxcpbrOoG5K1hekQ+MlA3NBcVD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NST3L6AZcoPJj+0D5Zn7RoCMMO5BgEiQtIUTCEP2ZDh+NPfaWLSqTo+FB/nYHBa9F
	 qZEPsA3sSp+uMEArNUI9PiTyOb9o6qq2/PkfNc3yIfVibaHnlUcdNbGX6YbOa9dRAP
	 FBKmN89t0qzXp9XPfU90/pqC03K9uxnqnrtRWhRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb8a372e1f6add936dd@syzkaller.appspotmail.com,
	Petr Pavlu <petr.pavlu@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 6.12 110/184] module: ensure that kobject_put() is safe for module type kobjects
Date: Mon, 12 May 2025 19:45:11 +0200
Message-ID: <20250512172046.308435565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


