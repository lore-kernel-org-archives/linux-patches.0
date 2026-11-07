Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065110;
	b=VXQ5I6tnKTA3t0CjqU2i85TSHccA6/T8u7IZoWbN00/OEDhFK5IkM+l0u/X8y2pL2eRT
	 QwG1q95yesj3YO2/VxsFsR0vrKPZ90DuwIH2uBx9RnZiwBslXZ35bF1CjM71W9/+8V3HS
	 LunyBxKAYgbwy2McpsN//WjuxOz793N9YPSey/nljYWBCxyWCSaTG1WzlczQ1PLPzNOXQ
	 pVbJqyToREv8POyRZBmwejUQypxWuxbFqQesqXSwDZUcJMhRF2fd2mouVspCfOoMExelC
	 QmZKkznyd86c55GTGtQfIqCD6OUDQLAH6hXo8SnIqVDTB8dfH6Kdk2tFpAw51IBiJdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pnt1+F2ggJvQLEyw4MAexblBzT61ybpAgOgOwDB+D2I=;
	b=FotyrmmBdObr8cMoKm7EQPqd9k48wwc1BUgmZSplcZGWTAftvDeEp3Y9iwNkYUki01cn
	 0S7g12rVUh9pY+WXQYkcJXV4iua9MtmZsKrzvlULyedbYtm6n4LMw/Wllzug83K5F4tOI
	 irKHbexGdT1y2KSseEuFPWzreLyj/Q+3IoPF27ng87ARpfZn1wWdHFPPNiyFf30Ii1Pm+
	 zCG02VsZct/EM3Bml1fYY3GONzOJIZiEN+B93uvSgaqAgBEZEUf7MwT5Vgb58YGNn/Tyl
	 ltBQa/50jrCgTmFxzQyrVw37TvtNNOBI3v7XobSAgV8uSihdBjpD37fnZtOsMwlEgtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2n740kVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91B9606A32C;
	Sat,  7 Nov 2026 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2n740kVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370E41F0089F;
	Sat,  7 Nov 2026 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065109;
	bh=Pnt1+F2ggJvQLEyw4MAexblBzT61ybpAgOgOwDB+D2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2n740kVxH/b2RQhWuyBK9Q2lotOcnZ4W6YK0WBJnI4yIxNSCATkGNxoqSyEEdGVvm
	 mo4hWoYxSaCxgYRosAEINNQFRoDThNk/lGSaYg3TRcMBX5YD1K75R3s/gUxa41lRdJ
	 r27eLMTVEh4RzsbfoXyL9oeM76hDgvgWIG1+Zh9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0938/1257] ntfs: fix kmap_local leak in ntfs_check_logfile()
Date: Sat,  7 Nov 2026 08:53:54 -0500
Message-ID: <20261107135005.264172586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a5ec71084996aec76d07e0e530a345cdd202dc1a ]

ntfs_check_logfile() calls kmap_local_folio() on every iteration of its
search loop but kunmap_local() only once per folio. The loop visits
positions 0, 512, 1024, 2048, 4096 and so on. With 4 KiB pages the first
four are in one page, so a mount whose first LogFile folio is in highmem
leaves three entries on the kmap_local stack of the mounting task.
Kernels without HIGHMEM are not affected.

The leaked entries keep migration disabled. nr_pinned of the runqueue
the mount ran on stays raised after the task exits, so taking that CPU
offline blocks forever in balance_hotplug_wait().

The fifth mount in one task reaches KM_MAX_IDX (12 leaked entries plus
4 in the loop) and hits the BUG_ON() in kmap_local_idx_push():

  kernel BUG at mm/highmem.c:480!

On x86-32 the generic entry code also warns on return to user space:

  DEBUG_LOCKS_WARN_ON(current->kmap_ctrl.idx)
  WARNING: include/linux/highmem-internal.h:17 at __do_fast_syscall_32+0x21e/0x550

Map each page once, when it is read, and unmap that address.

Fixes: 5218cd102aec ("ntfs: update misc operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/logfile.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index 1404664dacc01..ce38ce87f8fc8 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -457,7 +457,7 @@ bool ntfs_check_logfile(struct inode *log_vi, struct restart_page_header **rp)
 	struct ntfs_volume *vol = NTFS_SB(log_vi->i_sb);
 	struct address_space *mapping = log_vi->i_mapping;
 	struct folio *folio = NULL;
-	u8 *kaddr = NULL;
+	u8 *kaddr = NULL, *kbase = NULL;
 	struct restart_page_header *rstr1_ph = NULL;
 	struct restart_page_header *rstr2_ph = NULL;
 	int log_page_size, err;
@@ -511,7 +511,7 @@ bool ntfs_check_logfile(struct inode *log_vi, struct restart_page_header **rp)
 
 		if (!folio || folio->index != idx) {
 			if (folio) {
-				kunmap_local(kaddr);
+				kunmap_local(kbase);
 				folio_put(folio);
 			}
 			folio = read_mapping_folio(mapping, idx, NULL);
@@ -520,8 +520,9 @@ bool ntfs_check_logfile(struct inode *log_vi, struct restart_page_header **rp)
 						idx);
 				goto err_out;
 			}
+			kbase = kmap_local_folio(folio, 0);
 		}
-		kaddr = (u8 *)kmap_local_folio(folio, 0) + (pos & ~PAGE_MASK);
+		kaddr = kbase + (pos & ~PAGE_MASK);
 		/*
 		 * A non-empty block means the logfile is not empty while an
 		 * empty block after a non-empty block has been encountered
@@ -574,7 +575,7 @@ bool ntfs_check_logfile(struct inode *log_vi, struct restart_page_header **rp)
 		 * find a valid one further in the file.
 		 */
 		if (err != -EINVAL) {
-			kunmap_local(kaddr);
+			kunmap_local(kbase);
 			folio_put(folio);
 			goto err_out;
 		}
@@ -583,7 +584,7 @@ bool ntfs_check_logfile(struct inode *log_vi, struct restart_page_header **rp)
 			pos = NTFS_BLOCK_SIZE >> 1;
 	}
 	if (folio) {
-		kunmap_local(kaddr);
+		kunmap_local(kbase);
 		folio_put(folio);
 	}
 	if (logfile_is_empty) {
-- 
2.53.0



