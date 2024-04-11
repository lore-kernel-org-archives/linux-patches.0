Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D743A145353;
	Thu, 11 Apr 2024 10:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830941; cv=none; b=JpxMlWI6LFF4/2sEWyXj4TE5BeVnpvoSYUM7mNYK284qKMsgNiy4sWrTmtBLGQCeKOWq9yrz/As+s0J2YfkymzE0ShEizbA4QFoUhOMdKhZpBcLv9ZXh+vFtyO2VusF9+TOSCdSiDdeBSbc59+II7rBNM7wl2T+cRkeP7jsrJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830941; c=relaxed/simple;
	bh=2d4rMJiPl8vDrdQIEGv23Rj1NhaFAuI6z6uaBTnFNck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCaJSDIXJfZPjfMcr+sMwhpdkJlRBKG6TL9kvTaBjTpXoh/O4200oROjrsmCkIZcgDSsRgS4J83BHUr7KBztUI32dle8mBG6Mqm7KYsCC1+fY0VDnHiipXGCZkeD88MnEOfZ7m/L/fqXrbC7Abvf/nKFUUZ82NL9vqG7Q9JIqDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUC4jVHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUC4jVHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5487CC433C7;
	Thu, 11 Apr 2024 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830941;
	bh=2d4rMJiPl8vDrdQIEGv23Rj1NhaFAuI6z6uaBTnFNck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUC4jVHc00jpEQ3YEJsc6flSKovL5iuiQzZR6AqIZ2QRBmwuI01yypgtZELh5XglG
	 69aGQC0dA4gIGNKqDtNyexFbBjk6HaKjoGZBIT9j3nYbZ6IWSf+aIIbQ6SWwqUUQSB
	 j7AsOHt85AYfca95RTri/4d0eXnCghs5NbA8y4+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.4 170/215] x86/mce: Make sure to grab mce_sysfs_mutex in set_bank()
Date: Thu, 11 Apr 2024 11:56:19 +0200
Message-ID: <20240411095429.983218277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 3ddf944b32f88741c303f0b21459dbb3872b8bc5 upstream.

Modifying a MCA bank's MCA_CTL bits which control which error types to
be reported is done over

  /sys/devices/system/machinecheck/
  ├── machinecheck0
  │   ├── bank0
  │   ├── bank1
  │   ├── bank10
  │   ├── bank11
  ...

sysfs nodes by writing the new bit mask of events to enable.

When the write is accepted, the kernel deletes all current timers and
reinits all banks.

Doing that in parallel can lead to initializing a timer which is already
armed and in the timer wheel, i.e., in use already:

  ODEBUG: init active (active state 0) object: ffff888063a28000 object
  type: timer_list hint: mce_timer_fn+0x0/0x240 arch/x86/kernel/cpu/mce/core.c:2642
  WARNING: CPU: 0 PID: 8120 at lib/debugobjects.c:514
  debug_print_object+0x1a0/0x2a0 lib/debugobjects.c:514

Fix that by grabbing the sysfs mutex as the rest of the MCA sysfs code
does.

Reported by: Yue Sun <samsun1006219@gmail.com>
Reported by: xingwei lee <xrivendell7@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/CAEkJfYNiENwQY8yV1LYJ9LjJs%2Bx_-PqMv98gKig55=2vbzffRw@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2228,12 +2228,14 @@ static ssize_t set_bank(struct device *s
 		return -EINVAL;
 
 	b = &per_cpu(mce_banks_array, s->id)[bank];
-
 	if (!b->init)
 		return -ENODEV;
 
 	b->ctl = new;
+
+	mutex_lock(&mce_sysfs_mutex);
 	mce_restart();
+	mutex_unlock(&mce_sysfs_mutex);
 
 	return size;
 }


