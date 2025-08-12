Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607EB26A0EB;
	Tue, 12 Aug 2025 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023745; cv=none; b=GjfGfZ9tBhHbCH6z/fHmZNdflfPkrpMzMEthIvLgJ4J8ZcZa+Tyal/ldThRy7v4GLBfduE82w0PyEYz9AbNjyvQkik/i3htAzj51leCAIw1y0XFJgzeHnSI4cv6IUXr7UzrN+Y/1OZ3aTKkZS1BGcr4wTcd0xT4Nxo0NtKEz2Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023745; c=relaxed/simple;
	bh=dwJcXpVPdgKzCJJehrNm+mM22XynnYAWYN/P73G1QqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pX5taKEpMJOdWjCRnZa1EcnY9k18GzZb2sQKbIfg0iNaU9DdUNwhntn3ZymrEvqUN0Jk6ujgJQsCQg2NpgV0FUq5ZhUEX77D1pf0jnb0bUITpzkOpTiNUpNFag2jaGooaREp9d7o5sGjbCY5S7J0LVj25AnMy5NMyx4+GuaI91Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/E9airV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/E9airV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C353FC4CEF0;
	Tue, 12 Aug 2025 18:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023745;
	bh=dwJcXpVPdgKzCJJehrNm+mM22XynnYAWYN/P73G1QqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/E9airVXs5Pir/3CQe2f2dM7Wr0kmfOgsvtiCKAzl4Ds1VRCfSPP5qTYXLF8eTaq
	 5zBrNaUdRdYosKZ1gEimkvyhVp5CGQJwqtfrLJzaAyMOcn4iJp56Gn21fyV3Nm367B
	 Kp9ST2LkTLBWRNyITJ+rJ/E6ElAF49x8cdC2YH7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 136/627] drm/panthor: Add missing explicit padding in drm_panthor_gpu_info
Date: Tue, 12 Aug 2025 19:27:11 +0200
Message-ID: <20250812173424.478785217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 95cbab48782bf62e4093837dc15ac6133902c12f ]

drm_panthor_gpu_info::shader_present is currently automatically offset
by 4 byte to meet Arm's 32-bit/64-bit field alignment rules, but those
constraints don't stand on 32-bit x86 and cause a mismatch when running
an x86 binary in a user emulated environment like FEX. It's also
generally agreed that uAPIs should explicitly pad their struct fields,
which we originally intended to do, but a mistake slipped through during
the submission process, leading drm_panthor_gpu_info::shader_present to
be misaligned.

This uAPI change doesn't break any of the existing users of panthor
which are either arm32 or arm64 where the 64-bit alignment of
u64 fields is already enforced a the compiler level.

Changes in v2:
- Rename the garbage field into pad0 and adjust the comment accordingly
- Add Liviu's A-b

Changes in v3:
- Add R-bs

Fixes: 0f25e493a246 ("drm/panthor: Add uAPI")
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250606080932.4140010-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/panthor_drm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/drm/panthor_drm.h b/include/uapi/drm/panthor_drm.h
index ad9a70afea6c..3a76c4f2882b 100644
--- a/include/uapi/drm/panthor_drm.h
+++ b/include/uapi/drm/panthor_drm.h
@@ -296,6 +296,9 @@ struct drm_panthor_gpu_info {
 	/** @as_present: Bitmask encoding the number of address-space exposed by the MMU. */
 	__u32 as_present;
 
+	/** @pad0: MBZ. */
+	__u32 pad0;
+
 	/** @shader_present: Bitmask encoding the shader cores exposed by the GPU. */
 	__u64 shader_present;
 
-- 
2.39.5



