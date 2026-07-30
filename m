Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA03AA187;
	Thu, 30 Jul 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425017; cv=none; b=VDOdoiJShToidhIp1GAZ2Fv9JGQNCDb5QfSVHeDDLdWcExQhVwlY1whKdgt52itq9ahu0he/Bol6V3DPfu/D2/1nfqtNSrrvTpQ35fUgChnr2V7zZTQAiQRwmNY0OzfyXxQjnCBZGeJLNe6ALGRhgiyTo8HPTKthdHcMn7Ht6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425017; c=relaxed/simple;
	bh=/0amhODeb/RHFL9e0aECW46Na09qykSHY0T7o+vnHIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYdV+Zx9lfmyFyrlxZdCvJYmmj43Vj6CDuyUROIJl3+5+cpw66G8bVlGepg5HgrN9sX1+PVe+AIbF35LWNafje5cyR6j9DPACQYpdNMakv0iueGYXQ79Ndlb2eREkwvRdzE3+h5Aoi9gaTi0Zf13zGJw0zIUKpjM/mSLNvsLK+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErX88mc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErX88mc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D7B1F000E9;
	Thu, 30 Jul 2026 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425016;
	bh=AQJm36vfV9jMjGzxuZ8LmCgMEwXlg9Y96KY2+T58dAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErX88mc/Px1Vhk1Y+s/3arj5RsUGBbb+zcIfLSHklZs+PYjGofwfCNLb+6o2f6nCP
	 9b8ZRXcBX/1wh7TciNVxKXs2ZQxBMKhUAl8F7NkThQX4mz53oC8XPoYft96AAgHE15
	 svFKLSGzf0Gy/c1bH0tkfN6LsF38RU1NCuk4ixOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 595/675] dm-verity: fix buffer overflow in FEC calculation
Date: Thu, 30 Jul 2026 16:15:25 +0200
Message-ID: <20260730141457.766214356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e upstream.

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 drivers/md/dm-verity-fec.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index cebcc8fd25d700..d1e4fbc5a21d9b 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -250,7 +250,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -268,7 +268,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index b3460103e0e109..8552b5d3c91527 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -50,7 +50,7 @@ struct dm_verity_fec {
 /* per-bio data */
 struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
-	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
+	int erasures[DM_VERITY_FEC_MAX_ROOTS]; /* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-- 
2.53.0



