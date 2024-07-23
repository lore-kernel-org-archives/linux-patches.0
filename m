Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4490B1586CB;
	Tue, 23 Jul 2024 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759220; cv=none; b=Xrypd6uu/NzNuAGjejmZDBFm4nwrs6+ZAsOX3CRRuS+6CXBvgiw8tHMEwCiAAgC0xy+gZ4uMBtGmpO91mjSWO+wMWygu9V2NCbB+f0AhwFzaSF0S8s1kAsoQAmZED8o3Ts0yPwtgEr/a+DXdaYNO1QX7+0YZsWsRlhgrGlvsfZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759220; c=relaxed/simple;
	bh=WXJQ59vAu5JY7ZAewRDA3y4ZoWwio9SUeudWC+amk9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5xZNLPjT9jUz2s6PaKJclXItthEee4yQIlHs4u0bRN7xVdWsp6EBB0sIqCMBrskgjSTf0XGlFkQJO/CVHkHv92reCpaiPN0ApJoMtmj0QIqbyUL3MF4PfXeKk2BeWz+ZTVmfg3ZH5YGWFITLijxhdBiDV8fmLmnTxAArnoMV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY95dyvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY95dyvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A295AC4AF09;
	Tue, 23 Jul 2024 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759220;
	bh=WXJQ59vAu5JY7ZAewRDA3y4ZoWwio9SUeudWC+amk9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eY95dyvMQ17f5OZUuwRFjA+5j/ahkWXarOhPjHPmL3TosafnI9XJqy33AsKBbSb+r
	 8aEcI4HSTQ+dGBDnliJnAD/aGm2UdUBlF7Q66Uee7Vpr3mTTFDsRRKnbJYoC+ELew+
	 BQD69HD7vAm1F5hMccNCY1HZ9YkPN4ReoKGuXq8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/105] fs/file: fix the check in find_next_fd()
Date: Tue, 23 Jul 2024 20:23:20 +0200
Message-ID: <20240723180404.906145919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit ed8c7fbdfe117abbef81f65428ba263118ef298a ]

The maximum possible return value of find_next_zero_bit(fdt->full_fds_bits,
maxbit, bitbit) is maxbit. This return value, multiplied by BITS_PER_LONG,
gives the value of bitbit, which can never be greater than maxfd, it can
only be equal to maxfd at most, so the following check 'if (bitbit > maxfd)'
will never be true.

Moreover, when bitbit equals maxfd, it indicates that there are no unused
fds, and the function can directly return.

Fix this check.

Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://lore.kernel.org/r/20240529160656.209352-1-yuntao.wang@linux.dev
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index dbca26ef7a01a..69386c2e37c50 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -481,12 +481,12 @@ struct files_struct init_files = {
 
 static unsigned int find_next_fd(struct fdtable *fdt, unsigned int start)
 {
-	unsigned int maxfd = fdt->max_fds;
+	unsigned int maxfd = fdt->max_fds; /* always multiple of BITS_PER_LONG */
 	unsigned int maxbit = maxfd / BITS_PER_LONG;
 	unsigned int bitbit = start / BITS_PER_LONG;
 
 	bitbit = find_next_zero_bit(fdt->full_fds_bits, maxbit, bitbit) * BITS_PER_LONG;
-	if (bitbit > maxfd)
+	if (bitbit >= maxfd)
 		return maxfd;
 	if (bitbit > start)
 		start = bitbit;
-- 
2.43.0



