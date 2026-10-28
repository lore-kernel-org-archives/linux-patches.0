Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210990;
	b=VlHc1ixUGk4szvgHbRwoenB1c4huzsO6DCzwM34AUqTe4FbY4br8zhDw6tmZDHNS9E9H
	 R0N5cQG1bGmWD6oggXXCJnqu8tUFKRpzn9pMSrjpD32utCbFDpsCkp9Y6PLWW+RBYUxHm
	 /CMVEwRuB9yP9GK8r+ut5Nr55HRyN9rvgv7TbU46V8WtzbjPum+Dl4UL1NLVOB0qumVJs
	 zBt7HEhqoga92VVa5erk9POM7fK6rAYpX3mvTC1nvuZ0axyoom1sa2/IfBaZ1i5p/40h5
	 Zj8IlNhZCQO05H3nsKMhd5zD4lvj1CzFmV5YxTpF+ZKykw226cZt9w/3uxmHI2+GL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=98avdyYfza3m1AUlKqODCnqNYUJpI3wOhzBhVZ0UHpk=;
	b=MJKC7uvHO0PX16hVMb0Zji/6uefzkn79ZIUZy0FpoaM4CvGBh+DLiwtYREbdvxh6vvKV
	 M1TnlzmqQUuwNvYntzGJWWQhjpj0oBhF3SNgN7OqmDKVcSi+OQsiig6jkj4bss6ASxw2v
	 8/H0Cb8Q/6aGajh0t1u5oHH2pz0/qm/H19bV1knFRC/j6YNCeuQxejaVr9l5nGURjNyMa
	 h0x+S5S9lhvHWS60pDyIP7g9tpUSTQCBCKrK/Oh9zJlqijrMjthTHr9kdsPD8AIAMon3l
	 R1gxI5Y0hFOwE7+krJMgxxF+qy30r288g1PgkZzS23ehmOOXrM/jdQcwWN9r+szp6yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOOUzCzO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536F2606A336;
	Wed, 28 Oct 2026 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOOUzCzO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CD31F031E9;
	Wed, 28 Oct 2026 18:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210990;
	bh=98avdyYfza3m1AUlKqODCnqNYUJpI3wOhzBhVZ0UHpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOOUzCzO81w/MIlGCg00JpeE7FQ6VwsR5VNooflACQc0Qha3G0WttOX20VGr+5VDi
	 cowo6kHdAE8cDEmTA/wXAuIjTJQBs57VWcKERCJ7Ik5VHYFFJDaoL5uME8rjk8ijEG
	 FAwM6Yo8vovMVv3qiEX95wV4ltssH/msAVHjEGN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 218/571] tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup
Date: Wed, 28 Oct 2026 17:56:05 +0100
Message-ID: <20261028170013.175452319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 03b49c991abb8d021ca6fe51cd173447236b0552 upstream.

vcc_cleanup() sets port->tty to NULL without holding port->lock, racing
with vcc_event() LDC callbacks that read port->tty under port->lock and
then use tty->port. This can cause a use-after-free when the callback
dereferences tty->port after cleanup has already destroyed and freed it.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-2-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -985,7 +985,8 @@ static void vcc_cleanup(struct tty_struc
 
 	port = vcc_get(tty->index, true);
 	if (port) {
-		port->tty = NULL;
+		scoped_guard(spinlock_irqsave, &port->lock)
+			port->tty = NULL;
 
 		if (port->removed) {
 			vcc_table_remove(tty->index);


