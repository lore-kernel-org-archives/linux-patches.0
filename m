Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036951;
	b=1GGwkvsVPtVt5FuI9FSes7Vs8s0Q5dEbCl3aHFczDLcAZ5qo99dFAbhYMeIlCWJmZKth
	 Yex2nbwQSC6N3/llkgbOuOUoxNpC38s9oeAEyIItf7+rhYqyAIMb3MLLt4HEeRVLMYAqa
	 a1ruK/ytldttBlSg0uBDztecKFhupr3uoqGnkUvt3AJLG0X9InJBJ40gh4opCDrrGqPmL
	 cUrfcnhiq8+0zsto3tPU1V1tft02s6vXbQK+Bryk4ZwEpLLoFOz8eI6wNbLi3VC3Z9eke
	 RNZTixk7SBySKZ6K7Aq9wc1AZFzaf/4+AJ4Kuadx/16YKnH47rgmA+B3K4+8keoDjlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pePpwxyugQOe+VNk/+3JzOH+7I91z9CBH55mtOWE+L4=;
	b=ssDPiNy8iuqCW4YRa0ygzni52grs8doy73FZD7R47o6cDLkUfqo2KzTtT1LcX6Fv9QMo
	 KlZk+V92zTzqzTgIXWcDWwSrJ1bZ4Hgp2NNpmCAY9MdupjcifFhHuZtg9UjElwLRJhRXf
	 tXNeJL+jEuj+S0gA8YMRnS65sNkhKCzGu1tq4b5IwWB4Hrjk6RkffETE69TviejwzXJXB
	 arBGbcsyu8/ZN3erz+xi/Vja2qA1CpppeqnYLVsyOUGRanNVp0/qyYdJtNfPuQAWSr8QG
	 wAhZFZsMyUZd6izwbZuW/elVxiqMH/87oDMSkO9Y/MkA3Wu+vfOciJlkboS5lVKgZ7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Doj4EuOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B52606A31C;
	Wed, 18 Nov 2026 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Doj4EuOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C3E1F000C4;
	Wed, 18 Nov 2026 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036951;
	bh=pePpwxyugQOe+VNk/+3JzOH+7I91z9CBH55mtOWE+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Doj4EuOqMEm1ONkJgx7ViwS/sTi43KGpE+WzbLaCTvDCVedhJaDAQQn2JDorJlk6L
	 gR9h6qj0WNTrwTo/eF62D1b0DOWJRAkhNi6BJFOZSRBYckowraVrCEkgJmS55lMqzR
	 BUlYG8oH04JYk1XjWYsigX3ka5P5SzSc5gluQqRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1239/3318] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Wed, 18 Nov 2026 15:31:01 +0100
Message-ID: <20261118150357.361099183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 569a9bb1e5615c2b88b8d76f03a4ab82e65a673e ]

decode_choose_arg() assumes that its destination is zero-initialized.
Although decode_choose_args() zeroes the argument array, it does not reject
a repeated bucket_index and can decode into an already populated entry.

Repeating a bucket with weight_set_size=0 preserves its existing weight_set
pointer but clears the count. Placement then reads weight_set[-1].weights
and dereferences the resulting pointer.

A malformed monitor OSDMap triggers this during RBD placement:

  BUG: KASAN: slab-out-of-bounds in crush_bucket_choose+0xdd1/0xf90
  Read of size 8 at addr ffff88800290df70 by task init/75

Reject populated arguments before decoding another entry, so the error
path can free their original allocations.

Cc: stable@vger.kernel.org
Fixes: c7ed1a4bf4b4 ("crush: assume weight_set != null imples weight_set_size > 0")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index e812b30778d57..803514a1bc7ce 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -387,6 +387,8 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 				goto e_inval;
 
 			arg = &arg_map->args[bucket_index];
+			if (arg->ids || arg->weight_set)
+				goto e_inval;
 			ret = decode_choose_arg(p, end, arg);
 			if (ret)
 				goto fail;
-- 
2.53.0



