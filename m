Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063770;
	b=nHYcsQokqcb9XCRhK1FPY57DMHa328rLTsmM3KSBqa+3BHCPwZnZm2yc14cHGOJ68sqb
	 s54/WDrVqfBZnRktXiDiEbJh++EIYINQV+ZLXJcFZk6r6+Jr7DE+zrsHo6IxJQembfxyu
	 dDzDzUguzw8WyVrkEXrXmpMeOU90bXt6qsGpWhjKOe/tfbPVO6mxJ1qOtWXbfrHNSU/CA
	 EjpbhndcYvwfcAo2vhPphXByQHarJphez4cjXqva1lHBUksCalJuo6igD7nqV++43bTiR
	 hjMbtqiUXwqEkvQ6kBSooKlcEruP7vy+ncnnN0lw/I3+ZggV9jmSb+hIXy/Y0rwySaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29dvBlNx4H/lerupypcKdG3quCT9uKKusC71fR/FO5A=;
	b=B1kB5o9Og1jADakxJO29FUV6hW201DufsRpJJo7gym2jRcPwfOMC8HST6ojeb6OQeUm+
	 jFNCWKFAOJgA7aQiBFjmxnc3PegLubSJ6BVY1QfTXSLNG34BQ+HUNRIynYaM+N4iIElxy
	 9lNUl3YCOeDZwV2FzHhyxPG9fKVXD0OnPVpWKDAehnNrhLdEqMfINPdlEq8EJVSlbvJeG
	 HpoeoE6gRJ+GY3RQ2VCzfQN5ymuYUYI5128VntzLmSTMjZesZ8XjfG745ikVO2hAUuyKN
	 nNHsHJgPA5ut+GCyojCrSUA2FblL/HgDUDRHE3eQi4JrThn3xeF+iXidAACk547kOvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdBDZYZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E4F60A261D;
	Sat,  7 Nov 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdBDZYZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256121F0089F;
	Sat,  7 Nov 2026 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063770;
	bh=29dvBlNx4H/lerupypcKdG3quCT9uKKusC71fR/FO5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdBDZYZEUJDN2ymQ6BLNWOaZBfN2M3odcjtgjXtmbJsPlIGcRkS0yO0wFyySh5x+N
	 ewUks5PM4hm6fj7UI0yDf9SEWotcZZuelYuwNdDXGDmt4U3EcMOw8NcAqD0fYEnpzD
	 WGScxnBvAuZ21hbh1ad76QJVrZmtiJ/ZWjfzfz9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 862/869] splice: avoid stale f_pos writeback on error
Date: Sat,  7 Nov 2026 08:59:04 -0500
Message-ID: <20261107134922.046322380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 79b496ebe382866e3a05090b7dc9ae95e85e65b2 ]

do_splice() snapshots an implicit file position before calling the splice
helper. Since splice does not take f_pos_lock, another operation on the
same open file description can update f_pos while the helper is blocked.
If the helper then fails, the unconditional writeback restores the stale
snapshot.

For a directory without ->splice_read, a file-to-pipe splice fails with
-EINVAL. A concurrent directory mutation and getdents() call can advance
f_pos and refresh the filesystem's revalidation cookie before that failure
restores only the old position. The next ext2 readdir can then trust an
offset inside a directory entry and copy data from the adjacent page to
userspace.

Only update an implicit file position when splice returns a non-negative
result, matching read and write. Keep explicit offset updates unchanged.

Fixes: 7995bd287134 ("splice: don't pass the address of ->f_pos to methods")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261018051708.2422394-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index f5094b6d00a09..8ac45441e2193 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1351,10 +1351,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
-		if (!off_out)
-			out->f_pos = offset;
-		else
+		if (off_out)
 			*off_out = offset;
+		else if (ret >= 0)
+			out->f_pos = offset;
 	} else if (opipe) {
 		if (off_out)
 			return -ESPIPE;
@@ -1375,10 +1375,10 @@ ssize_t do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
 
-		if (!off_in)
-			in->f_pos = offset;
-		else
+		if (off_in)
 			*off_in = offset;
+		else if (ret >= 0)
+			in->f_pos = offset;
 	} else {
 		ret = -EINVAL;
 	}
-- 
2.53.0



