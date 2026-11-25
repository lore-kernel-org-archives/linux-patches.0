Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626174;
	b=Jru084MTgEVFlFzIO1V5oavERkG8C1gIckWAqhzcJNvLisdUkhpekIvY2SvsNGOGycG+
	 oknFBNVG8zhxu3Bqzy1Gu4dmTisYFCjR9UETPl9ZLqpF1oeRY+GuIHeoNgVMfqy5dh6cC
	 5KCSHpfk/gAD7KGUumTMYpqQXsAhhOFD7U+VBkD4rtsCzjfIJraprRK3aUfbOTumWWhTZ
	 3gCsdVt3cEslnFr2A1brTs/gVrX3fZ0oV++voPo8jexsFJ5r9Qzmrrok9Pk/IFvp8YBk+
	 flu33fT7ssW9a5a2p4xOOh4lhi8Kpfhq2WC8jz7FXES/xksdqUKq445g3tpLbUMku9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CdVZr5Yl0+O10Zxu/yVoGDTRDfOuf908UGEkkJ260iY=;
	b=bnQSN8730och1SF8fSLHtzEhH6R6ZqxHkqIHc9ToJZm1wViGO4OmMOdFqDNE5YuNe3c/
	 xtahme/Mgbiuv4u8blJhpqdm3Rj8O5Sff+/6Rhx0cs8oSUVcHsmDVGBwFZMsQc+8G5x9s
	 epmGBDX/O/hbN2NwMV+11Y5/BPlI9H3OEdCaXg2RuADr/EaohTqlSX7ZH/BZ0E7ixWrQo
	 gqqITBSQpKTncnIoICE5wXE6iTmZ3KCE/Dj2SwhJat0AGlqBOKHoaSWnWDxnMPX19BAOJ
	 n3IFZGuE0I6U2BBWLUzA0TL4Vyi/tZZjn4z0BhKbg9N0vIMH89z5x9bj52nvB+ocvaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pdl4kNlb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B0C606A321;
	Wed, 25 Nov 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pdl4kNlb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C0D1F000C0;
	Wed, 25 Nov 2026 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626174;
	bh=CdVZr5Yl0+O10Zxu/yVoGDTRDfOuf908UGEkkJ260iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pdl4kNlbM54uo56mN6gWSmQ58MxIQdcYBgrxunKtuPQc1ejf1Dxwn3Gcjxcwy//YN
	 bX7JWwrDk6JEePgiCA8SSnbps8qqUzSVTnfozuFHMpnOrLaE+eYZdvcG7p+z0gUkSk
	 gPVvyqrQCvGW4Gv316RY+rcmOw6+6rg6rHjUr+5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 712/816] dm-crypt: defer async write submission to write thread
Date: Wed, 25 Nov 2026 15:37:40 +0100
Message-ID: <20261125143905.657430382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Josef Schlehofer <pepe.schlehofer@gmail.com>

commit 6fed9e26810f0b466dbcebe35a73d1fd48793ff5 upstream.

With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
bio directly, even when called from kcryptd_async_done(). An async
cipher may run this callback in softirq or with BH disabled, where
submit_bio_noacct() must not be called because it can sleep.

Submit inline only when async is false. Async completions are sent to
the write thread, as is already done for submit_from_crypt_cpus. Use
the async flag rather than in_interrupt(), since callback context
depends on the cipher driver. Sync ciphers still submit inline.

Tested with cryptd in QEMU (x86_64 and arm64) with
CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.

In QEMU:

- 4k writes logging "sleeping function called from invalid context":
  100/100 unpatched, 0/155 patched.
- nr_requests=4 on a loop device: 0/6 unpatched runs completed,
  4/4 patched runs completed.

On the P2020, a warning in blk_mq_run_hw_queue() appeared in the
6th unpatched run and did not appear in 30 patched runs.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2059,8 +2059,9 @@ static void kcryptd_crypt_write_io_submi
 
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
-	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
-	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
+	if (likely(!async) &&
+	    (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ||
+	     test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
 		dm_submit_bio_remap(io->base_bio, clone);
 		return;
 	}


