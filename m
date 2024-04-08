Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FECB8060B;
	Mon,  8 Apr 2024 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582617; cv=none; b=RRcT+vw2qemSyoOUzBQ8na3MCxnkF3gfPjIwo/+JPhpnAezwU9NMIXgUtkQZL2NchwVphrm91hl5iIQqyIX/oaKk/Oj/bm8uzim0yfQPH6iHIhO+ILxff6sMmNEVs0qdK03NyZ+9cVPVfBKy9KSSNSCJ7kG1SS3QpmPKYkDUt5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582617; c=relaxed/simple;
	bh=o+CXbIAbKaRXJJ4PUBmxeH8gn2EqOah8MfYlHqFMUik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYqVgKx3jZ0ZWoYyX7w6W51zC1p1Qs2rknzqeycfyhsLkUnqEMvR0gn/kdxpLZu7F3O9pcX2Q7j+9z3dWbOzBGFywujOmiethcmae0ctVguxKyZyD4anKh56X2DsmLZQQvMtVl2a9zDufg5uG4tlVA9q8hwW8c7Qj0tQ8lGNqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSL6393F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSL6393F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B345C433F1;
	Mon,  8 Apr 2024 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582617;
	bh=o+CXbIAbKaRXJJ4PUBmxeH8gn2EqOah8MfYlHqFMUik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSL6393F2pJ18YSgsiokLQi1QpuqG6DG09TJWKMk0RLNUrDJazjk83PTdRGItznL5
	 ABfxj8z4zn2L6sXjbIdW364mi5Zw0tQZ7zTRvKE9eh1kUNWTYfPsqxxYyP3u6rRSdY
	 J5KjQrN5KQ21vD/MccaS23bxlPObDyLn2QwYKJqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.1 120/138] x86/mce: Make sure to grab mce_sysfs_mutex in set_bank()
Date: Mon,  8 Apr 2024 14:58:54 +0200
Message-ID: <20240408125259.965665181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2471,12 +2471,14 @@ static ssize_t set_bank(struct device *s
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


