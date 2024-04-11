Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7825564CC0;
	Thu, 11 Apr 2024 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832230; cv=none; b=PXAafTWj/iJLBBKh4q0LsachfmxemZpcnXNhYG9hMLZWAzvoibUalnWg85jx4FOWJO8+1vkC1aQdrPUHHWkgroaBzqoSVNKBF/79qFqu2pM4J71PmDjabtrTbrOPr67wVeCpu0i5QknuqGMlse3VDbvGBkophOZh9vpxXDdtt5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832230; c=relaxed/simple;
	bh=IaQaFdsV1uJ8Ca2PX3D0w6nXUeKj8yHL4Dxx2/RBo0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eqzkgmk3qh1G+JahMJJilPDFktXI7jf1enEynAcrRxsWereCMloTC3yIdebxk/XXeWElwuizsMgtSnpho9NojdGAOaivRJGg0L7x7FTnGdWlOFM1lmVe+v8pvoxY7J2UGgSmk+j72b4uEOaJIzGVAPt/LWHYbgrK8uuir9/0xVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwzAa7e9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwzAa7e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC486C433C7;
	Thu, 11 Apr 2024 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832230;
	bh=IaQaFdsV1uJ8Ca2PX3D0w6nXUeKj8yHL4Dxx2/RBo0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwzAa7e9BhLoj3PrjfZLugUMIAmwqR/X8bSCoQf46XyZFB/aTpLikNnpAlslf8LU7
	 r0XRXlGsXBj3MLcZ0sGUJ5cfVgEsMiUqlckWbkU+8GErhNkVAt9rWpLdV69sUC+XOb
	 pJQEZzYMia6XmsYhEPLI2/Q0Ymb5UiF15Dj9GEYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.10 235/294] x86/mce: Make sure to grab mce_sysfs_mutex in set_bank()
Date: Thu, 11 Apr 2024 11:56:38 +0200
Message-ID: <20240411095442.654621976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2389,12 +2389,14 @@ static ssize_t set_bank(struct device *s
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


