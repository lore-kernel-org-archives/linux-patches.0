Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223AC537F7;
	Tue, 23 Jan 2024 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970092; cv=none; b=QWAaI38AKl2a8/bE+xhG3xvm9QX240tmh2GCHcVAZbC9iaZOgqD8rbbGrSWEMQu1mhgNDw0IEDRc/edTnK2YpgrcxZEOwgEHGRTQKXOD6jt6VJfym+NWrQT6WkBvfPgEholpCI0yxCOOT1r/M/gMJN1WYGklm/haGyVoa38jqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970092; c=relaxed/simple;
	bh=1ewkJmff3McK7TC3sricY+nJPoufZ7ZSSvp6dUZNvpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGjIJASpChywx2WSU4fWW7OtFL4aeZwO3mH/JA1rlWn7bGJpXupKPyGcb/hk+j1ZWtvkLOPgep9IYKd3ZnXes0xwAyvUS2usy3IymlRmP8wMtXZ6ftOGdUiWoKNSZCrUJLgmxwMbT+RUWwt+CgxDDKHqKvQmpizqoQGzw8M1LPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQooHRGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQooHRGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E09C433C7;
	Tue, 23 Jan 2024 00:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970092;
	bh=1ewkJmff3McK7TC3sricY+nJPoufZ7ZSSvp6dUZNvpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQooHRGDLLIEpOS3zbpMporMGB5Soh70qb1rPpzrJAeqmeTDJWwv4cbM/DMrq1gL8
	 qsv2eUH8nEeX/5LQ9C6yfM3GQunjg/ROGwfECGDHaBFi3SDsapWjYK1A/VZH69zyux
	 We4Db83Wj/C/7leOUyV6/bJfj6krxF7T/v1IrERQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 561/641] apparmor: avoid crash when parsed profile name is empty
Date: Mon, 22 Jan 2024 15:57:45 -0800
Message-ID: <20240122235835.707692209@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 55a8210c9e7d21ff2644809699765796d4bfb200 ]

When processing a packed profile in unpack_profile() described like

 "profile :ns::samba-dcerpcd /usr/lib*/samba/{,samba/}samba-dcerpcd {...}"

a string ":samba-dcerpcd" is unpacked as a fully-qualified name and then
passed to aa_splitn_fqname().

aa_splitn_fqname() treats ":samba-dcerpcd" as only containing a namespace.
Thus it returns NULL for tmpname, meanwhile tmpns is non-NULL. Later
aa_alloc_profile() crashes as the new profile name is NULL now.

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 6 PID: 1657 Comm: apparmor_parser Not tainted 6.7.0-rc2-dirty #16
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
RIP: 0010:strlen+0x1e/0xa0
Call Trace:
 <TASK>
 ? strlen+0x1e/0xa0
 aa_policy_init+0x1bb/0x230
 aa_alloc_profile+0xb1/0x480
 unpack_profile+0x3bc/0x4960
 aa_unpack+0x309/0x15e0
 aa_replace_profiles+0x213/0x33c0
 policy_update+0x261/0x370
 profile_replace+0x20e/0x2a0
 vfs_write+0x2af/0xe00
 ksys_write+0x126/0x250
 do_syscall_64+0x46/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
 </TASK>
---[ end trace 0000000000000000 ]---
RIP: 0010:strlen+0x1e/0xa0

It seems such behaviour of aa_splitn_fqname() is expected and checked in
other places where it is called (e.g. aa_remove_profiles). Well, there
is an explicit comment "a ns name without a following profile is allowed"
inside.

AFAICS, nothing can prevent unpacked "name" to be in form like
":samba-dcerpcd" - it is passed from userspace.

Deny the whole profile set replacement in such case and inform user with
EPROTO and an explaining message.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 04dc715e24d0 ("apparmor: audit policy ns specified in policy load")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 9575da5fd4cb..dbf7d96257ad 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -832,6 +832,10 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 
 	tmpname = aa_splitn_fqname(name, strlen(name), &tmpns, &ns_len);
 	if (tmpns) {
+		if (!tmpname) {
+			info = "empty profile name";
+			goto fail;
+		}
 		*ns_name = kstrndup(tmpns, ns_len, GFP_KERNEL);
 		if (!*ns_name) {
 			info = "out of memory";
-- 
2.43.0



