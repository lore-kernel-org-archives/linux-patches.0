Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D464814AD2B;
	Tue, 23 Jan 2024 00:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969276; cv=none; b=GjRQHPZKCWMmx5ipUwv1yoZCgRH2UiFQ/sJFGTITJQuohS+gQiWOw0YBS0BcI57GnYdngsx1650fxbEdiFTz3eOlNnfkzQqvaAsEwUJ+/pqu30zggeHTHKTNL14ua017tV4GpGpWGXRUEVmj4QHUvI8oMBDkE+A+8PiCZiu7rcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969276; c=relaxed/simple;
	bh=UQ20vdvFkcWJ+sbiRAub5X3b0o6lVww3iR7zGOPFd/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htp8ajGDPs5bzuKNKx2J9QCZJ8gqtw6XYtIgC/Hs3K36/CdVtChKgHH3e+urYYIy5FDiCSc9M91fAGTqocwDgPnXgJgyHeiOOYRDP2Kyr7nnQCOeB0caNxo55PW7tCU6q1dxaSZvzhXde7X8KKGZxtLT8K8GKmjq9+4itJk/GJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=briNbkZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="briNbkZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93347C433F1;
	Tue, 23 Jan 2024 00:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969276;
	bh=UQ20vdvFkcWJ+sbiRAub5X3b0o6lVww3iR7zGOPFd/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=briNbkZKMPHWbD7LHJLWhRoTeCuyvKTIZK4fQsSHlzl1SXyKMifTGgeTL3XzF/eV7
	 rNHUhHtSfL5WNp5sqa9IMNkGAKCmJ/4EyA9/y9UommOWHzTPRK+m/NDYuuNSjQF6KZ
	 mG+gbVCbH6J7ipZw3agk+kb+enb910ERuSYE47oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Minh Le Hoang <minh.lehoang@novoserve.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 114/641] selftests/bpf: Fix erroneous bitmask operation
Date: Mon, 22 Jan 2024 15:50:18 -0800
Message-ID: <20240122235821.609027006@linuxfoundation.org>
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

From: Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>

[ Upstream commit b6a3451e0847d5d70fb5fa2b2a80ab9f80bf2c7b ]

xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
iptables module.

Fix the bitmask operation when checking the status of an existing
conntrack entry within tcp_lookup() function. Do not AND with the bit
position number, but with the bitmask value to check whether the entry
found has the IPS_CONFIRMED flag set.

Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
Signed-off-by: Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Minh Le Hoang <minh.lehoang@novoserve.com>
Link: https://lore.kernel.org/xdp-newbies/CAAi1gX7owA+Tcxq-titC-h-KPM7Ri-6ZhTNMhrnPq5gmYYwKow@mail.gmail.com/T/#u
Link: https://lore.kernel.org/bpf/20231130120353.3084-1-jeroen.vaningenschenau@novoserve.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
index 80f620602d50..518329c666e9 100644
--- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
@@ -467,13 +467,13 @@ static __always_inline int tcp_lookup(void *ctx, struct header_pointers *hdr, bo
 		unsigned long status = ct->status;
 
 		bpf_ct_release(ct);
-		if (status & IPS_CONFIRMED_BIT)
+		if (status & IPS_CONFIRMED)
 			return XDP_PASS;
 	} else if (ct_lookup_opts.error != -ENOENT) {
 		return XDP_ABORTED;
 	}
 
-	/* error == -ENOENT || !(status & IPS_CONFIRMED_BIT) */
+	/* error == -ENOENT || !(status & IPS_CONFIRMED) */
 	return XDP_TX;
 }
 
-- 
2.43.0



