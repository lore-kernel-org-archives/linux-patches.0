Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022411;
	b=YoIofqMbXBFr1tvsax4LESbSb2zR6jtPleA983zJRJamQfr5T6k6qkHXEeru1a3Keoli
	 mGRx9jyJtchKTy/l86pfsgL7SDmKENUQAwPoXsNWhcoDr3zTPd5Z25gzqqlkCJOzTvwBm
	 8PnBYxq8Yq3bBrfUBqBZ6ywRY/h7NsPKFxLs74vWwNXrRK98ZZSRPzjCE3rq8EHfj8uN+
	 iVPL2DyVKlurbCdIwrWnGcs0ed4fPKAyYSOv/31QVdJiN27oa+HMLlzdLePPNKMn/V54X
	 F0j8xcOFiSc1QMB5ZapCwVuh1kpna5H9pW1Pce32Q9JFX5/u7qLTMdFomIZxLi1rATg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=USsHGOUXgmPoPus5b+8X/5hj8YapIr0cpFb2Iua+laI=;
	b=keXq8NGKwDtOt1rw9X7FNb+fmILjp5dBuJG6boRRuFTs+Nlcj/QooXvNRfgY1LqgLlkz
	 KL2PSnIAN1ixoYV6ISYssrQrSeDIA/1yk+7lKesZXg3cPNpQU7xCqau1b0xKqF3EVZsbO
	 uRM5LqKBPWtEBiX3eE4eX2T4DU8+k5Qp6GL2i1VoRYgGq7L0GQkDp8b2cwQh+3Bhkr0VC
	 3eAGZhUPvDSUSndTXwFmKcxyqxmEdwb4bhPxwpbOw4wtr4kSCzRESKhuSOsbip7TNZJxf
	 PdKXQgUkHSjV7AmQ9G+0IlVLiZzPl0ifh95SJEEoWvR1BV13m56xaCd+UDowIAey/Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piPNO17L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58890606A31C;
	Wed, 18 Nov 2026 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piPNO17L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A5D1F000C5;
	Wed, 18 Nov 2026 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022411;
	bh=USsHGOUXgmPoPus5b+8X/5hj8YapIr0cpFb2Iua+laI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piPNO17LlTHDPnGZEVakwirdsQ9+Ix6As8EE3J5bPIouOtZbfsh7GKRaW4H2nkjl9
	 ECeB7eFp4U8H46u38chpUMGXYwrJsVsZ3f8HeOqlDpKMdd+JXN/yKbzeEn8BzdlTLL
	 5aj7XZ+PntJMQHlCgzLxZ73t8SGL6dNZf4hGDe3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>
Subject: [PATCH 7.3 2651/2651] drm/panfrost: Fix race when restoring reset state in perfcnt
Date: Wed, 18 Nov 2026 16:04:51 +0100
Message-ID: <20261118150419.483074470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

commit a947f57843f1139821c6f9f94ebe899574e6636e upstream.

struct panfrost_perfcnt::state should always be updated atomically, both
in the dump ioctl and the reset sequence.

Fixes: 9944dd07f3cf ("drm/panfrost: Fix races between perfcnt and reset sequence")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261104-panfrost-reset-races-fixes-v3-2-09868a88c351@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -142,18 +142,17 @@ static int panfrost_perfcnt_dump_locked(
 	 */
 	ret = wait_for_completion_interruptible_timeout(&pfdev->perfcnt->dump_comp,
 							msecs_to_jiffies(1000));
-
 	if (!ret)
 		ret = -ETIMEDOUT;
 
-	/* We need to restore perfcnt state so the next successful dump can relay it to UM */
-	if (ret < 0) {
-		perfcnt->state |= *state;
-		*state = 0;
-		return ret;
-	}
-
 	scoped_guard(rwsem_read, &pfdev->reset.lock) {
+		/* Restore perfcnt state so the next successful dump can relay it to UM */
+		if (ret < 0) {
+			perfcnt->state |= *state;
+			*state = 0;
+			return ret;
+		}
+
 		*state |= perfcnt->state;
 
 		/* UM must re-enable their session before requesting new dumps. */


