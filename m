Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622651;
	b=uTp/fzDtOHMLIfOKNrMSX70R1UAULhLwWIuOD4FaCy/iclsZKoOzgUig1SgLR3JPDpk4
	 xuVG9PSVc0LJKhZgl5ToDTbNX3CWVjhRYdW5XsqU+GV3xtS/KOWxCqpHerdUi5ixnC80V
	 4M90gLr5xeNN6knCann/+CLsXUFunVPA0muYMXPFkEbLZXNURHaye7hlrufbAjWfHqoBt
	 wlMii5HLiEf5540aS4Q6zYSm6Hf1Cxty5yZ/JhHJjcsGXEfUj3zJ/gXUAuqK4bHqHgSdI
	 YDQPBn3IqVnjuPNMThFAG7J8bFLeTUSiJ7zu8VApWvhXBSQkdzMaxOBV7Etg88b6/3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wjR3/W47WIrmF90ptQeAeVTLEWOEKTzbImbjzAUHwcM=;
	b=csTYggZXVRTx49HSgmRG5+HnwKx/vE9PbNFYp93ZDIJpQmkiHozxO4Is5C90CdxthanG
	 0jVPAING6XnXOMRqK/IYvaOwYoLEitVuaxoZG3/CoT0QGesxA5NRBgrEC3u6f8Vsa7rvp
	 kVGVquxsIo9mFvu7aCjeEvW336mlfM8dHFpBN2tLN47IJVndMYrsuZb+7vf4dYLfZn/NA
	 z21yiuwukFS+bSyq/TqLmm9DuXr4rIT8/yAxyt3sag/5bnp5SZt+2Im2toPpcpCWSw7Hy
	 gB+iLvlAeYdL5hFV1ZaCWjBleFSqEZyhfz3FToVLjOjeqKxxElnQfYqaiTQ+krcTE/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vX62a3/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2714606A31E;
	Wed, 25 Nov 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vX62a3/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089711F000D1;
	Wed, 25 Nov 2026 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622651;
	bh=wjR3/W47WIrmF90ptQeAeVTLEWOEKTzbImbjzAUHwcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vX62a3/d/dYbZPRNRvkOMUFGTpwU4d2EfCBRtuZdznx974ikkk6nQDyEWIuAC/6Gm
	 QuiMJZeIwa2yq8yO9a7FS5C1Tp1A7RPK5hQ3rvDGKNblXBHDJK3U9d7a9FodIV2rha
	 2ijX5SngWXo12bOO7Tlnp1Bz0TYlkPtMp5UEWOTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 606/990] bpf: Free what map_free() unlinks for sleepable readers
Date: Wed, 25 Nov 2026 15:32:53 +0100
Message-ID: <20261125143836.287979114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5bdd61e98da5468140aff5b5abc0e8544deaf2ee ]

bpf_local_storage_map_free() takes the elements of the map off the lists
of their owners, which are alive, and frees them, and the storage of an
owner with its last element, behind a plain RCU grace period.  Nobody uses
the map any more, but the other maps of these owners are in use.  A
sleepable program calls the get and delete helpers under
rcu_read_lock_trace() only.  While it walks the list of an owner for its
own map, or is about to lock the storage, the element it stands on, or the
storage, can be freed under it.

Whatever else takes an element off the list of a live owner frees it
behind an RCU Tasks Trace grace period, which implies a plain one.  Do so
in bpf_local_storage_map_free() as well.  It waits for these callbacks
before it frees the map.

This does not help a sleepable program that hands an owner to the helpers
which nobody holds, and which may be gone by then.

Fixes: dcf456c9a095 ("bpf: Fix usage of trace RCU in local storage.")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-31-alexei.starovoitov@gmail.com
[ sashal: Replaced the upstream change in the missing bpf_selem_unlink_nofail() with flipping bpf_selem_unlink(selem, true) to false in bpf_local_storage_map_free(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index b931fbceb54da..9fb26ae066f54 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -890,7 +890,7 @@ void bpf_local_storage_map_free(struct bpf_map *map,
 				struct bpf_local_storage_elem, map_node))) {
 			if (busy_counter)
 				this_cpu_inc(*busy_counter);
-			bpf_selem_unlink(selem, true);
+			bpf_selem_unlink(selem, false);
 			if (busy_counter)
 				this_cpu_dec(*busy_counter);
 			cond_resched_rcu();
-- 
2.53.0



