Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052392;
	b=beqqVT4G6RLOhShYw0upG+TTflSEcYRbISp88VkBLY9Z0y/9VOIeTKxlyPG3IrzcZOuy
	 cQlQp0jUmEHT+Mb+YIqXsEgs6JOjkRSsH1Qt1+dGOUwg9B8ob24JOKD+o62gv5IuVD65s
	 6mf/0r/DllNWWgvMQ3GXbphF9Ho66QZTB5pselKhSazXPRqKiJkfveetX6UcCEvGXU9Q8
	 xmr3rdfaWqS1Pu4OnTVeUBoe7EraU4EJu88j/ueDTb+ETr9XkGNYfWKxxnkWHIu61Px6w
	 nzTuAKWnoypT0oOs9hPfq24AEMSqt5IqfWiJNchuwp5m4dAR7WleTecSU953qKskNig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RmF1hfn/+s7YgHwyVMTo53INIS6wEtTt3vvnpPXleLY=;
	b=Prb2C2UNLGjIIALj3Tl8+U54mk64v/rglKt4E+Bpx+5kpfdOK8zSzvTAhH73g5nWtA1W
	 wHCVstdziJqktYo+8JH2yb4AzVR/rt+whN7u5xcM3GAPwNbukCvlrOznr5y0/Do4Nb03W
	 64Agb0BRhNjVGm9pbvKYLSqUy3l4Vug88+Gr+SY76eDUwHSD+OnIC6HE1VLxhV5n6Igdz
	 SFhhpNRBPilXraSii9pf0XERPjsjVmFtfNzKPNfeG9KUSdL5WuReeMZ9ZBtoxdQkbYjUk
	 D9LkeqjhAhv5P1BR4Z8ifqJilWx8ev1DzBJHbxfzD6N8bTP4hgnrcgW9xZtuPhgcVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ERF5aZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA07606A325;
	Thu, 19 Nov 2026 01:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ERF5aZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6274A1F000C4;
	Thu, 19 Nov 2026 01:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052391;
	bh=RmF1hfn/+s7YgHwyVMTo53INIS6wEtTt3vvnpPXleLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ERF5aZ4XeR4xvbySzF6Ebuv+NiZPZ+wb6uj4yyjRMeHn/wDAQhLgv/W8QvZrm1A4
	 cJGAtDfHUbQrPf+j5sugTGbBN9IkSQl9HiSdpIYK0ZIXP+iFU8IgD0GHwdp+TgsrYB
	 OrifgGe1XVbHWhe/0rZJwU9JUIZOEvXNYmntHt1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0547/2214] fs/ntfs3: fix integer overflow in find_log_rec() causing OOB read
Date: Wed, 18 Nov 2026 15:37:03 +0100
Message-ID: <20261118150032.891288724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d50cda25cabc6..74581f3cf8fc0 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -7,6 +7,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/fs.h>
+#include <linux/overflow.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 
@@ -2459,7 +2460,8 @@ static int find_log_rec(struct ntfs_log *log, u64 lsn, struct lcb *lcb)
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



