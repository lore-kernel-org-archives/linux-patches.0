Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46640371449;
	Sat, 28 Feb 2026 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301460; cv=none; b=MkVPFPwtHrQZ9snt4CpRpQy+EJzx01XBdHj2hB5HXRx4SAwKfroMOL7ApugtGMitWggwwcF5zZjO62MB9UYy2jee7DtSLRpYOmIHrZ+Y4KljsOegGptMKHg5rfCjhy8ArGsaWwT6O4tPCTIbHuq8cs6T2ARs24cC8XxJArRec1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301460; c=relaxed/simple;
	bh=rjXJLCBeCGvltKD9acB4is1H3g18LgE0Z3h2wPRvfwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLt9NvPGIE946GYj7uzfUaJ2dCp77jTohO+oPKx4ApwY8gwPkWmOkuil0ej2/5yodhGU7y89NShwJixBjVijPyHb68Zx5kScg4BF7Cr1kNRxE/FErxxHmyF45KL7T/fBDRx8/hRdui4Z7i0MwooLrWq90HdosaKuZt3mqsU9sdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtFd0CUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtFd0CUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0DC19425;
	Sat, 28 Feb 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301460;
	bh=rjXJLCBeCGvltKD9acB4is1H3g18LgE0Z3h2wPRvfwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtFd0CUfQkS2JAaztcvF6MFPwZ4x+V/rFrcffh7vAQtRdsISmpnsWQ3bzz7ddePu8
	 XZ+lKVN5F2VdO82pKClOUFJnzjRbRJjnrM3BEyFBPA+lHvmJnx0bJgfr/ONPpJuedQ
	 7B+6uszp1RyTpjwG0G/BFbCJ7RBWHGMHHIOPKqIJd7TTVcomJe9yw78AEWQmnah1yc
	 mnuXgYZsR09gbkhl4uSbsH2EA99FQYwsvr12DpgHsuS19lmW45xj6AYOhW+Fnxsi5V
	 heJUTSgdxGuOrj5UKgFL8hXiSjZJT6ENuFRiJnquQKeg5X/IpcTb38mKsX6eu8R7u0
	 6+wnCWEAqcjeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vasily Gorbik <gor@linux.ibm.com>,
	Baoquan He <bhe@redhat.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/752] crash_dump: fix dm_crypt keys locking and ref leak
Date: Sat, 28 Feb 2026 12:45:56 -0500
Message-ID: <20260228174750.1542406-645-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 96a54b8ffc8c4567c32fe0b6996669f1132b026d ]

crash_load_dm_crypt_keys() reads dm-crypt volume keys from the user
keyring.  It uses user_key_payload_locked() without holding key->sem,
which makes lockdep complain when kexec_file_load() assembles the crash
image:

  =============================
  WARNING: suspicious RCU usage
  -----------------------------
  ./include/keys/user-type.h:53 suspicious rcu_dereference_protected() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  no locks held by kexec/4875.

  stack backtrace:
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   lockdep_rcu_suspicious.cold+0x4e/0x96
   crash_load_dm_crypt_keys+0x314/0x390
   bzImage64_load+0x116/0x9a0
   ? __lock_acquire+0x464/0x1ba0
   __do_sys_kexec_file_load+0x26a/0x4f0
   do_syscall_64+0xbd/0x430
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

In addition, the key returned by request_key() is never key_put()'d,
leaking a key reference on each load attempt.

Take key->sem while copying the payload and drop the key reference
afterwards.

Link: https://lkml.kernel.org/r/patch.git-2d4d76083a5c.your-ad-here.call-01769426386-ext-2560@work.hours
Fixes: 479e58549b0f ("crash_dump: store dm crypt keys in kdump reserved memory")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/crash_dump_dm_crypt.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
index 401423ba477da..abb307a23de33 100644
--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -143,6 +143,7 @@ static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
 {
 	const struct user_key_payload *ukp;
 	struct key *key;
+	int ret = 0;
 
 	kexec_dprintk("Requesting logon key %s", dm_key->key_desc);
 	key = request_key(&key_type_logon, dm_key->key_desc, NULL);
@@ -152,20 +153,28 @@ static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
 		return PTR_ERR(key);
 	}
 
+	down_read(&key->sem);
 	ukp = user_key_payload_locked(key);
-	if (!ukp)
-		return -EKEYREVOKED;
+	if (!ukp) {
+		ret = -EKEYREVOKED;
+		goto out;
+	}
 
 	if (ukp->datalen > KEY_SIZE_MAX) {
 		pr_err("Key size %u exceeds maximum (%u)\n", ukp->datalen, KEY_SIZE_MAX);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	memcpy(dm_key->data, ukp->data, ukp->datalen);
 	dm_key->key_size = ukp->datalen;
 	kexec_dprintk("Get dm crypt key (size=%u) %s: %8ph\n", dm_key->key_size,
 		      dm_key->key_desc, dm_key->data);
-	return 0;
+
+out:
+	up_read(&key->sem);
+	key_put(key);
+	return ret;
 }
 
 struct config_key {
-- 
2.51.0

