Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036156;
	b=kjIXHvEKNK6t/rAaULBJCsQs59BeelQrl0DV8UQbMP+fCXHB9G8DaiBDFGWiphA0kVd1
	 vDq1C1BIb/tUAHitrnyi9spWXMqSNM2GpUbg3d9PKGy28elXysYiA1+xBHOOWxguVmlbb
	 hAOo2BGebzjD/m0XDGoc/Hs9kfxXNuDl6rKqZQWMq5qWRlO6gUoO+hsG7UMPQZwxh0Oq6
	 wthgC04+zEogtkliMOxYllXhDy4QPEVjI+fLoV0Ls/ATIesryrxv5JstIKwPqdcE0hNpF
	 3XUHgX9V7DDmIyymi/0ux+zOhHp87JhZM4qDzQLC+DP8DPg8wi1i02pXcIZ8c/oDQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYAVIi+qlGKaHXp3+qHJEp4NJg3A3ksP2dGunnPz7nE=;
	b=q9RlMA1/oBfUWT7ho6BfGmIaiq87d5Mj+QdwbLP0am1xwIQu5LZR59q+DHV0HaPo3Nr4
	 TB6FpzY9gHKT0ng8m/n53v+JqghhAuOMo58m6T7ZjtKNi0Y31Cg2jPOtq7pgMzqs3Woq0
	 JDuCfPOAThJpAIy5Nj1C62eDezyPhayZuTsjfUKTQ9u5A5Jc393RCvSHhbbZz12dUdiGQ
	 seZA84fKfxcZ6g1at3mRfpXvoImbcxTbj4TLDXezXDBV3Z7nzxhO9nMl+40sSZjI6MWnQ
	 e0McoVud+j2Oqx1dyuF4KAAiGGnAxAYTUvO93O/rA/tqVKSOxJc0PP0d7514mP5Oktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tX6dGOkK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C654606A320;
	Wed, 18 Nov 2026 21:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tX6dGOkK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBAD1F000C8;
	Wed, 18 Nov 2026 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036156;
	bh=tYAVIi+qlGKaHXp3+qHJEp4NJg3A3ksP2dGunnPz7nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tX6dGOkKcx6ncFkasA+uIz03MbETTIBbOlqvb6i7kHfTUBVSafxcPwXM0O/c5BGxC
	 KcOnvgeIebTdicEmGBrqlQveFE+2zAI5lWFNEUjcggKoAVcmx9Ux3w79kK3d1Q1XiI
	 C+4fuLbFmISHU5gQPM1rcF4gKluzvPf/IH2OeTeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0958/3318] fs/ntfs3: fix integer overflow in find_log_rec() causing OOB read
Date: Wed, 18 Nov 2026 15:26:20 +0100
Message-ID: <20261118150348.378876877@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit e2fcb0040b0b4097b2e97f3fbe77d3b66df9e816 ]

find_log_rec() validates the on-disk LFS_RECORD_HDR.client_data_len
field (`len`, a raw u32 read straight from a mounted $LogFile page)
against the log's total available space:

    len = le32_to_cpu(rh->client_data_len);
    rec_len = len + log->record_header_len;
    if (rec_len >= log->total_avail)
            return -EINVAL;

The addition is unchecked. For len in [0xffffffd0, 0xffffffff] (i.e.
log->record_header_len away from UINT_MAX), `rec_len` wraps to a small
u32 value that trivially clears the `rec_len >= log->total_avail`
guard, so a record whose declared length is actually ~4 GiB is
reported as valid and in-page.

Because find_log_rec() wrongly accepts the record, its caller
read_log_rec_lcb() hands it back to log_replay() as good. On the
transaction-table replay leg, log_replay() re-derives the record
length directly from the same raw, still-unclamped client_data_len
field and uses it to size the restart-table blob:

    rec_len = le32_to_cpu(frh->client_data_len);   /* ~0xffffffff */
    ...
    t16 = le16_to_cpu(lrh->redo_off);
    rt  = Add2Ptr(lrh, t16);
    t32 = rec_len - t16;                            /* still ~4 GiB */
    if (!check_rstbl(rt, t32))
            return -EINVAL;

check_rstbl()'s own `bytes < ts` bounds guard is defeated because the
caller-supplied `bytes` (t32) is itself the poisoned ~4 GiB value, so
the guard can never trigger. The subsequent entry-validation loop then
walks `rt->used` (also attacker-controlled) entries of
sizeof(struct RESTART_TABLE) == 0x18 bytes each straight past the end
of the kmalloc(log->page_size) log-page buffer allocated in
read_log_page(), producing an out-of-bounds read that is reachable
simply by mounting a crafted $LogFile (no genuine dirty-page /
crash-recovery state is required). Confirmed via KASAN as a
slab-out-of-bounds read in check_rstbl(), called from log_replay() ->
ntfs_loadlog_and_replay() -> ntfs_fill_super() -> mount(2).

Fix the root cause instead of hardening every downstream consumer of
the poisoned length: make the addition in find_log_rec() overflow-safe
with check_add_overflow(), mirroring the pattern fs/ntfs3/run.c
already uses to validate other attacker-controlled on-disk
length/offset arithmetic decoded from MAPPING_PAIRS runs, e.g.:

    if (check_add_overflow(vcn64, len, &next_vcn))
            return -EINVAL;
    ...
    if (check_add_overflow(lcn, len, &lcn_end))
            return -EINVAL;

(fs/ntfs3/run.c, run_unpack()).

With the overflow rejected instead of silently wrapped, `rec_len` is
only ever a true, non-wrapped sum, so the existing
`rec_len >= log->total_avail` check now correctly rejects any
oversized record up front. log_replay()'s transaction-table leg then
never gets a chance to re-read the poisoned client_data_len, and
check_rstbl() is never invoked with an attacker-inflated `bytes` for
this path.

Verified on a v6.19 KASAN build: mounting a crafted $LogFile whose
client_data_len overflows trips a KASAN slab-out-of-bounds-read
report in check_rstbl() before this fix; with check_add_overflow()
applied, the same image is cleanly rejected during log replay and no
KASAN report fires.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index cd40a4ddc53d7..7c26fc591e2fa 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -7,6 +7,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/fs.h>
+#include <linux/overflow.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 
@@ -2455,7 +2456,8 @@ static int find_log_rec(struct ntfs_log *log, u64 lsn, struct lcb *lcb)
 	 * Check that the length field isn't greater than the total
 	 * available space the log file.
 	 */
-	rec_len = len + log->record_header_len;
+	if (check_add_overflow(len, log->record_header_len, &rec_len))
+		return -EINVAL;
 	if (rec_len >= log->total_avail)
 		return -EINVAL;
 
-- 
2.53.0



