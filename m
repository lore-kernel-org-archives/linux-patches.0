Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53261EB3D;
	Tue,  8 Apr 2025 12:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116755; cv=none; b=O22LQ3f5k6UwgHAb3mmkk+XxRptHpJjihKt6UytFBBAviKBHt1s5Cw0mIdS6s3fwLzSA3ttut4OpiRuzcydCNT1eTNegnvSYxGBYIvSCNLjze4DTnkOA6ojoU0rhGb6TsB9vxLCnB5BCGpaADDZGywXfxPYrREAv9STQ1+Gpa2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116755; c=relaxed/simple;
	bh=R7LB4mjrh0+MbCnWNMZZpl5Qpj4aebh1wUVPvQmBSRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ6Mpeh5K4zQq2xBEN7QYdtLjEACLbZ21HS32jzEAKxzIhHcUSTqzfSAYAzKePz8Q/thF/cObsXpZtaNtAgpi8QMlqAj6TEkXmJ3JN9SaEEQ1S/0lE7KGkPTwH1Go765/2z9LcUaaQQjBCGJdRVZE3rlFDvCLF76RGxd3QeW+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsEdPRHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsEdPRHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3495DC4CEE5;
	Tue,  8 Apr 2025 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116755;
	bh=R7LB4mjrh0+MbCnWNMZZpl5Qpj4aebh1wUVPvQmBSRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsEdPRHCupqV8+FeSfSvAfV2hJMAdB/dc5IB2CWtogR+6wjyT3fICtRGCmJrC/bAP
	 L0m+VAbExJP+fb6iRMrTlzTBysEAFekELSlF6kOD9RP2hVx1IgM6wEDwuuli71RL4N
	 aszTwuO3u2Tn0ZMgsCO3tXXseeEMxYnRoTJTUSaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/423] tty: n_tty: use uint for space returned by tty_write_room()
Date: Tue,  8 Apr 2025 12:49:06 +0200
Message-ID: <20250408104850.854426860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit d97aa066678bd1e2951ee93db9690835dfe57ab6 ]

tty_write_room() returns an "unsigned int". So in case some insane
driver (like my tty test driver) returns (legitimate) UINT_MAX from its
tty_operations::write_room(), n_tty is confused on several places.

For example, in process_output_block(), the result of tty_write_room()
is stored into (signed) "int". So this UINT_MAX suddenly becomes -1. And
that is extended to ssize_t and returned from process_output_block().
This causes a write() to such a node to receive -EPERM (which is -1).

Fix that by using proper "unsigned int" and proper "== 0" test. And
return 0 constant directly in that "if", so that it is immediately clear
what is returned ("space" equals to 0 at that point).

Similarly for process_output() and __process_echoes().

Note this does not fix any in-tree driver as of now.

If you want "Fixes: something", it would be commit 03b3b1a2405c ("tty:
make tty_operations::write_room return uint"). I intentionally do not
mark this patch by a real tag below.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20250317070046.24386-6-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_tty.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 5e9ca4376d686..94fa981081fdb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -486,7 +486,8 @@ static int do_output_char(u8 c, struct tty_struct *tty, int space)
 static int process_output(u8 c, struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int	space, retval;
+	unsigned int space;
+	int retval;
 
 	mutex_lock(&ldata->output_lock);
 
@@ -522,16 +523,16 @@ static ssize_t process_output_block(struct tty_struct *tty,
 				    const u8 *buf, unsigned int nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int	space;
-	int	i;
+	unsigned int space;
+	int i;
 	const u8 *cp;
 
 	mutex_lock(&ldata->output_lock);
 
 	space = tty_write_room(tty);
-	if (space <= 0) {
+	if (space == 0) {
 		mutex_unlock(&ldata->output_lock);
-		return space;
+		return 0;
 	}
 	if (nr > space)
 		nr = space;
@@ -696,7 +697,7 @@ static int n_tty_process_echo_ops(struct tty_struct *tty, size_t *tail,
 static size_t __process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int	space, old_space;
+	unsigned int space, old_space;
 	size_t tail;
 	u8 c;
 
-- 
2.39.5



