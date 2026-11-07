Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062292;
	b=CaajP5Qn/5NAKYMAdrQ8FaZPz2Lp44fySfzSJ3JjZMVO6b4M9SKGamJCOz5Q6+2sKeYe
	 +6WrvAn8PQNshEEXaCmA3GEwMiGA505D8Fq4FS4Xv769K47+izXwr6mN9rWgDYXUDbcTj
	 8T1iRdUfLUZ/I5jdI3tOKjbC1R+V2ooZ6/VeiqDz9UI0ezyEkKbfqlC3D+Uwqm6hYWQJk
	 Z44V3NNmVseSlgvnw5ddwkyXE8lwumRc/6kSlXQ5deX3Eoj5fW2bzkk9SLz4tAsqDEGOd
	 BCGJ5NuXkbdK9NiO2LReHjrBTTlUbleMG5cVM8kH6cvLk4uTDA7qLx30oT2Bpq36DfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGFL0AFJwRE3oOp/yCAjTrEHJiwTXDlBP3zzG4Lzaqs=;
	b=RvskAs8uOfXCzaNZp7JbVtdCEYEpD5rNpJ1Q4fJNpVCkqY6LG+4Ivo0XqzEmpS2bFJ/H
	 PlGZXGpvyEtczrUygdblV38VM2sKAUSJ+73M/txKiB9Q8+HSroiCqm+s+ydN/rMf+wk6L
	 zTWl0iEzjI90IWYuZ96OVT4x075IildQ0crOKbZFLw3s5FJLIAmDdSBD9TVrnK6fIUjbR
	 6HhNScASIG0cm9ryA1WK07P36CWL8RZfcZimTRtOrFw/7g/JmAf8uQOLluNzA4hmq8S75
	 ySomYSaWBSmaf8cnsgZo4nqxgaiEPQmXvjwseCoE3i4OnEmKQxmuq9f3gzFMPlEVFTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGVjNqmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E96606D816;
	Sat,  7 Nov 2026 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGVjNqmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505991F008A1;
	Sat,  7 Nov 2026 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062292;
	bh=oGFL0AFJwRE3oOp/yCAjTrEHJiwTXDlBP3zzG4Lzaqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGVjNqmTVyUECPkIisCglE9XlnrvL78mAO9LLoVN96klvr6VBIhAhwW0O0Vy/9EgP
	 brGkpHwysJCJQ1TFP8PN4q3kQvLHrek34nZAPGTpJ7gO9isXUaS5buP3dC356N1D5p
	 irAyNM0POUD+/um1DerDj7Y5MPAp6PLl28JfNuAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1229/1536] dm-snapshot: fix crash if dm_io_client_create fails
Date: Sat,  7 Nov 2026 08:54:05 -0500
Message-ID: <20261107135032.279355802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 568d10842b1f4..1eefa19d02940 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -325,8 +325,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



