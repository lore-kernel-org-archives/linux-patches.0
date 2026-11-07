Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062587;
	b=QJLTwnOcMQJlhzLkLPguOXZ2S0SSxHhKnmEMgoTbqjQYHtbtQNMco13co6tWkDtfLfZ4
	 DKl+Mzrh4BsYwUjCs3jdFgy6aDniwyVTX/hm75phapTY43PX7EruPgs3e+WrKOYk1570u
	 nzBlLiX2hBpkFmDNCVGncQOraYMpMvJ+NiVNqak+ijJyGXvzcgID1WJYbltwKMYRgY5sS
	 Wn5JLANuFqqWmBZC4Z07OmOY9szNDA/sCbMBzhVbb4tCUY19CSA5pmbkV+fPIdBk+CGkL
	 Rh03tsWKF/3Yberhou5ephCKxG/iZMzCtMTwKCiw0F7xqG6avZimh8B1lL+6hXLstvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k6UHpei5WaCkoSNSr+aLeRvcCFtFDaolHfj3fBlEnzo=;
	b=auQ66XfUdc7q6HX5Fq0gycj+tlgDAuhBQ7k8UrVyJDbCrpDchMP0FZkz/GzIZLodBgqE
	 zNxEdU+rm0hJoJ/ptLd+qhup07Fmb9sznW/otvihYlsbRezn3XddQqIWDLFP8KF+rZPlx
	 Rt8AILsSAzzJ1WwRd/d4nJHGTbK5w21U5QVYUykROLCAm2vPJ5ImVbdDqT5WOSJprkfoC
	 AwMnxc5yjTJwqk5k2BvLK3y/2dZw7ged10T4iL48C/C6k6IeQWvOhVfUCgvuoIDY8MXhs
	 +APsEO3IrWHWKbAyKyzt5CB7FZcrO+XQOmqY27C5xaSCZPSEf348Xthgk8pu0LGiWuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQykvE30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF91606A330;
	Sat,  7 Nov 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQykvE30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931031F0089F;
	Sat,  7 Nov 2026 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062586;
	bh=k6UHpei5WaCkoSNSr+aLeRvcCFtFDaolHfj3fBlEnzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQykvE30U/dhgBHs0O1kTN5JFzS/kk+18ZIOB65dA2aNz4Y5l+NbqKPYrQOcwAfMN
	 t9h7Bq5iZhnKB2p0JiNjeuMGK/MI7VMM3uKRirzoo6qX30xxFPvj6ZOYzbqewlbV9Q
	 RGJzJKaYv8mVYjPXBB6jSCh1CpWAVfmbYBvkC6Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1466/1536] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Sat,  7 Nov 2026 08:58:02 -0500
Message-ID: <20261107135039.016878057@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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



