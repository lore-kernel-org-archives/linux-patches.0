Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F88412BF7;
	Fri,  4 Sep 2026 05:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498527; cv=none; b=Ky9WQG2QuKmRINK5Phn2CE++3gIOSR/aoMqaOfNo10Q27b4BRoOJ9eTMUtVfWoVQ+pouZEwGp0fBTXZiCj1pBB+lP0KiL3OEWBug3dkAudUDc9fxoWSp/XT2wB2r5DqgUodWh7OZPJbwuTwq+DrsMzMfcoqXhRDZnT04mBOBKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498527; c=relaxed/simple;
	bh=nibX7xYesoMzwGUrnZkSuGSDF01n3P15+CQdJzjq1HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9kTmUm9UcKAkrHfF7kzyg0//QCdm5TB/jX8mXIgqJFbpBqc+JjPJjMchtiEamLoDNgMOGrJnR8g81scd0LOQxBfQp0HcbHnPZ1V71tLd2ROs9YX/kaLUIw7facePBUhTNdUbqefZRNuen5rvclctRr9xxigfEi5PMnvkMlKaZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnF9+NQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnF9+NQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003131F00A3E;
	Fri,  4 Sep 2026 05:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498525;
	bh=dtnI66eaMvmKOcpatnIBLZZ8V7P5ZbW+X1wxEN/8C8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnF9+NQNC3XAs/zKIz0pG54PlSMEBe6+dqwXtd7mbOtDsy1JW0oGJvocGxhXYUea+
	 J3xw+i7GaRpy4xJ/qTraRXVsWtzQky5l3V2dAvkfgSuQnl6GrQ3yEY0/18g2FpV+XZ
	 8gs1F+9VZlS6Q4m8mTBn1ZVl18GPpU2tpFNI+Cko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Yi Lee <jlee@suse.com>,
	David Howells <dhowells@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Danilo Krummrich <dakr@kernel.org>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH 7.2 095/713] debugfs: Fix lockdown check for mmap_prepare
Date: Fri,  4 Sep 2026 06:51:03 +0200
Message-ID: <20260904045805.968087505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Yi Lee <jlee@suse.com>

commit f81808de37338aac8e167f99bfae647b1b835c70 upstream.

Commit 651fdda8406d ("relay: update relay to use mmap_prepare")
changed the `mmap` file operation to `mmap_prepare` for relayfs, but
the lockdown check in debugfs was not updated accordingly.

This prevents debugfs from being locked down when the kernel is in
integrity mode if a file uses `mmap_prepare` but not `mmap`.

Since the conversion to `mmap_prepare` across the kernel is not yet
complete, update the lockdown check to look for both `mmap` and
`mmap_prepare` to ensure comprehensive coverage.

Fixes: 651fdda8406d ("relay: update relay to use mmap_prepare")
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Tested-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Link: https://patch.msgid.link/20260615104750.1000-1-jlee@suse.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -273,7 +273,8 @@ static int debugfs_locked_down(struct in
 	    (!real_fops ||
 	     (!real_fops->unlocked_ioctl &&
 	      !real_fops->compat_ioctl &&
-	      !real_fops->mmap)))
+	      !real_fops->mmap &&
+	      !real_fops->mmap_prepare)))
 		return 0;
 
 	if (security_locked_down(LOCKDOWN_DEBUGFS))


