Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D3D471253;
	Tue, 21 Jul 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657511; cv=none; b=I4WTC2D7DzPt/s87DYT6/voIHUhHpAhglEf0xGs94HOdB6Pf/6z/PbTEw6SDM2g2FpgLhsi4HGnPuv7pg4e6Z2/ixhCm66+Cqnq7V4lm2ho3vHWClw6ApEMt8hOE3GhKP/q2DaVVlNYU9ce9dbKlra3l27VGbxAi4VaBjPiD+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657511; c=relaxed/simple;
	bh=DVoWV5r9mCrGyctiLTYn4DO3bMdJEI2bCEVjES5vnos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O19aAIAXvZut4EEIVM/oXuh505XoZay4fiWCETnPAT1PcN/AQsrncCWY/VVaRjtn1A3H3qWk/X6CUj0/hyOSk4lAui1I0iwcWrJXbADx3kDtKi2amzBdSOlYKMlCBhKzi5JuCaytcGZsjf2ll8DhGeoB3qLvHnZu4VTb7t4QUc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQfjuPNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQfjuPNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC4D1F000E9;
	Tue, 21 Jul 2026 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657510;
	bh=l2p3sTNK/74/EAUy8XLs8k4NRomOABYi4WRCAoWV+cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQfjuPNhooThf6nbfgb37D+3RwF0tFox/Fmob8IPi2DpJLKZ6z8YIyaVFmT94q1yC
	 0wOiN90gfhmknst//Y1rT10P7dccMNWCq2DUsT//q9X/Dc1F7HabJ4BS7nr77bT8Fq
	 QyOOODoWbZc9fgXOQY4fO4qyQQdfDpkuDQVVF4bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciek Borzecki <maciek.borzecki@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0749/1611] apparmor: fix uninitialised pointer passed to audit_log_untrustedstring()
Date: Tue, 21 Jul 2026 17:14:25 +0200
Message-ID: <20260721152532.221873457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciek Borzecki <maciek.borzecki@gmail.com>

[ Upstream commit bcd1b34c21748531a3febaf7440632b89d8deab7 ]

Commit 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
intrdouced a small bug, where path_name() may pass a potentially uninitialized
*name to aa_audit_file() if the path->dentry had been replaced with
aa_null.dentry earlier on. This can lead to page fault like one observed on
7.0.2 openSUSE Tumbleweed kernel:

[51692.242756] [  T24690] BUG: unable to handle page fault for address: 0000000f00000003
[51692.242762] [  T24690] #PF: supervisor read access in kernel mode
[51692.242763] [  T24690] #PF: error_code(0x0000) - not-present page
[51692.242765] [  T24690] PGD 0 P4D 0
[51692.242768] [  T24690] Oops: Oops: 0000 [#1] SMP NOPTI
[51692.242772] [  T24690] CPU: 3 UID: 1020 PID: 24690 Comm: snap-confine Tainted: G           O        7.0.2-1-default #1 PREEMPT(full) openSUSE Tumbleweed  ab90b4c9940707f9cafa19bdad80b2cec52dbe51
[51692.242775] [  T24690] Tainted: [O]=OOT_MODULE
[51692.242777] [  T24690] Hardware name: Framework Laptop 13 (AMD Ryzen 7040Series)/FRANMDCP05, BIOS 03.18 01/08/2026
[51692.242778] [  T24690] RIP: 0010:strlen+0x4/0x30
[51692.242783] [  T24690] Code: f7 75 ec 31 c0 e9 17 9f 00 ff 48 89 f8 e9 0f 9f 00 ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <80> 3f 00 74 18 48 89 f8 0f 1f 40 00 48 83 c0 01 80 38 00 75 f7 48
[51692.242785] [  T24690] RSP: 0018:ffffd015eb1e3608 EFLAGS: 00010282
[51692.242787] [  T24690] RAX: 0000000000000000 RBX: ffff89796198a360 RCX: 0000000000000000
[51692.242788] [  T24690] RDX: 00000000000000d1 RSI: 0000000f00000003 RDI: 0000000f00000003
[51692.242790] [  T24690] RBP: ffffffffb7ede090 R08: 00000000000005f5 R09: 0000000000000000
[51692.242791] [  T24690] R10: 0000000000000000 R11: 0000000000000000 R12: ffffd015eb1e3700
[51692.242792] [  T24690] R13: ffff8977a22bc380 R14: ffffffffb7ec5190 R15: ffff8977a0c8aa80
[51692.242794] [  T24690] FS:  0000000000000000(0000) GS:ffff897f640d8000(0000) knlGS:0000000000000000
[51692.242796] [  T24690] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[51692.242797] [  T24690] CR2: 0000000f00000003 CR3: 00000006ad15f000 CR4: 0000000000f50ef0
[51692.242799] [  T24690] PKRU: 55555554
[51692.242800] [  T24690] Call Trace:
[51692.242802] [  T24690]  <TASK>
[51692.242804] [  T24690]  audit_log_untrustedstring+0x1d/0x40
[51692.242811] [  T24690]  common_lsm_audit+0x71/0x1d0
[51692.242816] [  T24690]  aa_audit+0x5a/0x170
[51692.242819] [  T24690]  aa_audit_file+0x18a/0x1b0
[51692.242825] [  T24690]  path_name+0xd2/0x100
[51692.242829] [  T24690]  profile_path_perm.part.0+0x58/0xb0
[51692.242832] [  T24690]  aa_path_perm+0xef/0x150
[51692.242837] [  T24690]  apparmor_file_open+0x153/0x2e0
[51692.242840] [  T24690]  security_file_open+0x46/0xd0
[51692.242844] [  T24690]  do_dentry_open+0xe9/0x4d0
[51692.242848] [  T24690]  vfs_open+0x30/0x100

While here, initialise variables which are passed down to path_name().

Fixes: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 80e4ad2fca9c46..534a93520c5698 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -157,9 +157,9 @@ static int path_name(const char *op, const struct cred *subj_cred,
 	/* don't reaudit files closed during inheritance */
 	if (unlikely(path->dentry == aa_null.dentry))
 		return -EACCES;
-	else
-		error = aa_path_name(path, flags, buffer, name, &info,
-				     labels_profile(label)->disconnected);
+
+	error = aa_path_name(path, flags, buffer, name, &info,
+			     labels_profile(label)->disconnected);
 	if (error) {
 		fn_for_each_confined(label, profile,
 			aa_audit_file(subj_cred,
@@ -249,7 +249,7 @@ static int profile_path_perm(const char *op, const struct cred *subj_cred,
 			     struct path_cond *cond, int flags,
 			     struct aa_perms *perms)
 {
-	const char *name;
+	const char *name = NULL;
 	int error;
 
 	if (profile_unconfined(profile))
@@ -327,7 +327,7 @@ static int profile_path_link(const struct cred *subj_cred,
 			     struct path_cond *cond)
 {
 	struct aa_ruleset *rules = profile->label.rules[0];
-	const char *lname, *tname = NULL;
+	const char *lname = NULL, *tname = NULL;
 	struct aa_perms lperms = {}, perms;
 	const char *info = NULL;
 	u32 request = AA_MAY_LINK;
-- 
2.53.0



