Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619431;
	b=NEeNWCxUbdn0/53CUFirBdtD4xmwP2Owp8UCBah7wFcPRkKRVEylU0NhrP7JxnFW6zUa
	 gXsT9PQcjHyY6d7lm7T7n2CjlbvyzoD124nz+pU2VJpHWAxqHyOQSXL6B3plfgOXcpcwF
	 076tPaAn4wA/maBeOmZ8UY0e/r0YOB2VtqnCZ9z2nIzh/dNCwN+kfokwi9pTc90nFTFpu
	 Ac3EQVMGnpX+90rpaV9C6E3Pm6snqW1D+KqOsQpI4dmgsuRoLtTi0j4rkmQlk47BGuE5B
	 n9IqAvxE/vcJS5d+BzMCk732E4ezrR5kXt4qkANlB2+3w3bOezse4lxoF5IIvYx2qOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SSWsP9LmqwqJOsN/l9wV/V5rqZ/3x9/XiANeYh3y5j4=;
	b=KpcGRRkan+D/yKnCGV1xgLPjzlSBsPBpICKI8NZbTs8lQNOpaeJoY214kzcrNZxVKkrz
	 4bk2WEDBFlmk0Tf2C1tREi+B7Q8WjPS6GgXUlxmV5HAf4imrc8QBDRKBpo/Yg8EvgQ+bO
	 2aBhqHHMlednBriAM4aJpA/etUId4DrBQfSPa/gRDr1yTeRQxNWu/LaGywuIA4VaxP0W+
	 8atmTD8g0IIw3ivuwZH8x+r24f5Jnp5CN9ZjrQTHRseFxnbX/zt2uoxP2rbSJo3wsTjwH
	 iqzw3l+uQCeRbj3pEU3L8U8OWnWf7dM9TxODdWsMZl8tHDlnXP+BUJA/QGbdWajSwKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM9XxgN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F782606A338;
	Wed, 25 Nov 2026 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yM9XxgN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1E21F000C6;
	Wed, 25 Nov 2026 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619431;
	bh=SSWsP9LmqwqJOsN/l9wV/V5rqZ/3x9/XiANeYh3y5j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yM9XxgN+cr8xkwzRb5yY3EqsHInw7S9bKyuhHFht60hd712AZ0yNdMXVsRwMTdvdb
	 zOWgxGFUDSrL11u6MLfHPgaMvpfpd9RoiPUavBs+NgzxCPOFRWejiXs/VZ9dOdZRSN
	 4Z8GADxHSALH/EHxxlggqpHYDmwFDV1BgUaiQRpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0592/1005] fs: fix the SEEK_CUR f_lock condition
Date: Wed, 25 Nov 2026 15:32:10 +0100
Message-ID: <20261125143835.611629177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 1448959fe3d013ffdb8302d17e4a8fdad2d2da95 upstream.

Commit da06e3c51794 ("fs: don't needlessly acquire f_lock") wanted to
skip f_lock for SEEK_CUR on files that already serialize f_pos through
f_pos_lock, i.e. FMODE_ATOMIC_POS files and directories, and keep it
for everything else. The condition it added does the opposite:
file_seek_cur_needs_f_lock() returns false exactly for the files that
never take f_pos_lock and true for the ones that do.

So since v6.15 a SEEK_CUR on a shared block device or on a character
device that uses fixed_size_llseek() updates f_pos without any lock and
two concurrent calls can lose an update, while regular files and
directories pay for a spinlock they don't need.

Invert the condition.

Fixes: da06e3c51794 ("fs: don't needlessly acquire f_lock")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261106-work-file-seek_f_lock-v1-1-5b9a6c2928d4@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1237,14 +1237,18 @@ static inline bool file_needs_f_pos_lock
 
 bool file_seek_cur_needs_f_lock(struct file *file)
 {
-	if (!(file->f_mode & FMODE_ATOMIC_POS) && !file->f_op->iterate_shared)
-		return false;
-
 	/*
+	 * Files that go through f_pos_lock when they are shared, i.e.
+	 * FMODE_ATOMIC_POS files and directories, don't need f_lock for a
+	 * SEEK_CUR. Everything else does, since nothing else serializes
+	 * the f_pos update.
+	 *
 	 * Note that we are not guaranteed to be called after fdget_pos() on
 	 * this file obj, in which case the caller is expected to provide the
 	 * appropriate locking.
 	 */
+	if ((file->f_mode & FMODE_ATOMIC_POS) || file->f_op->iterate_shared)
+		return false;
 
 	return true;
 }


